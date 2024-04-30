class Like {
  final String? id;
  final String? businessId;
  final String? feedId;
  final String? userId;
  final DateTime? creationDate;
  final String? creatorId;
  final String? creatorFirstName;
  final String? creatorLastName;
  final DateTime? lastModifiedDate;
  final String? lastModifierId;

  const Like({
    required this.id,
    required this.businessId,
    required this.feedId,
    required this.userId,
    required this.creationDate,
    required this.creatorId,
    required this.creatorFirstName,
    required this.creatorLastName,
    required this.lastModifiedDate,
    required this.lastModifierId,
  });

  const Like.init({
    this.id,
    this.businessId,
    this.feedId,
    this.userId,
    this.creationDate,
    this.creatorId,
    this.creatorFirstName,
    this.creatorLastName,
    this.lastModifiedDate,
    this.lastModifierId,
  });

  Like copyWith({
    String? id,
    String? businessId,
    String? feedId,
    String? userId,
    DateTime? creationDate,
    String? creatorId,
    String? creatorFirstName,
    String? creatorLastName,
    DateTime? lastModifiedDate,
    String? lastModifierId,
  }) {
    return Like(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      feedId: feedId ?? this.feedId,
      userId: userId ?? this.userId,
      creationDate: creationDate ?? this.creationDate,
      creatorId: creatorId ?? this.creatorId,
      creatorFirstName: creatorFirstName ?? this.creatorFirstName,
      creatorLastName: creatorLastName ?? this.creatorLastName,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      lastModifierId: lastModifierId ?? this.lastModifierId,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    var map = <String, dynamic>{
      'id': id,
      'businessId': businessId,
      'feedId': feedId,
      'userId': userId,
      'creationDate': isFirestore
          ? creationDate?.toUtc()
          : creationDate?.toUtc().toIso8601String(),
      'creatorId': creatorId,
      'creatorFirstName': creatorFirstName,
      'creatorLastName': creatorLastName,
      'lastModifiedDate': isFirestore
          ? lastModifiedDate?.toUtc()
          : lastModifiedDate?.toUtc().toIso8601String(),
      'lastModifierId': lastModifierId,
      'searchTags': <String>{
        id ?? '',
        id?.toLowerCase() ?? '',
        id?.toUpperCase() ?? '',
        feedId ?? '',
        feedId?.toLowerCase() ?? '',
        feedId?.toUpperCase() ?? '',
        userId ?? '',
        userId?.toLowerCase() ?? '',
        userId?.toUpperCase() ?? '',
      }.toSet().toList()
        ..removeWhere((e) => e == ''),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory Like.fromMap(dynamic data, [String? id, bool isFirestore = true]) {
    if (data == null) return const Like.init();
    final map = Map<String, dynamic>.from(data);
    return Like(
      id: id ?? map['id'],
      businessId: map['businessId'],
      feedId: map['feedId'],
      userId: map['userId'],
      creationDate: _toDateTime(map['creationDate'], isFirestore),
      creatorId: map['creatorId'],
      creatorFirstName: map['creatorFirstName'],
      creatorLastName: map['creatorLastName'],
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

  static List<Like> listFromMaps(dynamic data, bool isFirestore) {
    if (data == null) return const [];
    final list = List<dynamic>.from(data);
    return list.map((e) => Like.fromMap(e, null, isFirestore)).toList();
  }
}
