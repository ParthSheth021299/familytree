import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:family_tree/adminpanel/dependencies/dependencies.dart';
import 'package:family_tree/adminpanel/service/toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  //login auth
  Future<void> login(String email, password) async {
    emit(AuthLoadingState());
    try {
      final error = await authRepository.loginAdmin(email, password);

      if (error != null) {
        showToast("User not found");
        emit(AuthErrorState(errorMessage: error));
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAdminLoggedIn', true);
        emit(AuthSucess());
      }
    } on FirebaseException catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  //Create temp id
  Future<void> createTemp(String email, String password) async {
    try {
      final error = await authRepository.createTempAccount(email, password);
      if (error != null) {
        showToast("Cant create user");
        emit(AuthErrorState(errorMessage: error));
      }
    } on FirebaseException catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  //Logout Auth
  Future<void> logout() async {
    await authRepository.logout();
  }
}
