/* 
Auth cubit: State Management
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izahs/features/auth/domain/entities/app_user.dart';
import 'package:izahs/features/auth/domain/repos/auth_repo.dart';
import 'package:izahs/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  // keep track of current user
  AppUser? _currrenUser;
  // constructor
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // ALGORITHM

  // 01. check if user is already auuthenticated

  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currrenUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // 02. get current user
  AppUser? get currentUser => _currrenUser;

  // 03. register with email + pw

  Future<void> register(String name, String email, String pw) async {
    try {
      emit(AuthLoading());
      debugPrint('AuthLoading emitted');
      final user = await authRepo.registerWithEmailPassowrd(name, email, pw);

      debugPrint('Repo call completed, user: $user');
      if (user != null) {
        _currrenUser = user;
        emit(Authenticated(user));
        debugPrint('Authenticated emitted');
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      debugPrint('AuthError emitted');
      emit(Unauthenticated());
    }
  }

  // 04. login with email + pw

  Future<void> login(String email, String pw) async {
    debugPrint('Login started');
    try {
      emit(AuthLoading());
      debugPrint('AuthLoading emitted');
      // final user = await authRepo.loginWithEmailPassword(email, pw);
      final user = await authRepo
          .loginWithEmailPassword(email, pw)
          .timeout(const Duration(seconds: 6));
      debugPrint('Repo call completed, user: $user');
      if (user != null) {
        _currrenUser = user;
        emit(Authenticated(user));
        debugPrint('Authenticated emitted');
      } else {
        emit(AuthError("Login failed"));
        debugPrint('AuthError emitted');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      emit(AuthError(e.toString()));
    }
  }

  // logout

  Future<void> logout() async {
    authRepo.logout();
    emit(Unauthenticated());
  }
}
