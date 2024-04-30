class FeedBackRound {
  final String? id;
  final String? creatorId;
  final String? lastModifierId;
  final String? content;
  final double? fontSize;
  final int? contentRedValue;
  final int? contentgreenValue;
  final int? contentBlueValue;
  final int? contenAccentValue;
  final int? backroundRedValue;
  final int? backroundGreenValue;
  final int? backroundBlueValue;
  final int? backroundAccentValue;
  final double? startSpace;
  final double? topSpace;
  final DateTime? creationDate;
  final DateTime? lastModifiedDate;

  const FeedBackRound({
    required this.id,
    required this.creatorId,
    required this.lastModifierId,
    required this.content,
    required this.fontSize,
    required this.contentRedValue,
    required this.contentgreenValue,
    required this.contentBlueValue,
    required this.contenAccentValue,
    required this.backroundRedValue,
    required this.backroundGreenValue,
    required this.backroundBlueValue,
    required this.backroundAccentValue,
    required this.startSpace,
    required this.topSpace,
    required this.creationDate,
    required this.lastModifiedDate,
  });

  const FeedBackRound.init({
    this.id,
    this.creatorId,
    this.lastModifierId,
    this.content,
    this.fontSize,
    this.contentRedValue,
    this.contentgreenValue,
    this.contentBlueValue,
    this.contenAccentValue,
    this.backroundRedValue,
    this.backroundGreenValue,
    this.backroundBlueValue,
    this.backroundAccentValue,
    this.startSpace,
    this.topSpace,
    this.creationDate,
    this.lastModifiedDate,
  });

  FeedBackRound copyWith({
    String? id,
    String? creatorId,
    String? lastModifierId,
    String? content,
    double? fontSize,
    int? contentRedValue,
    int? contentgreenValue,
    int? contentBlueValue,
    int? contenAccentValue,
    int? backroundRedValue,
    int? backroundGreenValue,
    int? backroundBlueValue,
    int? backroundAccentValue,
    double? startSpace,
    double? topSpace,
    DateTime? creationDate,
    DateTime? lastModifiedDate,
  }) {
    return FeedBackRound(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      lastModifierId: lastModifierId ?? this.lastModifierId,
      content: content ?? this.content,
      fontSize: fontSize ?? this.fontSize,
      contentRedValue: contentRedValue ?? this.contentRedValue,
      contentgreenValue: contentgreenValue ?? this.contentgreenValue,
      contentBlueValue: contentBlueValue ?? this.contentBlueValue,
      contenAccentValue: contenAccentValue ?? this.contenAccentValue,
      backroundRedValue: backroundRedValue ?? this.backroundRedValue,
      backroundGreenValue: backroundGreenValue ?? this.backroundGreenValue,
      backroundBlueValue: backroundBlueValue ?? this.backroundBlueValue,
      backroundAccentValue: backroundAccentValue ?? this.backroundAccentValue,
      startSpace: startSpace ?? this.startSpace,
      topSpace: topSpace ?? this.topSpace,
      creationDate: creationDate ?? this.creationDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    var map = <String, dynamic>{
      'id': id,
      'creatorId': creatorId,
      'lastModifierId': lastModifierId,
      'content': content,
      'fontSize': fontSize,
      'contentRedValue': contentRedValue,
      'contentgreenValue': contentgreenValue,
      'contentBlueValue': contentBlueValue,
      'contenAccentValue': contenAccentValue,
      'backroundRedValue': backroundRedValue,
      'backroundGreenValue': backroundGreenValue,
      'backroundBlueValue': backroundBlueValue,
      'backroundAccentValue': backroundAccentValue,
      'startSpace': startSpace,
      'topSpace': topSpace,
      'creationDate': isFirestore
          ? creationDate?.toUtc()
          : creationDate?.toUtc().toIso8601String(),
      'lastModifiedDate': isFirestore
          ? lastModifiedDate?.toUtc()
          : lastModifiedDate?.toUtc().toIso8601String(),
      'searchTags': <String>{
        id ?? '',
        id?.toLowerCase() ?? '',
        id?.toUpperCase() ?? '',
      }.toSet().toList()
        ..removeWhere((e) => e == ''),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory FeedBackRound.fromMap(dynamic data,
      [String? id, bool isFirestore = true]) {
    if (data == null) return const FeedBackRound.init();
    final map = Map<String, dynamic>.from(data);
    return FeedBackRound(
      id: id ?? map['id'],
      creatorId: map['creatorId'],
      lastModifierId: map['lastModifierId'],
      content: map['content'],
      fontSize: ((map['fontSize'] ?? 0) as num).toDouble(),
      contentRedValue: ((map['contentRedValue'] ?? 0) as num).toInt(),
      contentgreenValue: ((map['contentgreenValue'] ?? 0) as num).toInt(),
      contentBlueValue: ((map['contentBlueValue'] ?? 0) as num).toInt(),
      contenAccentValue: ((map['contenAccentValue'] ?? 0) as num).toInt(),
      backroundRedValue: ((map['backroundRedValue'] ?? 0) as num).toInt(),
      backroundGreenValue: ((map['backroundGreenValue'] ?? 0) as num).toInt(),
      backroundBlueValue: ((map['backroundBlueValue'] ?? 0) as num).toInt(),
      backroundAccentValue: ((map['backroundAccentValue'] ?? 0) as num).toInt(),
      startSpace: ((map['startSpace'] ?? 0) as num).toDouble(),
      topSpace: ((map['topSpace'] ?? 0) as num).toDouble(),
      creationDate: _toDateTime(map['creationDate'], isFirestore),
      lastModifiedDate: _toDateTime(map['lastModifiedDate'], isFirestore),
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

  static List<FeedBackRound> listFromMaps(dynamic data, bool isFirestore) {
    if (data == null) return const [];
    final list = List<dynamic>.from(data);
    return list
        .map((e) => FeedBackRound.fromMap(e, null, isFirestore))
        .toList();
  }
}
