import '../../domain/entities/converse_user.g.dart';
import '../../domain/entities/current_role.g.dart';
import '../../domain/entities/user_role.g.dart';

import '../dtos/connectivity_status.g.dart';

abstract class IamService {
  Stream<ConnectivityStatus> streamConnectivityStatus();
  Future<ConnectivityStatus> fetchConnectivityStatus();
  Future<String?> refreshAuthToken();
  Future<void> setCurrentRole(CurrentRole role);
  Stream<List<UserRole>> streamUserRoles();
  Future<UserRole> fetchUserRole(String businessId);
  Future<void> createUserRole(String businessId, UserRole role);
  Stream<ConverseUser?> streamUserChanges();
  Future<ConverseUser?> fetchAuthState();
  Future<String?> signUpWithEmail(ConverseUser user);
  Future<ConverseUser> signInWithEmail(ConverseUser user);
  Future<ConverseUser> signInWithPhone(ConverseUser user);
  Future<ConverseUser> signInWithFacebook(ConverseUser user);
  Future<ConverseUser> signInWithGoogle(ConverseUser user);
  Future<ConverseUser> signInWithApple(ConverseUser user);
  Future<void> changeEmail(ConverseUser user, String newEmail);
  Future<void> changePassword(ConverseUser user, String newPassword);
  Future<void> resetPassword(String emailAddress);
  Future<void> confirmPasswordReset(String code, String newPassword);
  Future<void> updateUserInfo(ConverseUser user);
  Future<void> signOut();
  Future<void> deleteAccount(ConverseUser user);
  Future<String?> registerNewUser(
      ConverseUser currentUser, ConverseUser newUser);
}
