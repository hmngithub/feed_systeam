import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:kooza_flutter/kooza_flutter.dart';

import '../blocs/dtos/connectivity_status.g.dart';
import '../blocs/gateways/iam_service.g.dart';
import '../domain/entities/converse_user.g.dart';
import '../domain/entities/current_role.g.dart';
import '../domain/entities/user_role.g.dart';
import 'iam_error.g.dart';

class IamServiceFirebase implements IamService {
  static const String _usersRepo = 'users';
  static const String _currentRolesRepo = 'current_roles';
  static const String _userRolesRepo = 'user_roles';

  final Connectivity _connectivity;
  final FirebaseAuth _firebaseAuth;
  // final FacebookAuth _facebookAuth;
  //final GoogleSignIn _googleAuth;
  final FirebaseFirestore _firestore;
  // final String _appleClientID;
  // final Uri _appleRedirectUri;
  final Kooza _kooza;
  final Duration? _ttl;

  IamServiceFirebase({
    required Connectivity connectivity,
    required FirebaseAuth firebaseAuth,
    // required FacebookAuth facebookAuth,
    //required GoogleSignIn googleAuth,
    required FirebaseFirestore firestore,
    required String appleClientID,
    required Uri appleRedirectUri,
    required Kooza kooza,
    Duration? ttl = const Duration(hours: 12),
  })  : _connectivity = connectivity,
        _firebaseAuth = firebaseAuth,
        // _facebookAuth = facebookAuth,
        // _googleAuth = googleAuth,
        _firestore = firestore,
        // _appleClientID = appleClientID,
        // _appleRedirectUri = appleRedirectUri,
        _kooza = kooza,
        _ttl = ttl;

  @override
  Future<ConnectivityStatus> fetchConnectivityStatus() async {
    try {
      final result = await _connectivity.checkConnectivity();
      switch (result) {
        case ConnectivityResult.bluetooth:
          return ConnectivityStatus.bluetooth;
        case ConnectivityResult.wifi:
          return ConnectivityStatus.wifi;
        case ConnectivityResult.ethernet:
          return ConnectivityStatus.ethernet;
        case ConnectivityResult.mobile:
          return ConnectivityStatus.mobile;
        case ConnectivityResult.vpn:
          return ConnectivityStatus.vpn;
        case ConnectivityResult.other:
          return ConnectivityStatus.other;
        default:
          return ConnectivityStatus.none;
      }
    } catch (e) {
      if (kDebugMode) print('${IamError.ConnectivityStatusError.name}: $e');
      return ConnectivityStatus.other;
    }
  }

  @override
  Stream<ConnectivityStatus> streamConnectivityStatus() {
    return _connectivity.onConnectivityChanged
        .asBroadcastStream()
        .map((result) {
      switch (result) {
        case ConnectivityResult.bluetooth:
          return ConnectivityStatus.bluetooth;
        case ConnectivityResult.wifi:
          return ConnectivityStatus.wifi;
        case ConnectivityResult.ethernet:
          return ConnectivityStatus.ethernet;
        case ConnectivityResult.mobile:
          return ConnectivityStatus.mobile;
        case ConnectivityResult.vpn:
          return ConnectivityStatus.vpn;
        case ConnectivityResult.other:
          return ConnectivityStatus.other;
        default:
          return ConnectivityStatus.none;
      }
    }).handleError((e) {
      if (kDebugMode) print('${IamError.ConnectivityStatusError.name}: $e');
      return ConnectivityStatus.other;
    });
  }

  @override
  Future<String?> refreshAuthToken() async {
    try {
      final result = await _firebaseAuth.currentUser?.getIdToken(true);
      return result;
    } catch (e) {
      throw IamError.UserChangesInfoError;
    }
  }

