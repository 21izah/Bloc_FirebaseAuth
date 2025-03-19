import 'package:izahs/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);

  Future<AppUser?> registerWithEmailPassowrd(
      String name, String email, String password);

  Future<AppUser?> logout();

  Future<AppUser?> getCurrentUser();
}
