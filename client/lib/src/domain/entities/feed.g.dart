import 'feed_back_round.g.dart';
import 'media.g.dart';

class Feed {
  final String? id;
  final String? content;
  final int? likes;
  final String? creatorFirstName;
  final String? creatorLastName;
  final bool? liked;
  final bool? hasbackRound;
  final FeedBackRound? backRound;
  final List<Media>? medias;

  /// Associations-Related Fields
  final String? businessId;
  final String? branchId;
  final String? facultyId;
  final String? departmentId;
  final String? divisionId;
  final String? userId;
  final String? stakeholderId;

  /// CRUD-Related Fields
  final DateTime? creationDate;
  final String? creatorId;
  final String? creatorImageUrl;
  final DateTime? lastModifiedDate;
  final String? lastModifierId;

  const Feed({
    required this.id,
    required this.content,
    required this.likes,
    required this.creatorFirstName,
    required this.creatorLastName,
    required this.liked,
    required this.hasbackRound,
    required this.backRound,
    required this.medias,
    required this.businessId,
    required this.branchId,
    required this.facultyId,
    required this.departmentId,
    required this.divisionId,
    required this.userId,
    required this.stakeholderId,
    required this.creationDate,
    required this.creatorId,
    required this.creatorImageUrl,
    required this.lastModifiedDate,
    required this.lastModifierId,
  });

  const Feed.init({
    this.id,
    this.content,
    this.likes,
    this.creatorFirstName,
    this.creatorLastName,
    this.liked,
    this.hasbackRound,
    this.backRound,
    this.medias,
    this.businessId,
    this.branchId,
    this.facultyId,
    this.departmentId,
    this.divisionId,
    this.userId,
    this.stakeholderId,
    this.creationDate,
    this.creatorId,
    this.creatorImageUrl,
    this.lastModifiedDate,
    this.lastModifierId,
  });

  Feed copyWith({
    String? id,
    String? content,
    int? likes,
    String? creatorFirstName,
    String? creatorLastName,
    bool? liked,
    bool? hasbackRound,
    FeedBackRound? backRound,
    List<Media>? medias,
    String? businessId,
    String? branchId,
    String? facultyId,
    String? departmentId,
    String? divisionId,
    String? userId,
    String? stakeholderId,
    DateTime? creationDate,
    String? creatorId,
    String? creatorImageUrl,
    DateTime? lastModifiedDate,
    String? lastModifierId,
  }) {
    return Feed(
      id: id ?? this.id,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      creatorFirstName: creatorFirstName ?? this.creatorFirstName,
      creatorLastName: creatorLastName ?? this.creatorLastName,
      liked: liked ?? this.liked,
      hasbackRound: hasbackRound ?? this.hasbackRound,
      backRound: backRound ?? this.backRound,
      medias: medias ?? this.medias,
      businessId: businessId ?? this.businessId,
      branchId: branchId ?? this.branchId,
      facultyId: facultyId ?? this.facultyId,
      departmentId: departmentId ?? this.departmentId,
      divisionId: divisionId ?? this.divisionId,
      userId: userId ?? this.userId,
      stakeholderId: stakeholderId ?? this.stakeholderId,
      creationDate: creationDate ?? this.creationDate,
      creatorId: creatorId ?? this.creatorId,
      creatorImageUrl: creatorImageUrl ?? this.creatorImageUrl,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      lastModifierId: lastModifierId ?? this.lastModifierId,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    var map = <String, dynamic>{
      'id': id,
      'content': content,
      'likes': likes,
      'creatorFirstName': creatorFirstName,
      'creatorLastName': creatorLastName,
      'liked': liked,
      'hasbackRound': hasbackRound,
      'backRound': backRound?.toMap(isFirestore),
      'medias': medias?.map((e) => e.toMap(isFirestore)).toList(),
      'businessId': businessId,
      'branchId': branchId,
      'facultyId': facultyId,
      'departmentId': departmentId,
      'divisionId': divisionId,
      'userId': userId,
      'stakeholderId': stakeholderId,
      'creationDate': isFirestore
          ? creationDate?.toUtc()
          : creationDate?.toUtc().toIso8601String(),
      'creatorId': creatorId,
      'creatorImageUrl': creatorImageUrl,
      'lastModifiedDate': isFirestore
          ? lastModifiedDate?.toUtc()
          : lastModifiedDate?.toUtc().toIso8601String(),
      'lastModifierId': lastModifierId,
      'searchTags': <String>{
        id ?? '',
        id?.toLowerCase() ?? '',
        id?.toUpperCase() ?? '',
        divisionId ?? '',
        divisionId?.toLowerCase() ?? '',
        divisionId?.toUpperCase() ?? '',
        userId ?? '',
        userId?.toLowerCase() ?? '',
        userId?.toUpperCase() ?? '',
        stakeholderId ?? '',
        stakeholderId?.toLowerCase() ?? '',
        stakeholderId?.toUpperCase() ?? '',
      }.toSet().toList()
        ..removeWhere((e) => e == ''),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory Feed.fromMap(dynamic data, [String? id, bool isFirestore = true]) {
    if (data == null) return const Feed.init();
    final map = Map<String, dynamic>.from(data);
    return Feed(
      id: id ?? map['id'],
      content: map['content'],
      likes: ((map['likes'] ?? 0) as num).toInt(),
      creatorFirstName: map['creatorFirstName'],
      creatorLastName: map['creatorLastName'],
      liked: map['liked'],
      hasbackRound: map['hasbackRound'],
      backRound: FeedBackRound.fromMap(map['backRound'], null, isFirestore),
      medias: Media.listFromMaps(map['medias'], isFirestore),
      businessId: map['businessId'],
      branchId: map['branchId'],
      facultyId: map['facultyId'],
      departmentId: map['departmentId'],
      divisionId: map['divisionId'],
      userId: map['userId'],
      stakeholderId: map['stakeholderId'],
      creationDate: _toDateTime(map['creationDate'], isFirestore),
      creatorId: map['creatorId'],
      creatorImageUrl: map['creatorImageUrl'],
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

  static List<Feed> listFromMaps(dynamic data, bool isFirestore) {
    if (data == null) return const [];
    final list = List<dynamic>.from(data);
    return list.map((e) => Feed.fromMap(e, null, isFirestore)).toList();
  }
}
