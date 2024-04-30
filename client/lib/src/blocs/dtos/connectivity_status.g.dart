enum ConnectivityStatus {
  bluetooth,
  wifi,
  ethernet,
  mobile,
  vpn,
  other,
  none,
}

extension ConnectivityStatusExt on ConnectivityStatus {
  bool get isBluetooth => this == ConnectivityStatus.bluetooth;
  bool get isWifi => this == ConnectivityStatus.wifi;
  bool get isEthernet => this == ConnectivityStatus.ethernet;
  bool get isMobile => this == ConnectivityStatus.mobile;
  bool get isVpn => this == ConnectivityStatus.vpn;
  bool get isOther => this == ConnectivityStatus.other;
  bool get isNone => this == ConnectivityStatus.none;
}
