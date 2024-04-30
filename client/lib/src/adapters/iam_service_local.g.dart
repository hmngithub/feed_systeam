import 'dart:math';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:encrypt/encrypt.dart';
import 'package:kooza_flutter/kooza_flutter.dart';

import '../blocs/dtos/connectivity_status.g.dart';
import '../blocs/gateways/iam_service.g.dart';
import '../domain/entities/converse_user.g.dart';
import '../domain/entities/current_role.g.dart';
import '../domain/entities/user_role.g.dart';

class IamServiceLocal implements IamService {
  static const String _authedUser = 'currentUser';
  static const String _usersRepo = 'users';
  final Kooza _kooza;
  IamServiceLocal(
    Kooza kooza,
  ) : _kooza = kooza;

  @override
  Future<String?> refreshAuthToken() {
    throw UnimplementedError();
  }

  @override
  Future<void> setCurrentRole(CurrentRole role) {
    throw UnimplementedError();
  }

  @override
  Stream<List<UserRole>> streamUserRoles() {
    throw UnimplementedError();
  }

  @override
  Future<UserRole> fetchUserRole(String businessId) {
    throw UnimplementedError();
  }

  @override
  Future<void> createUserRole(String businessId, UserRole role) {
    throw UnimplementedError();
  }

  @override
  Stream<ConverseUser?> streamUserChanges() {
    return _kooza
        .singleDoc(_authedUser)
        .snapshots<Map<String, dynamic>>()
        .asyncMap((user) async {
      try {
        if (!user.exists || user.id.isEmpty) return null;

        final cached = await _kooza.collection(_usersRepo).doc(user.id).get();
        return ConverseUser.fromMap(cached.data, cached.id);
      } catch (e) {
        if (kDebugMode) print('Error Fetching Current User: $e');
        throw 'error-fetching-current-user';
      }
    }).handleError((e) {
      if (kDebugMode) print('Error Streaming Auth State: $e');
      throw 'auth-service-state-changes-error';
    });
  }

  @override
  Future<ConverseUser?> fetchAuthState() async {
    try {
      final user = await _kooza.singleDoc(_authedUser).get();
      if (!user.exists && user.id.isEmpty) return null;

      final cached = await _kooza.collection(_usersRepo).doc(user.id).get();
      return ConverseUser.fromMap(cached.data, cached.id);
    } catch (err) {
      if (kDebugMode) print('Error Fetching Current User: $err');
      throw 'error-fetching-current-user';
    }
  }

  @override
  Future<String?> signUpWithEmail(ConverseUser user) async {
    try {
      final id = _generateId();
      final hashedPass = _encryptData(user.password ?? '123456');
      final newUser = user.copyWith(id: id, password: hashedPass);

      await _kooza
          .singleDoc(_authedUser)
          .set<Map<String, dynamic>>(newUser.toMap(false));
      await _kooza.collection(_usersRepo).add(newUser.toMap(false), docId: id);

      return id;
    } catch (e) {
      throw 'ERROR_SIGNING_UP';
    }
  }