  @override
  Future<void> setCurrentRole(CurrentRole role) async {
    try {
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw IamError.SetCurrentRoleNoUserId;
      final ref = _firestore.collection(_currentRolesRepo).doc(uid);

      if ((await ref.get()).exists) {
        await ref.update(role.copyWith(id: uid).toMap(true));
        await Future.delayed(const Duration(milliseconds: 5000));
        await _firebaseAuth.currentUser?.getIdToken(true);
        return;
      }

      await ref.set(role.copyWith(id: uid).toMap(true));
      await Future.delayed(const Duration(milliseconds: 5000));
      await _firebaseAuth.currentUser?.getIdToken(true);
      return;
    } on IamError catch (_) {
      rethrow;
    } catch (e) {
      throw IamError.FailedSetCurrentRole;
    }
  }

  @override
  Stream<List<UserRole>> streamUserRoles() {
    try {
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw IamError.StreamUserRolesNoUserId;
      final ref = _firestore
          .collection(_userRolesRepo)
          .where('userId', isEqualTo: uid)
          .snapshots();
      return ref.map((q) =>
          q.docs.map((e) => UserRole.fromMap(e.data(), e.id, true)).toList());
    } on IamError catch (_) {
      rethrow;
    } catch (e) {
      throw IamError.StreamUserRolesUknownError;
    }
  }

  @override
  Future<UserRole> fetchUserRole(String businessId) async {
    try {
      if (businessId.trim().isEmpty) throw IamError.FetchUserRoleNoBusinessId;
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw IamError.FetchUserRoleNoUserId;
      final docId = '${uid}__$businessId';
      final ref = await _firestore.collection(_userRolesRepo).doc(docId).get();
      return UserRole.fromMap(ref.data(), ref.id, true);
    } on IamError catch (_) {
      rethrow;
    } catch (e) {
      throw IamError.FetchUserRoleUnknownError;
    }
  }

  @override
  Future<void> createUserRole(String businessId, UserRole role) async {
    try {
      if (businessId.trim().isEmpty) throw IamError.CreateUserRoleNoBusinessId;
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw IamError.CreateUserRoleNoUserId;
      final docId = '${uid}__$businessId';
      final ref = _firestore.collection(_userRolesRepo).doc(docId);
      await ref.set(role.copyWith(id: docId).toMap(true));
      return;
    } on IamError catch (_) {
      rethrow;
    } catch (e) {
      throw IamError.CreateUserRoleUnknownError;
    }
  }

  @override
  Stream<ConverseUser?> streamUserChanges() {
    return _firebaseAuth.userChanges().asyncMap((user) async {
      try {
        final conn = await fetchConnectivityStatus();
        if (conn.isNone) throw IamError.NoInternetConnection;

        final userId = user?.uid;
        if (userId == null) return null;
        if (kDebugMode) print('Userchanges: Signed in user: $userId');

        final token = await user?.getIdTokenResult();
        if (kDebugMode) print('Claims: ${token?.claims}');
        CurrentRole? role;
        if (token?.claims != null) {
          role = CurrentRole.fromMap(token?.claims, userId, false);
        }

        if (await _kooza.singleDoc(userId).exists()) {
          final cached =
              await _kooza.singleDoc(userId).get<Map<String, dynamic>?>();
          if (cached.data != null) {
            final newUser = ConverseUser.fromMap(cached.data, cached.id, false);
            return newUser.copyWith(id: userId, role: role);
          }
        }

        final repoRef = _firestore.collection(_usersRepo).doc(userId);
        final doc = await repoRef.get();

        final newUser = ConverseUser.fromMap(doc.data(), doc.id, true);
        await _kooza
            .singleDoc(doc.id)
            .set<Map<String, dynamic>>(newUser.toMap(false), ttl: _ttl);

        return newUser.copyWith(id: userId, role: role);
      } on IamError catch (_) {
        rethrow;
      } catch (e) {
        throw IamError.UserChangesInfoError;
      }
    }).handleError((err) {
      if (err is IamError) throw err;
      if (err == 'NoInternetConnection') throw err;
      if (kDebugMode) print('${IamError.UserChangesInfoError.name}: $err');
      throw IamError.UserChangesInfoError;
    });
  }

