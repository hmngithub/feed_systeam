import '../domain/entities/current_role.g.dart';
import '../domain/enums/auth_method.g.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../adapters/iam_error.g.dart';
import '../domain/entities/user_role.g.dart';

import '../domain/entities/converse_user.g.dart';
import 'gateways/iam_service.g.dart';
import 'states/auth_state.g.dart';

class AuthBloc extends Cubit<AuthState> {
  final IamService _iamService;
  AuthBloc(IamService iamService)
      : _iamService = iamService,
        super(const AuthState.init()) {
    streamUserChanges();
  }

  void setFullName(String? fullName, [bool shoudCache = false]) async {
    if (fullName == null) return;
    List<String> parts = fullName.split(' ');
    if (parts.length == 1) {
      final newUser = state.user.copyWith(firstName: parts[0]);
      emit(state.copyWith(user: newUser));
    } else if (parts.length >= 2) {
      final firstName = parts.removeAt(0);
      final lastName = parts.join(' ');
      final newUser = state.user.copyWith(
        firstName: firstName,
        lastName: lastName,
      );
      emit(state.copyWith(user: newUser));
    }
    if (shoudCache) await updateUserInfo();
  }

  void setUserId(String? id, [bool cache = false]) async {
    if (id == null) return;
    final newUser = state.user.copyWith(id: id);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserImageUrl(String? imageUrl, [bool cache = false]) async {
    if (imageUrl == null) return;
    final newUser = state.user.copyWith(imageUrl: imageUrl);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserNamePrefix(String? namePrefix, [bool cache = false]) async {
    if (namePrefix == null) return;
    final newUser = state.user.copyWith(namePrefix: namePrefix);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserFirstName(String? firstName, [bool cache = false]) async {
    if (firstName == null) return;
    final newUser = state.user.copyWith(firstName: firstName);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserMiddleName(String? middleName, [bool cache = false]) async {
    if (middleName == null) return;
    final newUser = state.user.copyWith(middleName: middleName);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserLastName(String? lastName, [bool cache = false]) async {
    if (lastName == null) return;
    final newUser = state.user.copyWith(lastName: lastName);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserAuthMethod(AuthMethod? authMethod, [bool cache = false]) async {
    if (authMethod == null) return;
    final newUser = state.user.copyWith(authMethod: authMethod);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserEmail(String? email, [bool cache = false]) async {
    if (email == null) return;
    final newUser = state.user.copyWith(email: email);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserPassword(String? password, [bool cache = false]) async {
    if (password == null) return;
    final newUser = state.user.copyWith(password: password);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserRole(CurrentRole? role, [bool cache = false]) async {
    if (role == null) return;
    final newUser = state.user.copyWith(role: role);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserRegisterDate(DateTime? registerDate, [bool cache = false]) async {
    if (registerDate == null) return;
    final newUser = state.user.copyWith(registerDate: registerDate);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserCreationDate(DateTime? creationDate, [bool cache = false]) async {
    if (creationDate == null) return;
    final newUser = state.user.copyWith(creationDate: creationDate);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserCreatorId(String? creatorId, [bool cache = false]) async {
    if (creatorId == null) return;
    final newUser = state.user.copyWith(creatorId: creatorId);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserLastModifiedDate(DateTime? lastModifiedDate,
      [bool cache = false]) async {
    if (lastModifiedDate == null) return;
    final newUser = state.user.copyWith(lastModifiedDate: lastModifiedDate);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void setUserLastModifierId(String? lastModifierId,
      [bool cache = false]) async {
    if (lastModifierId == null) return;
    final newUser = state.user.copyWith(lastModifierId: lastModifierId);
    emit(state.copyWith(user: newUser));
    if (cache) return await updateUserInfo();
  }

  void toInitState() {
    emit(const AuthState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(AuthStateStatus status, dynamic error) {
    emit(state.failureState(status, error: error));
  }

  void refreshAuthToken() async {
    try {
      emit(state.loadingState(AuthStateStatus.streaming));
      await _iamService.refreshAuthToken();
      emit(state.successState(AuthStateStatus.streamed));
    } on IamError catch (e) {
      emit(state.failureState(AuthStateStatus.failedStream, error: e.name));
    } catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedStream,
        error: IamError.UserChangesUnknownError.name,
      ));
    }
  }

  Future<void> setCurrentRole(CurrentRole role) async {
    try {
      emit(state.loadingState(AuthStateStatus.settingRole));
      await _iamService.setCurrentRole(role);
      emit(state.successState(AuthStateStatus.settedRole));
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedSettingRole,
        error: e.name,
      ));
    } catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedSettingRole,
        error: IamError.SetCurrentRoleUknownError.name,
      ));
    }
  }

  StreamSubscription<List<UserRole>>? _userRolesSub;
  Future<void> streamUserRoles() async {
    try {
      emit(state.loadingState(AuthStateStatus.streamingUserRoles));
      await _userRolesSub?.cancel();

      _userRolesSub = _iamService.streamUserRoles().listen((event) {
        emit(state.successState(
          AuthStateStatus.streamedUserRoles,
          userRoles: event,
        ));
      }, onError: (e) {
        if (e is IamError) {
          emit(state.failureState(
            AuthStateStatus.failedStreamUserRoles,
            error: e.name,
          ));
        } else {
          emit(state.failureState(
            AuthStateStatus.failedStreamUserRoles,
            error: IamError.StreamUserRolesUknownError.name,
          ));
        }
      });
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedStreamUserRoles,
        error: e.name,
      ));
    } catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedStreamUserRoles,
        error: IamError.StreamUserRolesUknownError.name,
      ));
    }
  }

  Future<void> fetchUserRole(String businessId) async {
    try {
      emit(state.loadingState(AuthStateStatus.fetchingUserRole));
      final role = await _iamService.fetchUserRole(businessId);

      emit(state.successState(
        AuthStateStatus.fetchedUserRole,
        userRole: role,
      ));
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedFetchUserRole,
        error: e.name,
      ));
    } catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedFetchUserRole,
        error: IamError.FetchUserRoleNoUserId.name,
      ));
    }
  }

  Future<void> createUserRole(String businessId, UserRole role) async {
    try {
      emit(state.loadingState(AuthStateStatus.creatingUserRole));
      await _iamService.createUserRole(businessId, role);
      emit(state.successState(AuthStateStatus.createdUserRole));
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedCreatingUserRole,
        error: e.name,
      ));
    } catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedCreatingUserRole,
        error: IamError.CreateUserRoleUnknownError.name,
      ));
    }
  }

  StreamSubscription<ConverseUser?>? _userChangesSub;
  void streamUserChanges() async {
    try {
      emit(state.loadingState(AuthStateStatus.streaming));
      _userChangesSub?.cancel();

      _userChangesSub = _iamService.streamUserChanges().listen((user) {
        if (user?.id == null) {
          emit(state.successState(
            AuthStateStatus.streamed,
            isSignedIn: false,
          ));
        } else {
          emit(state.successState(
            AuthStateStatus.streamed,
            user: user,
            isSignedIn: true,
          ));
        }
      }, onError: (e) {
        if (e is IamError) {
          emit(state.failureState(
            AuthStateStatus.failedStream,
            error: e.name,
          ));
        } else {
          emit(state.failureState(
            AuthStateStatus.failedStream,
            error: IamError.UserChangesUnknownError.name,
          ));
        }
      });
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedStream,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedStream,
        error: IamError.UserChangesUnknownError.name,
      ));
    }
  }

  void signUpWithEmail() async {
    try {
      emit(state.loadingState(AuthStateStatus.signingUp));
      await _userChangesSub?.cancel();

      var newUser = state.user.copyWith(
        authMethod: AuthMethod.email,
        registerDate: DateTime.now(),
        creationDate: DateTime.now(),
      );

      final newUserId = await _iamService.signUpWithEmail(newUser);
      newUser = newUser.copyWith(id: newUserId);
      emit(state.successState(AuthStateStatus.signedUp, user: newUser));

      streamUserChanges();
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedSignup,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedSignup,
        error: IamError.SignupUnknownError.name,
      ));
    }
  }

  void signInWithEmail() async {
    try {
      emit(state.loadingState(AuthStateStatus.signingIn));
      await _userChangesSub?.cancel();

      final signedIn = await _iamService.signInWithEmail(state.user);
      emit(state.successState(AuthStateStatus.signedIn, user: signedIn));

      streamUserChanges();
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedSignin,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedSignin,
        error: IamError.SigninUnknownError.name,
      ));
    }
  }

  void signInWithPhone(String userRole) async {
    try {
      emit(state.loadingState(AuthStateStatus.signingIn));
      await _userChangesSub?.cancel();

      final newUser = state.user.copyWith(authMethod: AuthMethod.phone);
      final user = await _iamService.signInWithPhone(newUser);
      emit(state.successState(AuthStateStatus.signedIn, user: user));

      streamUserChanges();
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedSignin,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedSignin,
        error: IamError.SigninUnknownError.name,
      ));
    }
  }

  void signInWithApple(String userRole) async {
    try {
      emit(state.loadingState(AuthStateStatus.signingIn));
      await _userChangesSub?.cancel();

      final newUser = state.user.copyWith(authMethod: AuthMethod.apple);
      final user = await _iamService.signInWithApple(newUser);
      emit(state.successState(AuthStateStatus.signingIn, user: user));

      streamUserChanges();
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedSignin,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedSignin,
        error: IamError.SigninUnknownError.name,
      ));
    }
  }

  void signInWithGoogle(String userRole) async {
    try {
      emit(state.loadingState(AuthStateStatus.signingIn));
      await _userChangesSub?.cancel();

      final newUser = state.user.copyWith(authMethod: AuthMethod.google);
      final user = await _iamService.signInWithGoogle(newUser);
      emit(state.successState(AuthStateStatus.signingIn, user: user));

      streamUserChanges();
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedSignin,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedSignin,
        error: IamError.SigninUnknownError.name,
      ));
    }
  }

  void signInWithFacebook(String userRole) async {
    try {
      emit(state.loadingState(AuthStateStatus.signingIn));
      await _userChangesSub?.cancel();

      final newUser = state.user.copyWith(authMethod: AuthMethod.facebook);
      final user = await _iamService.signInWithFacebook(newUser);
      emit(state.successState(AuthStateStatus.signingIn, user: user));

      streamUserChanges();
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedSignin,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedSignin,
        error: IamError.SigninUnknownError.name,
      ));
    }
  }

  Future<void> signOut() async {
    try {
      emit(state.loadingState(AuthStateStatus.signingOut));
      await _iamService.signOut();

      emit(state.successState(
        AuthStateStatus.signedOut,
        isSignedIn: false,
        user: const ConverseUser.init(),
      ));
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedSignout,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedSignout,
        error: IamError.SignOutUserError.name,
      ));
    }
  }

  void changeEmail({
    String? currentEmail,
    String? currentPassword,
    String? newEmail,
  }) async {
    if (newEmail == null) return;
    try {
      emit(state.loadingState(AuthStateStatus.changingEmail));

      final oldUser = state.user.copyWith(
          email: currentEmail,
          password: currentPassword,
          lastModifiedDate: DateTime.now());
      await _iamService.changeEmail(oldUser, newEmail);

      emit(state.loadingState(AuthStateStatus.changedEmail));
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedChangeEmail,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedChangeEmail,
        error: IamError.UpdateEmailUnknownError.name,
      ));
    }
  }

  void changePassword({
    String? currentEmail,
    String? currentPassword,
    String? newPassword,
  }) async {
    if (newPassword == null) return;
    try {
      emit(state.loadingState(AuthStateStatus.changingPass));

      final oldUser = state.user.copyWith(
        email: currentEmail,
        password: currentPassword,
        lastModifiedDate: DateTime.now(),
      );
      await _iamService.changePassword(oldUser, newPassword);
      emit(state.successState(AuthStateStatus.changedPass));
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedChangePass,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedChangePass,
        error: IamError.UpdatePasswordUnknownError.name,
      ));
    }
  }

  Future<void> updateUserInfo() async {
    try {
      emit(state.loadingState(AuthStateStatus.updating));
      final newUser = state.user.copyWith(lastModifiedDate: DateTime.now());
      await _iamService.updateUserInfo(newUser);
      emit(state.successState(AuthStateStatus.updated));
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedUpdate,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedUpdate,
        error: IamError.UpdateUserUnknownError.name,
      ));
    }
  }

  void resetPassword(String emailAddress) async {
    try {
      emit(state.loadingState(AuthStateStatus.resetingPass));
      await _iamService.resetPassword(emailAddress);
      emit(state.successState(AuthStateStatus.resettedPass));
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedPassReset,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedPassReset,
        error: IamError.PasswordResetUnknownError.name,
      ));
    }
  }

  void confirmPasswordReset(String code, String newPassword) async {
    try {
      emit(state.loadingState(AuthStateStatus.confirmingPassReset));
      await _iamService.confirmPasswordReset(code, newPassword);
      emit(state.successState(AuthStateStatus.confirmedPassReset));
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedPassReset,
        error: e.name,
      ));
    } catch (_) {
      emit(state.failureState(
        AuthStateStatus.failedPassReset,
        error: IamError.PasswordResetUnknownError.name,
      ));
    }
  }

  void registerNewUser(ConverseUser newUser) async {
    try {
      emit(state.loadingState(AuthStateStatus.registeringUser));
      await _userChangesSub?.cancel();

      final newId = await _iamService.registerNewUser(state.user, newUser);
      if (newId == null) throw 'could not register the user';
      emit(state.successState(AuthStateStatus.registeredUser));

      streamUserChanges();
    } on IamError catch (e) {
      emit(state.failureState(
        AuthStateStatus.failedRegisterUser,
        error: e.name,
      ));
    } catch (err) {
      streamUserChanges();
      emit(state.failureState(
        AuthStateStatus.failedRegisterUser,
        error: IamError.SecuritySignOut.name,
      ));
    }
  }

  @override
  Future<void> close() async {
    await _userRolesSub?.cancel();
    await _userChangesSub?.cancel();
    return super.close();
  }
}
