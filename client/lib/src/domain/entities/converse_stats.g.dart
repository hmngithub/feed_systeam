class ConverseStats {
  /// identity-related
  final String? id;
  final String? userId;
  final String? businessId;
  final Map<String, dynamic> stats;
  final DateTime? lastCalculatedDate;

  /// CRUD-related
  final DateTime? creationDate;
  final String? creatorId;
  final DateTime? lastModifiedDate;
  final String? lastModifierId;

  bool get shouldRecalculate {
    final oldDate = creationDate;
    if (oldDate == null) return true;

    final current = DateTime.now();
    final difference = current.difference(oldDate);
    if (difference.inHours > 24) return true;

    return false;
  }

  const ConverseStats({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.stats,
    required this.lastCalculatedDate,
    required this.creationDate,
    required this.creatorId,
    required this.lastModifiedDate,
    required this.lastModifierId,
  });

  const ConverseStats.init({
    this.id,
    this.userId,
    this.businessId,
    this.stats = const <String, dynamic>{},
    this.lastCalculatedDate,
    this.creationDate,
    this.creatorId,
    this.lastModifiedDate,
    this.lastModifierId,
  });

  ConverseStats copyWith({
    String? id,
    String? userId,
    String? businessId,
    Map<String, dynamic>? stats,
    DateTime? lastCalculatedDate,
    DateTime? creationDate,
    String? creatorId,
    DateTime? lastModifiedDate,
    String? lastModifierId,
  }) {
    return ConverseStats(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      stats: stats ?? this.stats,
      lastCalculatedDate: lastCalculatedDate ?? this.lastCalculatedDate,
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
      'stats': stats,
      'lastCalculatedDate': isFirestore
          ? lastCalculatedDate?.toUtc()
          : lastCalculatedDate?.toUtc().toIso8601String(),
      'creationDate': isFirestore
          ? creationDate?.toUtc()
          : creationDate?.toUtc().toIso8601String(),
      'creatorId': creatorId,
      'lastModifiedDate': isFirestore
          ? lastModifiedDate?.toUtc()
          : lastModifiedDate?.toUtc().toIso8601String(),
      'lastModifierId': lastModifierId,
      'searchTags': <String>{
        id ?? '',
        id?.toLowerCase() ?? '',
        id?.toUpperCase() ?? '',
        userId ?? '',
        userId?.toLowerCase() ?? '',
        userId?.toUpperCase() ?? '',
      }.toSet().toList()
        ..removeWhere((e) => e == ''),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory ConverseStats.fromMap(dynamic data,
      [String? id, bool isFirestore = true]) {
    if (data == null) return const ConverseStats.init();
    final map = Map<String, dynamic>.from(data);
    return ConverseStats(
      id: id ?? map['id'],
      userId: map['userId'],
      businessId: map['businessId'],
      stats:
          Map<String, dynamic>.from(map['stats'] ?? const <String, dynamic>{}),
      lastCalculatedDate: _toDateTime(map['lastCalculatedDate'], isFirestore),
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

  static List<ConverseStats> listFromMaps(dynamic data, bool isFirestore) {
    if (data == null) return const [];
    final list = List<dynamic>.from(data);
    return list
        .map((e) => ConverseStats.fromMap(e, null, isFirestore))
        .toList();
  }
}
