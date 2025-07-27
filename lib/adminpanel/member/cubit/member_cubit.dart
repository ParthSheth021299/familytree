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

  void subscribeToMembers() {
    emit(MemberLoading());
    _subscription = memberRepository.getMembersStream().listen(
      (members) {
        _allMembers = members;
        _membersController.add(members);
        emit(MemberLoaded(members: members));
      },
      onError: (e) {
        emit(MemberError("Failed to load members: $e"));
      },
    );
  }

  Map<String, List<FamilyMember>> getGroupedMembers() {
    final Map<String, List<FamilyMember>> grouped = {};

    for (var member in _allMembers) {
      final familyKey =
          member.mainRoot ?? 'Unknown'; // or parentId, or familyId
      grouped.putIfAbsent(familyKey, () => []).add(member);
    }

    return grouped;
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
