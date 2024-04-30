class Comment {
  final String? id;
  final String? content;
  final bool isReply;

  /// Associations-Related Fields
  final String? businessId;
  final String? branchId;
  final String? facultyId;
  final String? departmentId;
  final String? divsionId;
  final String? teamId;
  final String? degreeId;
  final String? specializationId;
  final String? levelId;
  final String? courseId;
  final String? unitId;
  final String? unitContentId;
  final String? feedId;
  final String? taskId;
  final String? parentId;
  final String? stakeholderId;
  final String? enrollmentId;
  final String? userId;
  final String? userImageUrl;
  final String? userFullName;

  /// CRUD-Related Fields
  final DateTime? creationDate;
  final String? creatorId;
  final DateTime? lastModifiedDate;
  final String? lastModifierId;

  const Comment({
    required this.id,
    required this.content,
    required this.isReply,
    required this.businessId,
    required this.branchId,
    required this.facultyId,
    required this.departmentId,
    required this.divsionId,
    required this.teamId,
    required this.degreeId,
    required this.specializationId,
    required this.levelId,
    required this.courseId,
    required this.unitId,
    required this.unitContentId,
    required this.feedId,
    required this.taskId,
    required this.parentId,
    required this.stakeholderId,
    required this.enrollmentId,
    required this.userId,
    required this.userImageUrl,
    required this.userFullName,
    required this.creationDate,
    required this.creatorId,
    required this.lastModifiedDate,
    required this.lastModifierId,
  });

  const Comment.init({
    this.id,
    this.content,
    this.isReply = false,
    this.businessId,
    this.branchId,
    this.facultyId,
    this.departmentId,
    this.divsionId,
    this.teamId,
    this.degreeId,
    this.specializationId,
    this.levelId,
    this.courseId,
    this.unitId,
    this.unitContentId,
    this.feedId,
    this.taskId,
    this.parentId,
    this.stakeholderId,
    this.enrollmentId,
    this.userId,
    this.userImageUrl,
    this.userFullName,
    this.creationDate,
    this.creatorId,
    this.lastModifiedDate,
    this.lastModifierId,
  });

  Comment copyWith({
    String? id,
    String? content,
    bool? isReply,
    String? businessId,
    String? branchId,
    String? facultyId,
    String? departmentId,
    String? divsionId,
    String? teamId,
    String? degreeId,
    String? specializationId,
    String? levelId,
    String? courseId,
    String? unitId,
    String? unitContentId,
    String? feedId,
    String? taskId,
    String? parentId,
    String? stakeholderId,
    String? enrollmentId,
    String? userId,
    String? userImageUrl,
    String? userFullName,
    DateTime? creationDate,
    String? creatorId,
    DateTime? lastModifiedDate,
    String? lastModifierId,
  }) {
    return Comment(
      id: id ?? this.id,
      content: content ?? this.content,
      isReply: isReply ?? this.isReply,
      businessId: businessId ?? this.businessId,
      branchId: branchId ?? this.branchId,
      facultyId: facultyId ?? this.facultyId,
      departmentId: departmentId ?? this.departmentId,
      divsionId: divsionId ?? this.divsionId,
      teamId: teamId ?? this.teamId,
      degreeId: degreeId ?? this.degreeId,
      specializationId: specializationId ?? this.specializationId,
      levelId: levelId ?? this.levelId,
      courseId: courseId ?? this.courseId,
      unitId: unitId ?? this.unitId,
      unitContentId: unitContentId ?? this.unitContentId,
      feedId: feedId ?? this.feedId,
      taskId: taskId ?? this.taskId,
      parentId: parentId ?? this.parentId,
      stakeholderId: stakeholderId ?? this.stakeholderId,
      enrollmentId: enrollmentId ?? this.enrollmentId,
      userId: userId ?? this.userId,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      userFullName: userFullName ?? this.userFullName,
      creationDate: creationDate ?? this.creationDate,
      creatorId: creatorId ?? this.creatorId,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      lastModifierId: lastModifierId ?? this.lastModifierId,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    var map = <String, dynamic>{
      'id': id,
      'content': content,
      'isReply': isReply,
      'businessId': businessId,
      'branchId': branchId,
      'facultyId': facultyId,
      'departmentId': departmentId,
      'divsionId': divsionId,
      'teamId': teamId,
      'degreeId': degreeId,
      'specializationId': specializationId,
      'levelId': levelId,
      'courseId': courseId,
      'unitId': unitId,
      'unitContentId': unitContentId,
      'feedId': feedId,
      'taskId': taskId,
      'parentId': parentId,
      'stakeholderId': stakeholderId,
      'enrollmentId': enrollmentId,
      'userId': userId,
      'userImageUrl': userImageUrl,
      'userFullName': userFullName,
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
        divsionId ?? '',
        divsionId?.toLowerCase() ?? '',
        divsionId?.toUpperCase() ?? '',
        teamId ?? '',
        teamId?.toLowerCase() ?? '',
        teamId?.toUpperCase() ?? '',
        courseId ?? '',
        courseId?.toLowerCase() ?? '',
        courseId?.toUpperCase() ?? '',
        unitId ?? '',
        unitId?.toLowerCase() ?? '',
        unitId?.toUpperCase() ?? '',
        unitContentId ?? '',
        unitContentId?.toLowerCase() ?? '',
        unitContentId?.toUpperCase() ?? '',
        feedId ?? '',
        feedId?.toLowerCase() ?? '',
        feedId?.toUpperCase() ?? '',
        taskId ?? '',
        taskId?.toLowerCase() ?? '',
        taskId?.toUpperCase() ?? '',
        parentId ?? '',
        parentId?.toLowerCase() ?? '',
        parentId?.toUpperCase() ?? '',
        stakeholderId ?? '',
        stakeholderId?.toLowerCase() ?? '',
        stakeholderId?.toUpperCase() ?? '',
        enrollmentId ?? '',
        enrollmentId?.toLowerCase() ?? '',
        enrollmentId?.toUpperCase() ?? '',
        userId ?? '',
        userId?.toLowerCase() ?? '',
        userId?.toUpperCase() ?? '',
        userFullName ?? '',
        userFullName?.toLowerCase() ?? '',
        userFullName?.toUpperCase() ?? '',
        ...(userFullName?.split(' ') ?? []),
        ...(userFullName?.toLowerCase().split(' ') ?? []),
        ...(userFullName?.toUpperCase().split(' ') ?? []),
        userFullName?.replaceAll(' ', '') ?? '',
        userFullName?.replaceAll(' ', '').toLowerCase() ?? '',
        userFullName?.replaceAll(' ', '').toUpperCase() ?? '',
      }.toSet().toList()
        ..removeWhere((e) => e == ''),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory Comment.fromMap(dynamic data, [String? id, bool isFirestore = true]) {
    if (data == null) return const Comment.init();
    final map = Map<String, dynamic>.from(data);
    return Comment(
      id: id ?? map['id'],
      content: map['content'],
      isReply: map['isReply'] ?? false,
      businessId: map['businessId'],
      branchId: map['branchId'],
      facultyId: map['facultyId'],
      departmentId: map['departmentId'],
      divsionId: map['divsionId'],
      teamId: map['teamId'],
      degreeId: map['degreeId'],
      specializationId: map['specializationId'],
      levelId: map['levelId'],
      courseId: map['courseId'],
      unitId: map['unitId'],
      unitContentId: map['unitContentId'],
      feedId: map['feedId'],
      taskId: map['taskId'],
      parentId: map['parentId'],
      stakeholderId: map['stakeholderId'],
      enrollmentId: map['enrollmentId'],
      userId: map['userId'],
      userImageUrl: map['userImageUrl'],
      userFullName: map['userFullName'],
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

  static List<Comment> listFromMaps(dynamic data, bool isFirestore) {
    if (data == null) return const [];
    final list = List<dynamic>.from(data);
    return list.map((e) => Comment.fromMap(e, null, isFirestore)).toList();
  }
}
