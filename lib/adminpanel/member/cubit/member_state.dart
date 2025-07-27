part of 'member_cubit.dart';

sealed class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object?> get props => [];
}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MemberLoaded extends MemberState {
  final List<FamilyMember> members;

  const MemberLoaded({required this.members});

  @override
  List<Object?> get props => [members];
}

class MemberError extends MemberState {
  final String message;

  const MemberError(this.message);

  @override
  List<Object?> get props => [message];
}

class MemberGroupedByFamilyLoaded extends MemberState {
  final Map<String, List<FamilyMember>> groupedMembers;

  const MemberGroupedByFamilyLoaded({required this.groupedMembers});

  @override
  List<Object?> get props => [groupedMembers];
}
