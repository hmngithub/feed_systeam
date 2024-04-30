import '../../domain/entities/converse_user.g.dart';
import '../../domain/entities/user_role.g.dart';

enum AuthStateStatus {
  idle,
  invalid,

  settingRole,
  settedRole,
  failedSettingRole,

  fetchingUserRole,
  fetchedUserRole,
  failedFetchUserRole,

  streamingUserRoles,
  streamedUserRoles,
  failedStreamUserRoles,

  creatingUserRole,
  createdUserRole,
  failedCreatingUserRole,

  streaming,
  streamed,
  failedStream,

  signingUp,
  signedUp,
  failedSignup,

  signingIn,
  signedIn,
  failedSignin,

  signingOut,
  signedOut,
  failedSignout,

  changingEmail,
  changedEmail,
  failedChangeEmail,

  changingPass,
  changedPass,
  failedChangePass,

  updating,
  updated,
  failedUpdate,

  deleting,
  deleted,
  failedDelete,

  resetingPass,
  resettedPass,
  confirmingPassReset,
  confirmedPassReset,
  failedPassReset,

  registeringUser,
  registeredUser,
  failedRegisterUser,
}

extension AuthStateStatusParser on AuthStateStatus {
  bool get isIdle => this == AuthStateStatus.idle;
  bool get isInvalid => this == AuthStateStatus.invalid;

  bool get isSettingRole => this == AuthStateStatus.settingRole;
  bool get isSettedRole => this == AuthStateStatus.settedRole;
  bool get isFailedSettingRole => this == AuthStateStatus.failedSettingRole;

  bool get isFetchingUserRole => this == AuthStateStatus.fetchingUserRole;
  bool get isFetchedUserRole => this == AuthStateStatus.fetchedUserRole;
  bool get isFailedFetchUserRole => this == AuthStateStatus.failedFetchUserRole;

  bool get isStreamingUserRoles => this == AuthStateStatus.streamingUserRoles;
  bool get isStreamedUserRoles => this == AuthStateStatus.streamedUserRoles;
  bool get isFailedStreamUserRoles =>
      this == AuthStateStatus.failedStreamUserRoles;

  bool get isCreatingUserRole => this == AuthStateStatus.creatingUserRole;
  bool get isCreatedUserRole => this == AuthStateStatus.createdUserRole;
  bool get isFailedCreatingUserRole =>
      this == AuthStateStatus.failedCreatingUserRole;

  bool get isStreaming => this == AuthStateStatus.streaming;
  bool get isStreamed => this == AuthStateStatus.streamed;
  bool get isFailedStream => this == AuthStateStatus.failedStream;

  bool get isSigningUp => this == AuthStateStatus.signingUp;
  bool get isSignedUp => this == AuthStateStatus.signedUp;
  bool get isFailedSignup => this == AuthStateStatus.failedSignup;

  bool get isSigningIn => this == AuthStateStatus.signingIn;
  bool get isSignedIn => this == AuthStateStatus.signedIn;
  bool get isFailedSignin => this == AuthStateStatus.failedSignin;

  bool get isSigningOut => this == AuthStateStatus.signingOut;
  bool get isSignedOut => this == AuthStateStatus.signedOut;
  bool get isFailedSignout => this == AuthStateStatus.failedSignout;

  bool get isChangingEmail => this == AuthStateStatus.changingEmail;
  bool get isChangedEmail => this == AuthStateStatus.changedEmail;
  bool get isFailedChangeEmail => this == AuthStateStatus.failedChangeEmail;

  bool get isChangingPass => this == AuthStateStatus.changingPass;
  bool get isChangedPass => this == AuthStateStatus.changedPass;
  bool get isFailedChangePass => this == AuthStateStatus.failedChangePass;

  bool get isUpdating => this == AuthStateStatus.updating;
  bool get isUpdated => this == AuthStateStatus.updated;
  bool get isFailedUpdate => this == AuthStateStatus.failedUpdate;

  bool get isDeleting => this == AuthStateStatus.deleting;
  bool get isDeleted => this == AuthStateStatus.deleted;
  bool get isFailedDelete => this == AuthStateStatus.failedDelete;

