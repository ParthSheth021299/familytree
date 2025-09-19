import 'package:equatable/equatable.dart';
import 'package:family_tree/adminpanel/member/model/visibility_model.dart';

class VisibilityState extends Equatable {
  final VisibilityModel? visibility;
  final bool loading;

  const VisibilityState({this.visibility, this.loading = false});

  VisibilityState copyWith({VisibilityModel? visibility, bool? loading}) {
    return VisibilityState(
      visibility: visibility ?? this.visibility,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [visibility, loading];
}
