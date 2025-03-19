/*

Define all operation to be done on profile 
Profile Repository

*/

import 'package:izahs/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  // get user profile
  Future<ProfileUser?> fetchUserProfile(String uid);

  // update user profile
  Future<void> updateProfile(ProfileUser updateProfile);
}
