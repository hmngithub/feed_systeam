// ignore_for_file: constant_identifier_names
enum IamError {
  ConnectivityStatusError,
  NoInternetConnection,
  FaildEncrypting,
  FailedDecrypting,
  CurrentUserHasNoPassword,
  SecuritySignOut,
  DeleteUserError,
  SignOutUserError,

  FailedSetCurrentRole,
  SetCurrentRoleNoUserId,
  SetCurrentRoleUknownError,

  StreamUserRolesNoUserId,
  StreamUserRolesUknownError,

  FetchUserRoleNoUserId,
  FetchUserRoleNoBusinessId,
  FetchUserRoleUnknownError,

  CreateUserRoleNoUserId,
  CreateUserRoleNoBusinessId,
  CreateUserRoleUnknownError,

  PasswordResetInvalidEmail,
  PasswordResetMissingContinueUri,
  PasswordResetMissingAndroidPackage,
  PasswordResetMissingIosBundleId,
  PasswordResetInvalidContinueUri,
  PasswordResetUnAuthorizedContinueUri,
  PasswordResetExpiredCode,
  PasswordResetInvalidCode,
  PasswordResetWeakPassword,
  PasswordResetUserDisabled,
  PasswordResetUserNotFound,
  PasswordResetUnknownError,

  UpdatePasswordAlreadyInUse,
  UpdatePasswordInvalidEmail,
  UpdatePasswordNotAllowed,
  UpdatePasswordWeakPassword,
  UpdatePasswordLoginRequired,
  UpdatePasswordUnknownError,

  UpdateEmailAlreadyInUse,
  UpdateEmailInvalidEmail,
  UpdateEmailNotAllowed,
  UpdateEmailWeakPassword,
  UpdateEmailLoginRequired,
  UpdateEmailUnknownError,

  UpdateUserNoUserId,
  UpdateUserUnknownError,

  SigninNoUserId,
  SigninAccountExists,
  SigninInvalidCredential,
  SigninNotAllowed,
  SigninUserDisabled,
  SigninWrongPassword,
  SigninInvalidCode,
  SigninInvalidId,
  SigninInvalidEmail,
  SigninUserNotFound,
  SigninUnknownError,

  SignupNoUserId,
  SignupEmailAlreadyInUse,
  SignupInvalidEmail,
  SignupNotAllowed,
  SignupWeakPassword,
  SignupUnknownError,

  FetchCurrentUserError,
  UserChangesInfoError,
  UserChangesUnknownError,

  Unimplemented,
}

extension IamErrorExt on IamError {
  bool get isConnectivityStatusError =>
      this == IamError.ConnectivityStatusError;
  bool get isNoInternetConnection => this == IamError.NoInternetConnection;
  bool get isUserChangesInfoError => this == IamError.UserChangesInfoError;
}
