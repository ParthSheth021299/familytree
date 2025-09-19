import 'package:family_tree/adminpanel/auth/cubit/auth_cubit.dart';
import 'package:family_tree/adminpanel/member/cubit/member_cubit.dart';
import 'package:family_tree/adminpanel/member/cubit/visibilityCubit/visibility_cubit.dart';
import 'package:family_tree/adminpanel/moments/cubit/moments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocProvider extends StatelessWidget {
  final WidgetBuilder builder;
  const AppBlocProvider({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => MemberCubit()),
        BlocProvider(create: (context) => MomentsCubit()),
        BlocProvider(create: (context) => VisibilityCubit()),
      ],
      child: Builder(builder: builder),
    );
  }
}
