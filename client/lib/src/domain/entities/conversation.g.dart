import '../enums/conversation_type.g.dart';

class Conversation {
  final String? id;
  final List<String>? members;
  final String? title;
  final String? imageUrl;
  final ConversationType type;
  final DateTime? creationDate;
  final String? creatorId;
  final DateTime? lastModifiedDate;
  final String? lastModifierId;

  const Conversation({
    required this.id,
    required this.members,
    required this.title,
    required this.imageUrl,
    required this.type,
    required this.creationDate,
    required this.creatorId,
    required this.lastModifiedDate,
    required this.lastModifierId,
  });

  const Conversation.init({
    this.id,
    this.members,
    this.title,
    this.imageUrl,
    this.type = ConversationType.oneToOne,
    this.creationDate,
    this.creatorId,
    this.lastModifiedDate,
    this.lastModifierId,
  });

  Conversation copyWith({
    String? id,
    List<String>? members,
    String? title,
    String? imageUrl,
    ConversationType? type,
    DateTime? creationDate,
    String? creatorId,
    DateTime? lastModifiedDate,
    String? lastModifierId,
  }) {
    return Conversation(
      id: id ?? this.id,
      members: members ?? this.members,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      creationDate: creationDate ?? this.creationDate,
      creatorId: creatorId ?? this.creatorId,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      lastModifierId: lastModifierId ?? this.lastModifierId,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    var map = <String, dynamic>{
      'id': id,
      'members': members,
      'title': title,
      'imageUrl': imageUrl,
      'type': type.name,
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
        title ?? '',
        title?.toLowerCase() ?? '',
        title?.toUpperCase() ?? '',
        ...(title?.split(' ') ?? []),
        ...(title?.toLowerCase().split(' ') ?? []),
        ...(title?.toUpperCase().split(' ') ?? []),
        title?.replaceAll(' ', '') ?? '',
        title?.replaceAll(' ', '').toLowerCase() ?? '',
        title?.replaceAll(' ', '').toUpperCase() ?? '',
      }.toSet().toList()
        ..removeWhere((e) => e == ''),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory Conversation.fromMap(dynamic data,
      [String? id, bool isFirestore = true]) {
    if (data == null) return const Conversation.init();
    final map = Map<String, dynamic>.from(data);
    return Conversation(
      id: id ?? map['id'],
      members: _toListOfString(map['members']),
      title: map['title'],
      imageUrl: map['imageUrl'],
      type: ConversationTypeParser.fromName(map['type']),
      creationDate: _toDateTime(map['creationDate'], isFirestore),
      creatorId: map['creatorId'],
      lastModifiedDate: _toDateTime(map['lastModifiedDate'], isFirestore),
      lastModifierId: map['lastModifierId'],
    );
  }
  static List<String> _toListOfString(List? list) {
    if (list == null || list.isEmpty) return [];
    return list.map((e) => e.toString()).toList();
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

  static List<Conversation> listFromMaps(dynamic data, bool isFirestore) {
    if (data == null) return const [];
    final list = List<dynamic>.from(data);
    return list.map((e) => Conversation.fromMap(e, null, isFirestore)).toList();
  }
}