  @override
  Future<ConverseUser?> fetchAuthState() async {
    try {
      final conn = await fetchConnectivityStatus();
      if (conn.isNone) throw IamError.NoInternetConnection;

      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null) return null;

      final token = await _firebaseAuth.currentUser?.getIdTokenResult();
      CurrentRole? role;
      if (token?.claims != null) {
        role = CurrentRole.fromMap(token?.claims, userId, false);
      }

      // Get from cache
      if (await _kooza.singleDoc(userId).exists()) {
        final cached =
            await _kooza.singleDoc(userId).get<Map<String, dynamic>>();
        if (cached.data != null) {
          final newUser = ConverseUser.fromMap(cached.data, cached.id, false);
          return newUser.copyWith(id: userId, role: role);
        }
      }

      final repoRef = _firestore.collection(_usersRepo).doc(userId);
      final doc = await repoRef.get();

      final newUser = ConverseUser.fromMap(doc.data(), doc.id, true);
      await _kooza
          .singleDoc(doc.id)
          .set<Map<String, dynamic>>(newUser.toMap(false), ttl: _ttl);
      return newUser.copyWith(id: userId, role: role);
    } on IamError catch (_) {
      rethrow;
    } catch (err) {
      throw IamError.FetchCurrentUserError;
    }
  }

  @override
  Future<String?> signUpWithEmail(ConverseUser user) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email ?? '',
        password: user.password ?? '',
      );

      await result.user?.updateDisplayName(user.fullName);
      await result.user?.updatePhotoURL(user.imageUrl);
      await result.user?.reload();

      final userId = result.user?.uid;
      if (userId == null) throw IamError.SignupNoUserId;

      final hashedPass = _encryptData(user.password ?? '123456');
      final newUser = user.copyWith(id: userId, password: hashedPass);

      final repoRef = _firestore.collection(_usersRepo).doc(userId);
      await repoRef.set(newUser.toMap(true));

      // Add to cache
      final cacheRef = _kooza.singleDoc(userId);
      await cacheRef.set<Map<String, dynamic>>(newUser.toMap(false), ttl: _ttl);
      return userId;
    } on IamError catch (_) {
      rethrow;
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case 'email-already-in-use':
          throw IamError.SignupEmailAlreadyInUse;
        case 'invalid-email':
          throw IamError.SignupInvalidEmail;
        case 'operation-not-allowed':
          throw IamError.SignupNotAllowed;
        case 'weak-password':
          throw IamError.SignupWeakPassword;
        default:
          throw IamError.SignupUnknownError;
      }
    } catch (err) {
      if (kDebugMode) print('${IamError.SignupUnknownError.name}: $err');
      throw IamError.SignupUnknownError;
    }
  }

  @override
  Future<ConverseUser> signInWithEmail(ConverseUser user) async {
    try {
      final credentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email ?? '',
        password: user.password ?? '',
      );

      final userId = credentials.user?.uid;
      if (userId == null) throw IamError.SigninNoUserId;

      // Get from cache
      if (await _kooza.singleDoc(userId).exists()) {
        final cached =
            await _kooza.singleDoc(userId).get<Map<String, dynamic>>();
        if (cached.data != null) {
          return ConverseUser.fromMap(cached.data, cached.id, false);
        }
      }

      final ref = _firestore.collection(_usersRepo).doc(userId);
      final doc = await ref.get();

      final newUser = ConverseUser.fromMap(doc.data(), doc.id, true);
      await _kooza
          .singleDoc(doc.id)
          .set<Map<String, dynamic>>(newUser.toMap(false), ttl: _ttl);
      return newUser;
    } on IamError catch (_) {
      rethrow;
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case 'invalid-email':
          throw IamError.SigninInvalidEmail;
        case 'user-disabled':
          throw IamError.SigninUserDisabled;
        case 'user-not-found':
          throw IamError.SigninUserNotFound;
        case 'wrong-password':
          throw IamError.SigninWrongPassword;
        default:
          throw IamError.SigninUnknownError;
      }
    } catch (e) {
      if (kDebugMode) print('${IamError.SigninUnknownError.name}: $e');
      throw IamError.SigninUnknownError;
    }
  }

  @override
  Future<ConverseUser> signInWithPhone(ConverseUser user) async {
    return user;
  }

  @override
  Future<ConverseUser> signInWithGoogle(ConverseUser user) async {
    throw "";
    // try {
    //   GoogleSignInAccount? googleResult;
    //   // if (kIsWeb) {
    //   //   googleResult = await _googleAuth.signInSilently();
    //   // } else {
    //   googleResult = await _googleAuth.signIn();
    //   // }

    //   final googleAuth = await googleResult?.authentication;
    //   final credential = GoogleAuthProvider.credential(
    //     idToken: googleAuth?.idToken,
    //     accessToken: googleAuth?.accessToken,
    //   );

    //   final result = await _firebaseAuth.signInWithCredential(credential);

    //   final userId = result.user?.uid;
    //   if (userId == null) throw IamError.SigninNoUserId;
    //   final newUser = user.copyWith(
    //     id: result.user?.uid,
    //     firstName: result.user?.displayName,
    //     imageUrl: result.user?.photoURL,
    //     email: result.user?.email,
    //   );

    //   // Get from cache
    //   if (await _kooza.singleDoc(userId).exists()) {
    //     final cached =
    //         await _kooza.singleDoc(userId).get<Map<String, dynamic>>();
    //     if (cached.data != null) {
    //       return ConverseUser.fromMap(cached.data, cached.id, false);
    //     }
    //   }

    //   final ref = _firestore.collection(_usersRepo).doc(newUser.id);
    //   final doc = await ref.get();
    //   if (doc.exists) {
    //     final newUser = ConverseUser.fromMap(doc.data(), doc.id, true);
    //     await _kooza
    //         .singleDoc(doc.id)
    //         .set<Map<String, dynamic>>(newUser.toMap(false), ttl: _ttl);
    //     return newUser;
    //   } else {
    //     await ref.set(newUser.toMap(true));
    //     await _kooza
    //         .singleDoc(doc.id)
    //         .set<Map<String, dynamic>>(newUser.toMap(false), ttl: _ttl);
    //     return newUser;
    //   }
    // } on IamError catch (_) {
    //   rethrow;
    // } on FirebaseAuthException catch (err) {
    //   switch (err.code) {
    //     case 'account-exists-with-different-credential':
    //       throw IamError.SigninAccountExists;
    //     case 'invalid-credential':
    //       throw IamError.SigninInvalidCredential;
    //     case 'operation-not-allowed':
    //       throw IamError.SigninNotAllowed;
    //     case 'user-disabled':
    //       throw IamError.SigninUserDisabled;
    //     case 'user-not-found':
    //       throw IamError.SigninUserNotFound;
    //     case 'wrong-password':
    //       throw IamError.SigninWrongPassword;
    //     case 'invalid-verification-code':
    //       throw IamError.SigninInvalidCode;
    //     case 'invalid-verification-id':
    //       throw IamError.SigninInvalidId;
    //     default:
    //       throw IamError.SigninUnknownError;
    //   }
    // } catch (e) {
    //   if (kDebugMode) print('${IamError.SigninUnknownError.name}: $e');
    //   throw IamError.SigninUnknownError;
    // }
  }

  // @override
  // Future<ConverseUser> signInWithFacebook(ConverseUser user) async {
  //   try {
  //     final LoginResult facebookResult = await _facebookAuth.login(
  //       permissions: [
  //         'public_profile',
  //         'email',
  //         // 'pages_show_list',
  //         // 'pages_messaging',
  //         // 'pages_manage_metadata'
  //       ],
  //     );
  //     final token = facebookResult.accessToken?.token;
  //     final credential = FacebookAuthProvider.credential(token ?? '');

  //     final result = await _firebaseAuth.signInWithCredential(credential);

  //     final info = await _facebookAuth.getUserData();
  //     final newUser = user.copyWith(
  //       id: result.user?.uid,
  //       firstName: info['name'] as String?,
  //       imageUrl: info['picture']['data']['url'] as String?,
  //       email: info['email'] as String?,
  //     );

  //     final userId = result.user?.uid;
  //     if (userId == null) throw 'signed-in-user-id-is-empty';

  //     // Get from cache
  //     if (await _kooza.singleDoc(userId).exists()) {
  //       final cached = await _kooza.singleDoc(userId).get<Map<String, dynamic>>();
  //       if (cached.data != null) {
  //         return ConverseUser.fromMap(cached.data, cached.id, false);
  //       }
  //     }

  //     final ref = _firestore.collection(_usersRepo).doc(newUser.id);
  //     final doc = await ref.get();
  //     if (doc.exists) {
  //       final newUser = ConverseUser.fromMap(doc.data(), doc.id, true);
  //       await _kooza.singleDoc(doc.id).set<Map<String, dynamic>>(newUser.toMap(false), ttl: _ttl);
  //       return newUser;
  //     } else {
  //       await ref.set(newUser.toMap(true));
  //       await _kooza.singleDoc(doc.id).set<Map<String, dynamic>>(newUser.toMap(false), ttl: _ttl);
  //       return newUser;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     throw e.message ?? e.code;
  //   } catch (err) {
  //     if (kDebugMode) print('Signin ConverseUser with Facebook Error: $err');
  //     throw 'signin-user-with-facebook-error';
  //   }
  // }

  // @override
  // Future<ConverseUser> signInWithApple(ConverseUser user) async {
  //   try {
  //     if (!(await SignInWithApple.isAvailable())) {
  //       throw 'sign-in-with-apple-not-available';
  //     }

  //     final rawNonce = _generateNonce();
  //     final nonce = _sha256ofString(rawNonce);

  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       nonce: nonce,
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       webAuthenticationOptions: WebAuthenticationOptions(
  //         clientId: _appleClientID,
  //         redirectUri: _appleRedirectUri,
  //       ),
  //     );

  //     var credential = OAuthProvider('apple.com').credential(
  //       idToken: appleCredential.identityToken,
  //       rawNonce: rawNonce,
  //     );

  //     final result = await _firebaseAuth.signInWithCredential(credential);
  //     final newUser = user.copyWith(
  //       id: result.user?.uid,
  //       firstName: appleCredential.givenName,
  //       lastName: appleCredential.familyName,
  //       imageUrl: result.user?.photoURL,
  //       email: appleCredential.email,
  //     );

  //     final userId = result.user?.uid;
  //     if (userId == null) throw 'signed-in-user-id-is-empty';

  //     // Get from cache
  //     if (await _kooza.singleDoc(userId).exists()) {
  //       final cached = await _kooza.singleDoc(userId).get<Map<String, dynamic>>();
  //       if (cached.data != null) {
  //         return ConverseUser.fromMap(cached.data, cached.id, false);
  //       }
  //     }

  //     final ref = _firestore.collection(_usersRepo).doc(newUser.id);
  //     final doc = await ref.get();
  //     if (doc.exists) {
  //       final newUser = ConverseUser.fromMap(doc.data(), doc.id, true);
  //       await _kooza.singleDoc(doc.id).set<Map<String, dynamic>>(newUser.toMap(false), ttl: _ttl);
  //       return newUser;
  //     } else {
  //       await ref.set(newUser.toMap(true));
  //       await _kooza.singleDoc(doc.id).set<Map<String, dynamic>>(newUser.toMap(false), ttl: _ttl);
  //       return newUser;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     throw e.message ?? e.code;
  //   } catch (err) {
  //     if (kDebugMode) print('Signin ConverseUser with Apple Error: $err');
  //     throw 'signin-user-with-apple-error';
  //   }
  // }

  @override
  Future<void> updateUserInfo(ConverseUser user) async {
    try {
      final userId = user.id;
      if (userId == null) throw IamError.UpdateUserNoUserId;

      final repoRef = _firestore.collection(_usersRepo).doc(userId);
      await repoRef.update(user.toMap(true));

      await _kooza
          .singleDoc(userId)
          .set<Map<String, dynamic>>(user.toMap(false), ttl: _ttl);
    } on IamError catch (_) {
      rethrow;
    } catch (err) {
      if (kDebugMode) print('${IamError.UpdateUserUnknownError.name}: $err');
      throw IamError.UpdateUserUnknownError;
    }
  }

  @override
  Future<void> changeEmail(ConverseUser user, String newEmail) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email ?? '',
        password: user.password ?? '',
      );
      await result.user?.updateEmail(newEmail);
      await result.user?.reload();

      final hashedPass = _encryptData(user.password ?? '');
      await updateUserInfo(user.copyWith(
        email: newEmail,
        password: hashedPass,
      ));
    } on IamError catch (_) {
      rethrow;
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case 'email-already-in-use':
          throw IamError.UpdateEmailAlreadyInUse;
        case 'invalid-email':
          throw IamError.UpdateEmailInvalidEmail;
        case 'operation-not-allowed':
          throw IamError.UpdateEmailNotAllowed;
        case 'weak-password':
          throw IamError.UpdateEmailWeakPassword;
        case 'requires-recent-login':
          throw IamError.UpdateEmailLoginRequired;
        default:
          throw IamError.UpdateEmailUnknownError;
      }
    } catch (err) {
      if (kDebugMode) print('${IamError.UpdateEmailUnknownError.name}: $err');
      throw IamError.UpdateEmailUnknownError;
    }
  }

  @override
  Future<void> changePassword(ConverseUser user, String newPassword) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email ?? '',
        password: user.password ?? '',
      );

      await result.user?.updatePassword(newPassword);
      await result.user?.reload();

      final hashedPass = _encryptData(newPassword);
      await updateUserInfo(user.copyWith(password: hashedPass));
    } on IamError catch (_) {
      rethrow;
    } on FirebaseAuthException catch (err) {
      switch (err.code) {
        case 'email-already-in-use':
          throw IamError.UpdatePasswordAlreadyInUse;
        case 'invalid-email':
          throw IamError.UpdatePasswordInvalidEmail;
        case 'operation-not-allowed':
          throw IamError.UpdatePasswordNotAllowed;
        case 'weak-password':
          throw IamError.UpdatePasswordWeakPassword;
        case 'requires-recent-login':
          throw IamError.UpdatePasswordLoginRequired;
        default:
          throw IamError.UpdatePasswordUnknownError;
      }
    } catch (err) {
      if (kDebugMode)
        print('${IamError.UpdatePasswordUnknownError.name}: $err');
      throw IamError.UpdatePasswordUnknownError;
    }
  }

  @override
  Future<void> resetPassword(String emailAddress) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: emailAddress);
      return;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'auth/invalid-email':
          throw IamError.PasswordResetInvalidEmail;
        case 'auth/missing-android-pkg-name':
          throw IamError.PasswordResetMissingAndroidPackage;
        case 'auth/missing-ios-bundle-id':
          throw IamError.PasswordResetMissingIosBundleId;
        case 'auth/missing-continue-uri':
          throw IamError.PasswordResetMissingContinueUri;
        case 'auth/unauthorized-continue-uri':
          throw IamError.PasswordResetUnAuthorizedContinueUri;
        case 'auth/invalid-continue-uri':
          throw IamError.PasswordResetInvalidContinueUri;
        case 'auth/user-not-found':
          throw IamError.PasswordResetUserNotFound;
        default:
          throw IamError.PasswordResetUnknownError;
      }
    } catch (err) {
      if (kDebugMode) print('${IamError.PasswordResetUnknownError.name}: $err');
      throw IamError.PasswordResetUnknownError;
    }
  }

  @override
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
      return;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'expired-action-code':
          throw IamError.PasswordResetExpiredCode;
        case 'invalid-action-code':
          throw IamError.PasswordResetInvalidCode;
        case 'user-disabled':
          throw IamError.PasswordResetUserDisabled;
        case 'weak-password':
          throw IamError.PasswordResetWeakPassword;
        case 'user-not-found':
          throw IamError.PasswordResetUserNotFound;
        default:
          throw IamError.PasswordResetUnknownError;
      }
    } catch (err) {
      if (kDebugMode) print('${IamError.PasswordResetUnknownError.name}: $err');
      throw IamError.PasswordResetUnknownError;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _kooza.clearAll();
      return;
    } on FirebaseException catch (_) {
      throw IamError.SignOutUserError;
    } catch (err) {
      if (kDebugMode) print('${IamError.SignOutUserError.name}: $err');
      throw IamError.SignOutUserError;
    }
  }

  @override
  Future<void> deleteAccount(ConverseUser user) async {
    try {
      var ref = _firestore.collection(_usersRepo).doc(user.id);
      if ((await ref.get()).exists) await ref.delete();

      await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email ?? '',
        password: user.password ?? '',
      );
      await _firebaseAuth.currentUser?.delete();
      await _kooza.collection(user.id ?? '').delete();
      await _kooza.clearAll();

      return;
    } catch (err) {
      if (kDebugMode) print('${IamError.DeleteUserError.name}: $err');
      throw IamError.DeleteUserError;
    }
  }

  @override
  Future<String?> registerNewUser(
    ConverseUser currentUser,
    ConverseUser newUser,
  ) async {
    try {
      final userId = await signUpWithEmail(newUser);

      await signInWithEmail(currentUser);
      await _firebaseAuth.currentUser?.reload();

      return userId;
    } on IamError catch (_) {
      rethrow;
    } on FirebaseAuthException catch (_) {
      throw IamError.SecuritySignOut;
    } catch (err) {
      if (kDebugMode) print('${IamError.SecuritySignOut.name}: $err');
      throw IamError.SecuritySignOut;
    }
  }

  // static String _generateNonce([int length = 32]) {
  //   const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  // }

  // static String _sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  @override
  Future<ConverseUser> signInWithApple(ConverseUser user) {
    throw IamError.Unimplemented;
  }

  @override
  Future<ConverseUser> signInWithFacebook(ConverseUser user) {
    throw IamError.Unimplemented;
  }

  String _encryptData(String data) {
    try {
      final key = Key.fromUtf8('AnaarGulDanaDanaAnaarGulDanaDa#1');
      final b64key = Key.fromUtf8(base64Url.encode(key.bytes).substring(0, 32));
      final fernet = Fernet(b64key);
      final encrypter = Encrypter(fernet);
      return encrypter.encrypt(data).base64;
    } catch (e) {
      throw IamError.FaildEncrypting;
    }
  }

  // String _decryptData(String data) {
  //   try {
  //     final key = Key.fromUtf8('AnaarGulDanaDanaAnaarGulDanaDa#1');
  //     final b64key = Key.fromUtf8(base64Url.encode(key.bytes).substring(0, 32));
  //     final fernet = Fernet(b64key);
  //     final encrypter = Encrypter(fernet);
  //     return encrypter.decrypt(Encrypted.fromBase64(data));
  //   } catch (e) {
  //     throw IamError.FailedDecrypting;
  //   }
  // }
}
