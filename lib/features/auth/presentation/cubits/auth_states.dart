/*


All Auth States on the screen

*/

import 'package:izahs/features/auth/domain/entities/app_user.dart';

abstract class AuthState {}

// 01. initial

class AuthInitial extends AuthState {}

// 02. loading...

class AuthLoading extends AuthState {}

// 03. authenticated
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}

// 04. unauthenticated
class Unauthenticated extends AuthState {}

// 05. error state
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
