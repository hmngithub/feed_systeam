class ConverseSettings {
  /// identity-related
  final String? id;
  final String? userId;
  final String? businessId;
  final Map<String, dynamic> settings;

  /// CRUD-related
  final DateTime? creationDate;
  final String? creatorId;
  final DateTime? lastModifiedDate;
  final String? lastModifierId;

  const ConverseSettings({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.settings,
    required this.creationDate,
    required this.creatorId,
    required this.lastModifiedDate,
    required this.lastModifierId,
  });

  const ConverseSettings.init({
    this.id,
    this.userId,
    this.businessId,
    this.settings = const <String, dynamic>{},
    this.creationDate,
    this.creatorId,
    this.lastModifiedDate,
    this.lastModifierId,
  });

  ConverseSettings copyWith({
    String? id,
    String? userId,
    String? businessId,
    Map<String, dynamic>? settings,
    DateTime? creationDate,
    String? creatorId,
    DateTime? lastModifiedDate,
    String? lastModifierId,
  }) {
    return ConverseSettings(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      settings: settings ?? this.settings,
      creationDate: creationDate ?? this.creationDate,
      creatorId: creatorId ?? this.creatorId,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      lastModifierId: lastModifierId ?? this.lastModifierId,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    var map = <String, dynamic>{
      'id': id,
      'userId': userId,
      'businessId': businessId,
      'settings': settings,
      'creationDate': isFirestore
          ? creationDate?.toUtc()
          : creationDate?.toUtc().toIso8601String(),
      'creatorId': creatorId,
      'lastModifiedDate': isFirestore
          ? lastModifiedDate?.toUtc()
          : lastModifiedDate?.toUtc().toIso8601String(),
      'lastModifierId': lastModifierId,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory ConverseSettings.fromMap(dynamic data,
      [String? id, bool isFirestore = true]) {
    if (data == null) return const ConverseSettings.init();
    final map = Map<String, dynamic>.from(data);
    return ConverseSettings(
      id: id ?? map['id'],
      userId: map['userId'],
      businessId: map['businessId'],
      settings: Map<String, dynamic>.from(
          map['settings'] ?? const <String, dynamic>{}),
      creationDate: _toDateTime(map['creationDate'], isFirestore),
      creatorId: map['creatorId'],
      lastModifiedDate: _toDateTime(map['lastModifiedDate'], isFirestore),
      lastModifierId: map['lastModifierId'],
    );
  }
  static DateTime? _toDateTime(dynamic data, bool isFirebase) {
    try {
      if (data == null) return null;
      if (isFirebase) return data.toDate().toLocal();
      return DateTime.tryParse(data)?.toLocal();
    } catch (e) {
      return null;
    }
  }

  static List<ConverseSettings> listFromMaps(dynamic data, bool isFirestore) {
    if (data == null) return const [];
    final list = List<dynamic>.from(data);
    return list
        .map((e) => ConverseSettings.fromMap(e, null, isFirestore))
        .toList();
  }
}
