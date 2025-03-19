/* 
Auth cubit: State Management
*/

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
      final user = await authRepo.registerWithEmailPassowrd(name, email, pw);
      if (user != null) {
        _currrenUser = user;
        emit(Authenticated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // 04. login with email + pw
  Future<void> login(String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, pw);
      if (user != null) {
        _currrenUser = user;
        emit(Authenticated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // logout

  Future<void> logout() async {
    authRepo.logout();
    emit(Unauthenticated());
  }
}