  @override
  Future<ConverseUser> signInWithEmail(ConverseUser user) async {
    try {
      final cache = await _kooza.collection(_usersRepo).get();
      var users =
          cache.docs.map((e) => ConverseUser.fromMap(e.data, e.id)).toList();

      final found = users.firstWhere(
        (e) {
          final userPass = _decryptData(e.password ?? '');
          return e.email == user.email && userPass == user.password;
        },
        orElse: () => const ConverseUser.init(),
      );

      if (found.email == null) throw 'INCORRECT_EMAIL_OR_PASSWORD';
      await _kooza.singleDoc(_authedUser).set(found.toMap(false));

      return found;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> changeEmail(ConverseUser user, String newEmail) async {
    try {
      final userId = user.id;
      if (userId == null) throw 'USER_ID_IS_EMTPY';
      final newUser = user.copyWith(email: newEmail);
      await updateUserInfo(newUser);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> changePassword(ConverseUser user, String newPassword) async {
    try {
      final userId = user.id;
      if (userId == null) throw 'USER_ID_IS_EMTPY';
      final encryptedPass = _encryptData(newPassword);
      final newUser = user.copyWith(email: encryptedPass);
      await updateUserInfo(newUser);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> confirmPasswordReset(String code, String newPassword) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserInfo(ConverseUser user) async {
    try {
      final userId = user.id;
      if (userId == null) throw 'USER_ID_IS_EMTPY';

      await _kooza
          .singleDoc(_authedUser)
          .set<Map<String, dynamic>>(user.toMap(false));
      await _kooza.collection(_usersRepo).add(user.toMap(false), docId: userId);
    } catch (e) {
      if (kDebugMode) print('Error Updating ConverseUser Info: $e');
      throw 'error-updating-user-info';
    }
  }

  @override
  Future<void> deleteAccount(ConverseUser user) async {
    try {
      final userId = user.id;
      if (userId == null) throw 'USER_ID_IS_EMTPY';

      await _kooza.singleDoc(_authedUser).delete();
      await _kooza.collection(_usersRepo).doc(userId).delete();
    } catch (e) {
      if (kDebugMode) print('Error Updating Stakeholder Info: $e');
      throw 'error-updating-user-info';
    }
  }

  @override
  Future<String?> registerNewUser(
    ConverseUser currentUser,
    ConverseUser newUser,
  ) async {
    try {
      final id = _generateId();
      final user = newUser.copyWith(id: id);
      await _kooza.collection(_usersRepo).add(user.toMap(false), docId: id);
      return id;
    } catch (e) {
      if (kDebugMode) print('Register ConverseUser with Email Error: $e');
      throw 'register-up-user-with-email-error';
    }
  }

  @override
  Future<void> resetPassword(String emailAddress) {
    throw UnimplementedError();
  }

  @override
  Future<ConverseUser> signInWithApple(ConverseUser user) {
    throw UnimplementedError();
  }

  @override
  Future<ConverseUser> signInWithFacebook(ConverseUser user) {
    throw UnimplementedError();
  }

  @override
  Future<ConverseUser> signInWithGoogle(ConverseUser user) {
    throw UnimplementedError();
  }

  @override
  Future<ConverseUser> signInWithPhone(ConverseUser user) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    try {
      await _kooza.singleDoc(_authedUser).delete();
    } catch (e) {
      if (kDebugMode) print('Error Signing Out ConverseUser: $e');
      throw 'error-signing-out-user';
    }
  }

  String _generateId() {
    var rand = Random();
    final id = rand.nextInt(100000000);
    return 'TUSI${id + 100000000}';
  }

  @override
  Future<ConnectivityStatus> fetchConnectivityStatus() {
    throw UnimplementedError();
  }

  @override
  Stream<ConnectivityStatus> streamConnectivityStatus() {
    throw UnimplementedError();
  }

  String _encryptData(String data) {
    try {
      final key = Key.fromUtf8('AnaarGulDanaDanaAnaarGulDanaDa#1');
      final b64key = Key.fromUtf8(base64Url.encode(key.bytes).substring(0, 32));
      final fernet = Fernet(b64key);
      final encrypter = Encrypter(fernet);
      return encrypter.encrypt(data).base64;
    } catch (e) {
      throw 'FaildEncrypting';
    }
  }

  String _decryptData(String data) {
    try {
      final key = Key.fromUtf8('AnaarGulDanaDanaAnaarGulDanaDa#1');
      final b64key = Key.fromUtf8(base64Url.encode(key.bytes).substring(0, 32));
      final fernet = Fernet(b64key);
      final encrypter = Encrypter(fernet);
      return encrypter.decrypt(Encrypted.fromBase64(data));
    } catch (e) {
      throw 'FailedDecrypting';
    }
  }
}
