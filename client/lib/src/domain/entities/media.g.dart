import '../enums/media_type.g.dart';

class Media {
  final String? id;
  final String? creatorId;
  final String? lastModifierId;
  final String? url;
  final MediaType? type;
  final DateTime? creationDate;
  final DateTime? lastModifiedDate;

  const Media({
    required this.id,
    required this.creatorId,
    required this.lastModifierId,
    required this.url,
    required this.type,
    required this.creationDate,
    required this.lastModifiedDate,
  });

  const Media.init({
    this.id,
    this.creatorId,
    this.lastModifierId,
    this.url,
    this.type = MediaType.photo,
    this.creationDate,
    this.lastModifiedDate,
  });

  Media copyWith({
    String? id,
    String? creatorId,
    String? lastModifierId,
    String? url,
    MediaType? type,
    DateTime? creationDate,
    DateTime? lastModifiedDate,
  }) {
    return Media(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      lastModifierId: lastModifierId ?? this.lastModifierId,
      url: url ?? this.url,
      type: type ?? this.type,
      creationDate: creationDate ?? this.creationDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    var map = <String, dynamic>{
      'id': id,
      'creatorId': creatorId,
      'lastModifierId': lastModifierId,
      'url': url,
      'type': type?.name,
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
        url ?? '',
        url?.toLowerCase() ?? '',
        url?.toUpperCase() ?? '',
        ...(url?.split(' ') ?? []),
        ...(url?.toLowerCase().split(' ') ?? []),
        ...(url?.toUpperCase().split(' ') ?? []),
        url?.replaceAll(' ', '') ?? '',
        url?.replaceAll(' ', '').toLowerCase() ?? '',
        url?.replaceAll(' ', '').toUpperCase() ?? '',
      }.toSet().toList()
        ..removeWhere((e) => e == ''),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory Media.fromMap(dynamic data, [String? id, bool isFirestore = true]) {
    if (data == null) return const Media.init();
    final map = Map<String, dynamic>.from(data);
    return Media(
      id: id ?? map['id'],
      creatorId: map['creatorId'],
      lastModifierId: map['lastModifierId'],
      url: map['url'],
      type: MediaTypeParser.fromName(map['type']),
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

  static List<Media> listFromMaps(dynamic data, bool isFirestore) {
    if (data == null) return const [];
    final list = List<dynamic>.from(data);
    return list.map((e) => Media.fromMap(e, null, isFirestore)).toList();
  }
}