  bool get isResetingPass => this == AuthStateStatus.resetingPass;
  bool get isResettedPass => this == AuthStateStatus.resettedPass;
  bool get isConfirmingPassReset => this == AuthStateStatus.confirmingPassReset;
  bool get isConfirmedPassReset => this == AuthStateStatus.confirmedPassReset;
  bool get isFailedPassReset => this == AuthStateStatus.failedPassReset;

  bool get isRegisteringUser => this == AuthStateStatus.registeringUser;
  bool get isRegisteredUser => this == AuthStateStatus.registeredUser;
  bool get isFailedRegisterUser => this == AuthStateStatus.failedRegisterUser;

  bool get isLoading {
    if (isSettingRole) return true;
    if (isStreaming) return true;
    if (isSigningUp) return true;
    if (isSigningIn) return true;
    if (isSigningOut) return true;
    if (isChangingEmail) return true;
    if (isChangingPass) return true;
    if (isUpdating) return true;
    if (isDeleting) return true;
    if (isResetingPass) return true;
    if (isConfirmingPassReset) return true;
    if (isRegisteringUser) return true;
    return false;
  }

  bool get isLoadingGlobally {
    if (isSettingRole) return true;
    if (isStreaming) return true;
    if (isSigningUp) return true;
    if (isSigningIn) return true;
    if (isSigningOut) return true;
    if (isDeleting) return true;
    if (isResetingPass) return true;
    if (isConfirmingPassReset) return true;
    return false;
  }

  bool get isSuccess {
    if (isSettedRole) return true;
    if (isStreamed) return true;
    if (isSignedUp) return true;
    if (isSignedIn) return true;
    if (isSignedOut) return true;
    if (isChangedEmail) return true;
    if (isChangedPass) return true;
    if (isUpdated) return true;
    if (isDeleted) return true;
    if (isResettedPass) return true;
    if (isConfirmedPassReset) return true;
    if (isRegisteredUser) return true;
    return false;
  }

  bool get isFailure {
    if (isFailedSettingRole) return true;
    if (isFailedStream) return true;
    if (isFailedSignup) return true;
    if (isFailedSignin) return true;
    if (isFailedSignout) return true;
    if (isFailedChangeEmail) return true;
    if (isFailedChangePass) return true;
    if (isFailedUpdate) return true;
    if (isFailedDelete) return true;
    if (isFailedPassReset) return true;
    if (isFailedRegisterUser) return true;
    if (isRegisteredUser) return true;
    return false;
  }

  static AuthStateStatus fromName(
    String? name, [
    AuthStateStatus value = AuthStateStatus.idle,
  ]) {
    if (name == null) return value;
    try {
      return AuthStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class AuthState {
  final AuthStateStatus status;
  final String? error;
  final bool isSignedIn;
  final ConverseUser user;
  final UserRole userRole;
  final List<UserRole> userRoles;

  const AuthState({
    required this.status,
    required this.error,
    required this.isSignedIn,
    required this.user,
    required this.userRole,
    required this.userRoles,
  });

  const AuthState.init({
    this.status = AuthStateStatus.idle,
    this.error,
    this.isSignedIn = false,
    this.user = const ConverseUser.init(),
    this.userRole = const UserRole.init(),
    this.userRoles = const [],
  });

  AuthState copyWith({
    AuthStateStatus? status,
    String? error,
    bool? isSignedIn,
    ConverseUser? user,
    UserRole? userRole,
    List<UserRole>? userRoles,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      user: user ?? this.user,
      userRole: userRole ?? this.userRole,
      userRoles: userRoles ?? this.userRoles,
    );
  }

  AuthState idleState() {
    return copyWith(status: AuthStateStatus.idle);
  }

  AuthState loadingState(AuthStateStatus status) {
    return copyWith(status: status);
  }

  AuthState successState(
    AuthStateStatus status, {
    bool? isSignedIn,
    ConverseUser? user,
    UserRole? userRole,
    List<UserRole>? userRoles,
  }) {
    return copyWith(
      status: status,
      isSignedIn: isSignedIn,
      user: user,
      userRole: userRole,
      userRoles: userRoles,
    );
  }

  AuthState failureState(AuthStateStatus status, {dynamic error}) {
    return copyWith(status: status, error: '$error');
  }
}
