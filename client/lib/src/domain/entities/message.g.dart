import '../enums/message_type.g.dart';

class Message {
  final String? id;
  final String? senderId;
  final String? recieverId;
  final String? parentReplyId;
  final String? childReplyId;
  final String? content;
  final MessageType type;
  final DateTime? creationDate;
  final String? creatorId;
  final DateTime? lastModifiedDate;
  final String? lastModifierId;

  const Message({
    required this.id,
    required this.senderId,
    required this.recieverId,
    required this.parentReplyId,
    required this.childReplyId,
    required this.content,
    required this.type,
    required this.creationDate,
    required this.creatorId,
    required this.lastModifiedDate,
    required this.lastModifierId,
  });

  const Message.init({
    this.id,
    this.senderId,
    this.recieverId,
    this.parentReplyId,
    this.childReplyId,
    this.content,
    this.type = MessageType.text,
    this.creationDate,
    this.creatorId,
    this.lastModifiedDate,
    this.lastModifierId,
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? recieverId,
    String? parentReplyId,
    String? childReplyId,
    String? content,
    MessageType? type,
    DateTime? creationDate,
    String? creatorId,
    DateTime? lastModifiedDate,
    String? lastModifierId,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      recieverId: recieverId ?? this.recieverId,
      parentReplyId: parentReplyId ?? this.parentReplyId,
      childReplyId: childReplyId ?? this.childReplyId,
      content: content ?? this.content,
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
      'senderId': senderId,
      'recieverId': recieverId,
      'parentReplyId': parentReplyId,
      'childReplyId': childReplyId,
      'content': content,
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
        senderId ?? '',
        senderId?.toLowerCase() ?? '',
        senderId?.toUpperCase() ?? '',
        recieverId ?? '',
        recieverId?.toLowerCase() ?? '',
        recieverId?.toUpperCase() ?? '',
        parentReplyId ?? '',
        parentReplyId?.toLowerCase() ?? '',
        parentReplyId?.toUpperCase() ?? '',
        childReplyId ?? '',
        childReplyId?.toLowerCase() ?? '',
        childReplyId?.toUpperCase() ?? '',
      }.toSet().toList()
        ..removeWhere((e) => e == ''),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory Message.fromMap(dynamic data, [String? id, bool isFirestore = true]) {
    if (data == null) return const Message.init();
    final map = Map<String, dynamic>.from(data);
    return Message(
      id: id ?? map['id'],
      senderId: map['senderId'],
      recieverId: map['recieverId'],
      parentReplyId: map['parentReplyId'],
      childReplyId: map['childReplyId'],
      content: map['content'],
      type: MessageTypeParser.fromName(map['type']),
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

  static List<Message> listFromMaps(dynamic data, bool isFirestore) {
    if (data == null) return const [];
    final list = List<dynamic>.from(data);
    return list.map((e) => Message.fromMap(e, null, isFirestore)).toList();
  }
}
