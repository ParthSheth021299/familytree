import 'dart:async';
import 'package:family_tree/adminpanel/dependencies/dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_tree/models/family_member.dart';

part 'member_state.dart';

class MemberCubit extends Cubit<MemberState> {
  final StreamController<List<FamilyMember>> _membersController =
      StreamController.broadcast();
  final StreamController<Map<String, List<FamilyMember>>>
  groupMemberController = StreamController.broadcast();

  StreamSubscription<List<FamilyMember>>? _subscription;
  StreamSubscription<List<FamilyMember>>? _groupSubscription;
  List<FamilyMember> _allMembers = [];

  MemberCubit() : super(MemberInitial());

  Stream<List<FamilyMember>> get membersStream => _membersController.stream;
  Stream<Map<String, List<FamilyMember>>> get groupMembersStream =>
      groupMemberController.stream;

  // void subscribeToMembers() {
  //   emit(MemberLoading());
  //   _subscription = memberRepository.getMembersStream().listen(
  //     (members) {
  //       _allMembers = members;
  //       _membersController.add(members);
  //       emit(MemberLoaded(members: members));
  //     },
  //     onError: (e) {
  //       emit(MemberError("Failed to load members: $e"));
  //     },
  //   );
  // }
  void subscribeToMembers() {
    emit(MemberLoading());

    _subscription = memberRepository.getMembersStream().listen(
      (members) {
        _allMembers = members;

        // Step 1: Build a map of memberId -> FamilyMember for easy lookup
        final Map<String, FamilyMember> memberMap = {
          for (var m in members) m.id: m,
        };

        // Step 2: Enrich each member with their spouse (if exists)
        final enrichedMembers = members.map((m) {
          if (m.spouseId != null && m.spouseId!.isNotEmpty) {
            final spouseData = memberMap[m.spouseId!];
            if (spouseData != null) {
              return m.copyWith(
                spouse: Spouse(
                  id: spouseData.id,
                  name: spouseData.name,
                  gender: spouseData.gender,
                  dob: spouseData.dob,
                  bloodGroup: spouseData.bloodGroup,
                  phone: spouseData.phone,
                  email: spouseData.email,
                  location: spouseData.location,
                  whatsapp: '',
                  photoUrl: '',
                  isAlive: spouseData.isAlive,
                  createdBy: spouseData.createdBy,
                ),
              );
            }
          }
          return m;
        }).toList();

        // Step 3: Push enriched members to stream
        _membersController.add(enrichedMembers);
        emit(MemberLoaded(members: enrichedMembers));
      },
      onError: (e) {
        emit(MemberError("Failed to load members: $e"));
      },
    );
  }

  // Map<String, List<FamilyMember>> getGroupedMembers() {
  //   final Map<String, List<FamilyMember>> grouped = {};

  //   for (var member in _allMembers) {
  //     final familyKey =
  //         member.mainRoot ?? 'Unknown'; // or parentId, or familyId
  //     grouped.putIfAbsent(familyKey, () => []).add(member);
  //     print("GROP  MEMEBER ${member}");
  //   }

  //   return grouped;
  // }
  // Map<String, List<FamilyMember>> getGroupedMembers() {
  //   final Map<String, List<FamilyMember>> grouped = {};

  //   for (var member in _allMembers) {
  //     final familyKey = member.createdBy ?? 'Unknown';
  //     grouped.putIfAbsent(familyKey, () => []).add(member);
  //   }

  //   return grouped;
  // }
  // Map<String, List<FamilyMember>> getGroupedMembers() {
  //   final Map<String, List<FamilyMember>> grouped = {};

  //   // Step 1: group by createdBy (main family creator)
  //   for (var member in _allMembers) {
  //     final familyKey = member.createdBy ?? 'Unknown';
  //     grouped.putIfAbsent(familyKey, () => []).add(member);
  //   }

  //   // Step 2: inside each group, re-check for "roots"
  //   final Map<String, List<FamilyMember>> adjusted = {};

