enum AuthMethod {
  idle,
  email,
  phone,
  apple,
  google,
  facebook,
  unknown,
}

extension AuthMethodParser on AuthMethod {
  bool get isIdle => this == AuthMethod.idle;
  bool get isEmail => this == AuthMethod.email;
  bool get isPhone => this == AuthMethod.phone;
  bool get isApple => this == AuthMethod.apple;
  bool get isGoogle => this == AuthMethod.google;
  bool get isFacebook => this == AuthMethod.facebook;
  bool get isUnknown => this == AuthMethod.unknown;
  static AuthMethod fromName(String? name,
      [AuthMethod value = AuthMethod.unknown]) {
    if (name == null) return value;
    try {
      return AuthMethod.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}