  //   grouped.forEach((familyKey, members) {
  //     // Find all root candidates
  //     final roots = members
  //         .where((m) => m.parentId == null || m.isRoot == true)
  //         .toList();

  //     if (roots.isEmpty) {
  //       // Fallback: if root is deleted, promote direct children of deleted root
  //       final orphanCandidates = members.where((m) {
  //         // If their parent does not exist in current list
  //         return m.parentId != null && !members.any((x) => x.id == m.parentId);
  //       }).toList();

  //       for (var orphan in orphanCandidates) {
  //         adjusted
  //             .putIfAbsent("${familyKey}_${orphan.id}", () => [])
  //             .addAll(_collectBranch(orphan, members));
  //       }
  //     } else {
  //       // Normal case: group each root branch
  //       for (var root in roots) {
  //         adjusted
  //             .putIfAbsent("${familyKey}_${root.id}", () => [])
  //             .addAll(_collectBranch(root, members));
  //       }
  //     }
  //   });

  //   return adjusted;
  // }
  // Map<String, List<FamilyMember>> getGroupedMembers({String query = ''}) {
  //   final Map<String, List<FamilyMember>> grouped = {};

  //   // Step 1: filter members if search query is given
  //   final filteredMembers = query.isEmpty
  //       ? _allMembers
  //       : _allMembers
  //             .where(
  //               (m) =>
  //                   (m.name ?? '').toLowerCase().contains(query.toLowerCase()),
  //             )
  //             .toList();

  //   // Step 2: roots -> each root or parentless member starts a group
  //   for (var member in filteredMembers) {
  //     if (member.isRoot.toString().isEmpty ||
  //         member.parentId == null ||
  //         member.parentId!.isEmpty) {
  //       grouped[member.id] = [member];
  //     }
  //   }

  //   // Step 3: children -> find their correct root and add them
  //   for (var member in filteredMembers) {
  //     if (!(member.isRoot.toString().isEmpty ||
  //         member.parentId == null ||
  //         member.parentId!.isEmpty)) {
  //       final parentGroupKey = grouped.keys.firstWhere(
  //         (key) => _belongsToRoot(member, key, filteredMembers),
  //         orElse: () => member.createdBy ?? 'Unknown',
  //       );
  //       grouped.putIfAbsent(parentGroupKey, () => []).add(member);
  //     }
  //   }

  //   return grouped;
  // }
  // Map<String, List<FamilyMember>> getGroupedMembers({String query = ''}) {
  //   final Map<String, List<FamilyMember>> grouped = {};

  //   // Step 1: filter members if search query is given
  //   final filteredMembers = query.isEmpty
  //       ? _allMembers
  //       : _allMembers
  //             .where(
  //               (m) =>
  //                   (m.name ?? '').toLowerCase().contains(query.toLowerCase()),
  //             )
  //             .toList();

  //   // Step 2: roots -> each root or parentless member starts a group
  //   for (var member in filteredMembers) {
  //     // ✅ only treat as root if marked root or has no parent
  //     if (member.isRoot ||
  //         member.parentId == null ||
  //         member.parentId!.isEmpty) {
  //       grouped[member.id] = [member];
  //     }
  //   }

  //   // Step 3: children -> find their correct root and add them
  //   for (var member in filteredMembers) {
  //     // ✅ skip spouse-only members (since you’ll show them separately)
  //     if (member.spouseId != null && member.spouseId!.isNotEmpty) {
  //       continue;
  //     }

  //     if (!(member.isRoot ||
  //         member.parentId == null ||
  //         member.parentId!.isEmpty)) {
  //       final parentGroupKey = grouped.keys.firstWhere(
  //         (key) => _belongsToRoot(member, key, filteredMembers),
  //         orElse: () => member.createdBy ?? 'Unknown',
  //       );
  //       grouped.putIfAbsent(parentGroupKey, () => []).add(member);
  //     }
  //   }

  //   return grouped;
  // }
  Map<String, List<FamilyMember>> getGroupedMembers({String query = ''}) {
    final Map<String, List<FamilyMember>> grouped = {};

    // Step 1: Filter members by search query
    final filteredMembers = _allMembers.where((m) {
      return query.isEmpty ||
          (m.name ?? '').toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Step 2: Group by createdBy
    for (var member in filteredMembers) {
      final groupKey = member.createdBy ?? 'Unknown';
      grouped.putIfAbsent(groupKey, () => []);

      // Only add root/parentless members first
      if (member.isRoot ||
          member.parentId == null ||
          member.parentId!.isEmpty) {
        grouped[groupKey]!.add(member);
      }
    }

    // Step 3: Add children to the correct root within the group
    for (var member in filteredMembers) {
      if (!(member.isRoot ||
          member.parentId == null ||
          member.parentId!.isEmpty)) {
        final groupKey = member.createdBy ?? 'Unknown';
        final root = grouped[groupKey]!.firstWhere(
          (m) => _belongsToRoot(member, m.id, filteredMembers),
          orElse: () => grouped[groupKey]!.first,
        );
        final rootIndex = grouped[groupKey]!.indexOf(root);
        grouped[groupKey]!.insert(rootIndex + 1, member);
      }
    }

    return grouped;
  }

  /// Recursive helper: check if a member belongs to a root inside given members
  bool _belongsToRoot(
    FamilyMember member,
    String rootId,
    List<FamilyMember> pool,
  ) {
    if (member.parentId == null) return false;
    if (member.parentId == rootId) return true;

    final parent = pool.firstWhere(
      (m) => m.id == member.parentId,
      orElse: () => FamilyMember.empty(),
    );
    if (parent.id.isEmpty) return false;

    return _belongsToRoot(parent, rootId, pool);
  }

  // Helper: collect full branch recursively from root
  List<FamilyMember> _collectBranch(FamilyMember root, List<FamilyMember> all) {
    final branch = <FamilyMember>[root];
    final children = all.where((m) => m.parentId == root.id).toList();

    for (var child in children) {
      branch.addAll(_collectBranch(child, all));
    }

    return branch;
  }

  void applyFilters(Set<String> filters) {
    _applyFilters(filters);
  }

  void clearFilters() {
    _applyFilters({});
  }

  void _applyFilters(Set<String> filters) {
    final genders = {'male', 'female'};
    final bloodGroups = _allMembers.map((m) => m.bloodGroup).toSet();
    final houseRoots = _allMembers.map((m) => m.mainRoot).toSet();
    final hasChildrenOptions = {'true', 'false'};

    final genderFilter = filters.intersection(genders);
    final bloodGroupFilter = filters.intersection(bloodGroups);
    final houseRootFilter = filters.intersection(houseRoots);
    final hasChildrenFilter = filters.intersection(hasChildrenOptions);

    final filtered = _allMembers.where((m) {
      final matchGender =
          genderFilter.isEmpty || genderFilter.contains(m.gender);
      final matchBlood =
          bloodGroupFilter.isEmpty || bloodGroupFilter.contains(m.bloodGroup);
      final matchRoot =
          houseRootFilter.isEmpty || houseRootFilter.contains(m.mainRoot);
      final matchChildren =
          hasChildrenFilter.isEmpty ||
          hasChildrenFilter.contains(m.hasChildren);
      return matchGender && matchBlood && matchRoot && matchChildren;
    }).toList();

    _membersController.add(filtered);
    emit(MemberLoaded(members: filtered));
  }

  void search(String name) {
    if (name.trim().isEmpty) {
      _membersController.add(_allMembers);
      emit(MemberLoaded(members: _allMembers));
      return;
    }

    final matched = _allMembers
        .where((m) => m.name.toLowerCase().contains(name.toLowerCase()))
        .toList();

    _membersController.add(matched);
    emit(MemberLoaded(members: matched));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _membersController.close();
    return super.close();
  }
}
