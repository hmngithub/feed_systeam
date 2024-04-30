class UserRole {
  /// identity-related
  final String? id;
  final String? title;
  final String? userId;
  final String? userImageUrl;
  final String? userName;
  final String? businessId;
  final String? businessLogoUrl;
  final String? businessName;
  final String? businessDescription;
  final String? branchId;
  final String? branchName;
  final String? facultyId;
  final String? facultyName;
  final String? departmentId;
  final String? departmentName;
  final String? divisionId;
  final String? divisionName;
  final String? teamId;
  final String? teamName;
  final String? warehouseId;
  final String? warehouseName;
  final String? strategyId;
  final String? strategyName;
  final String? programId;
  final String? programName;
  final String? projectId;
  final String? projectName;
  final bool ace;
  final bool admin;
  final bool moderator;
  final bool observer;
  final bool workspace;
  final bool hrm;
  final bool ais;
  final bool accountant;
  final bool auditor;
  final bool portfolio;
  final bool crm;
  final bool marketing;
  final bool catalog;
  final bool seller;
  final bool reserve;
  final bool academy;
  final bool librarian;

  /// CRUD-related
  final DateTime? creationDate;
  final String? creatorId;
  final DateTime? lastModifiedDate;
  final String? lastModifierId;

  const UserRole({
    required this.id,
    required this.title,
    required this.userId,
    required this.userImageUrl,
    required this.userName,
    required this.businessId,
    required this.businessLogoUrl,
    required this.businessName,
    required this.businessDescription,
    required this.branchId,
    required this.branchName,
    required this.facultyId,
    required this.facultyName,
    required this.departmentId,
    required this.departmentName,
    required this.divisionId,
    required this.divisionName,
    required this.teamId,
    required this.teamName,
    required this.warehouseId,
    required this.warehouseName,
    required this.strategyId,
    required this.strategyName,
    required this.programId,
    required this.programName,
    required this.projectId,
    required this.projectName,
    required this.ace,
    required this.admin,
    required this.moderator,
    required this.observer,
    required this.workspace,
    required this.hrm,
    required this.ais,
    required this.accountant,
    required this.auditor,
    required this.portfolio,
    required this.crm,
    required this.marketing,
    required this.catalog,
    required this.seller,
    required this.reserve,
    required this.academy,
    required this.librarian,
    required this.creationDate,
    required this.creatorId,
    required this.lastModifiedDate,
    required this.lastModifierId,
  });

  const UserRole.init({
    this.id,
    this.title,
    this.userId,
    this.userImageUrl,
    this.userName,
    this.businessId,
    this.businessLogoUrl,
    this.businessName,
    this.businessDescription,
    this.branchId,
    this.branchName,
    this.facultyId,
    this.facultyName,
    this.departmentId,
    this.departmentName,
    this.divisionId,
    this.divisionName,
    this.teamId,
    this.teamName,
    this.warehouseId,
    this.warehouseName,
    this.strategyId,
    this.strategyName,
    this.programId,
    this.programName,
    this.projectId,
    this.projectName,
    this.ace = false,
    this.admin = false,
    this.moderator = false,
    this.observer = false,
    this.workspace = false,
    this.hrm = false,
    this.ais = false,
    this.accountant = false,
    this.auditor = false,
    this.portfolio = false,
    this.crm = false,
    this.marketing = false,
    this.catalog = false,
    this.seller = false,
    this.reserve = false,
    this.academy = false,
    this.librarian = false,
    this.creationDate,
    this.creatorId,
    this.lastModifiedDate,
    this.lastModifierId,
  });

  UserRole copyWith({
    String? id,
    String? title,
    String? userId,
    String? userImageUrl,
    String? userName,
    String? businessId,
    String? businessLogoUrl,
    String? businessName,
    String? businessDescription,
    String? branchId,
    String? branchName,
    String? facultyId,
    String? facultyName,
    String? departmentId,
    String? departmentName,
    String? divisionId,
    String? divisionName,
    String? teamId,
    String? teamName,
    String? warehouseId,
    String? warehouseName,
    String? strategyId,
    String? strategyName,
    String? programId,
    String? programName,
    String? projectId,
    String? projectName,
    bool? ace,
    bool? admin,
    bool? moderator,
    bool? observer,
    bool? workspace,
    bool? hrm,
    bool? ais,
    bool? accountant,
    bool? auditor,
    bool? portfolio,
    bool? crm,
    bool? marketing,
    bool? catalog,
    bool? seller,
    bool? reserve,
    bool? academy,
    bool? librarian,
    DateTime? creationDate,
    String? creatorId,
    DateTime? lastModifiedDate,
    String? lastModifierId,
  }) {
    return UserRole(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      userName: userName ?? this.userName,
      businessId: businessId ?? this.businessId,
      businessLogoUrl: businessLogoUrl ?? this.businessLogoUrl,
      businessName: businessName ?? this.businessName,
      businessDescription: businessDescription ?? this.businessDescription,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      facultyId: facultyId ?? this.facultyId,
      facultyName: facultyName ?? this.facultyName,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      divisionId: divisionId ?? this.divisionId,
      divisionName: divisionName ?? this.divisionName,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      warehouseId: warehouseId ?? this.warehouseId,
      warehouseName: warehouseName ?? this.warehouseName,
      strategyId: strategyId ?? this.strategyId,
      strategyName: strategyName ?? this.strategyName,
      programId: programId ?? this.programId,
      programName: programName ?? this.programName,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      ace: ace ?? this.ace,
      admin: admin ?? this.admin,
      moderator: moderator ?? this.moderator,
      observer: observer ?? this.observer,
      workspace: workspace ?? this.workspace,
      hrm: hrm ?? this.hrm,
      ais: ais ?? this.ais,
      accountant: accountant ?? this.accountant,
      auditor: auditor ?? this.auditor,
      portfolio: portfolio ?? this.portfolio,
      crm: crm ?? this.crm,
      marketing: marketing ?? this.marketing,
      catalog: catalog ?? this.catalog,
      seller: seller ?? this.seller,
      reserve: reserve ?? this.reserve,
      academy: academy ?? this.academy,
      librarian: librarian ?? this.librarian,
      creationDate: creationDate ?? this.creationDate,
      creatorId: creatorId ?? this.creatorId,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      lastModifierId: lastModifierId ?? this.lastModifierId,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'userId': userId,
      'userImageUrl': userImageUrl,
      'userName': userName,
      'businessId': businessId,
      'businessLogoUrl': businessLogoUrl,
      'businessName': businessName,
      'businessDescription': businessDescription,
      'branchId': branchId,
      'branchName': branchName,
      'facultyId': facultyId,
      'facultyName': facultyName,
      'departmentId': departmentId,
      'departmentName': departmentName,
      'divisionId': divisionId,
      'divisionName': divisionName,
      'teamId': teamId,
      'teamName': teamName,
      'warehouseId': warehouseId,
      'warehouseName': warehouseName,
      'strategyId': strategyId,
      'strategyName': strategyName,
      'programId': programId,
      'programName': programName,
      'projectId': projectId,
      'projectName': projectName,
      'ace': ace,
      'admin': admin,
      'moderator': moderator,
      'observer': observer,
      'workspace': workspace,
      'hrm': hrm,
      'ais': ais,
      'accountant': accountant,
      'auditor': auditor,
      'portfolio': portfolio,
      'crm': crm,
      'marketing': marketing,
      'catalog': catalog,
      'seller': seller,
      'reserve': reserve,
      'academy': academy,
      'librarian': librarian,
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
        userId ?? '',
        userId?.toLowerCase() ?? '',
        userId?.toUpperCase() ?? '',
        userName ?? '',
        userName?.toLowerCase() ?? '',
        userName?.toUpperCase() ?? '',
        ...(userName?.split(' ') ?? []),
        ...(userName?.toLowerCase().split(' ') ?? []),
        ...(userName?.toUpperCase().split(' ') ?? []),
        userName?.replaceAll(' ', '') ?? '',
        userName?.replaceAll(' ', '').toLowerCase() ?? '',
        userName?.replaceAll(' ', '').toUpperCase() ?? '',
        divisionId ?? '',
        divisionId?.toLowerCase() ?? '',
        divisionId?.toUpperCase() ?? '',
        divisionName ?? '',
        divisionName?.toLowerCase() ?? '',
        divisionName?.toUpperCase() ?? '',
        ...(divisionName?.split(' ') ?? []),
        ...(divisionName?.toLowerCase().split(' ') ?? []),
        ...(divisionName?.toUpperCase().split(' ') ?? []),
        divisionName?.replaceAll(' ', '') ?? '',
        divisionName?.replaceAll(' ', '').toLowerCase() ?? '',
        divisionName?.replaceAll(' ', '').toUpperCase() ?? '',
        teamId ?? '',
        teamId?.toLowerCase() ?? '',
        teamId?.toUpperCase() ?? '',
        teamName ?? '',
        teamName?.toLowerCase() ?? '',
        teamName?.toUpperCase() ?? '',
        ...(teamName?.split(' ') ?? []),
        ...(teamName?.toLowerCase().split(' ') ?? []),
        ...(teamName?.toUpperCase().split(' ') ?? []),
        teamName?.replaceAll(' ', '') ?? '',
        teamName?.replaceAll(' ', '').toLowerCase() ?? '',
        teamName?.replaceAll(' ', '').toUpperCase() ?? '',
        warehouseId ?? '',
        warehouseId?.toLowerCase() ?? '',
        warehouseId?.toUpperCase() ?? '',
        warehouseName ?? '',
        warehouseName?.toLowerCase() ?? '',
        warehouseName?.toUpperCase() ?? '',
        ...(warehouseName?.split(' ') ?? []),
        ...(warehouseName?.toLowerCase().split(' ') ?? []),
        ...(warehouseName?.toUpperCase().split(' ') ?? []),
        warehouseName?.replaceAll(' ', '') ?? '',
        warehouseName?.replaceAll(' ', '').toLowerCase() ?? '',
        warehouseName?.replaceAll(' ', '').toUpperCase() ?? '',
        strategyId ?? '',
        strategyId?.toLowerCase() ?? '',
        strategyId?.toUpperCase() ?? '',
        strategyName ?? '',
        strategyName?.toLowerCase() ?? '',
        strategyName?.toUpperCase() ?? '',
        ...(strategyName?.split(' ') ?? []),
        ...(strategyName?.toLowerCase().split(' ') ?? []),
        ...(strategyName?.toUpperCase().split(' ') ?? []),
        strategyName?.replaceAll(' ', '') ?? '',
        strategyName?.replaceAll(' ', '').toLowerCase() ?? '',
        strategyName?.replaceAll(' ', '').toUpperCase() ?? '',
        programId ?? '',
        programId?.toLowerCase() ?? '',
        programId?.toUpperCase() ?? '',
        programName ?? '',
        programName?.toLowerCase() ?? '',
        programName?.toUpperCase() ?? '',
        ...(programName?.split(' ') ?? []),
        ...(programName?.toLowerCase().split(' ') ?? []),
        ...(programName?.toUpperCase().split(' ') ?? []),
        programName?.replaceAll(' ', '') ?? '',
        programName?.replaceAll(' ', '').toLowerCase() ?? '',
        programName?.replaceAll(' ', '').toUpperCase() ?? '',
        projectId ?? '',
        projectId?.toLowerCase() ?? '',
        projectId?.toUpperCase() ?? '',
        projectName ?? '',
        projectName?.toLowerCase() ?? '',
        projectName?.toUpperCase() ?? '',
        ...(projectName?.split(' ') ?? []),
        ...(projectName?.toLowerCase().split(' ') ?? []),
        ...(projectName?.toUpperCase().split(' ') ?? []),
        projectName?.replaceAll(' ', '') ?? '',
        projectName?.replaceAll(' ', '').toLowerCase() ?? '',
        projectName?.replaceAll(' ', '').toUpperCase() ?? '',
      }.toSet().toList()
        ..removeWhere((e) => e == ''),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory UserRole.fromMap(dynamic data,
      [String? id, bool isFirestore = true]) {
    if (data == null) return const UserRole.init();
    final map = Map<String, dynamic>.from(data);
    return UserRole(
      id: id ?? map['id'],
      title: map['title'],
      userId: map['userId'],
      userImageUrl: map['userImageUrl'],
      userName: map['userName'],
      businessId: map['businessId'],
      businessLogoUrl: map['businessLogoUrl'],
      businessName: map['businessName'],
      businessDescription: map['businessDescription'],
      branchId: map['branchId'],
      branchName: map['branchName'],
      facultyId: map['facultyId'],
      facultyName: map['facultyName'],
      departmentId: map['departmentId'],
      departmentName: map['departmentName'],
      divisionId: map['divisionId'],
      divisionName: map['divisionName'],
      teamId: map['teamId'],
      teamName: map['teamName'],
      warehouseId: map['warehouseId'],
      warehouseName: map['warehouseName'],
      strategyId: map['strategyId'],
      strategyName: map['strategyName'],
      programId: map['programId'],
      programName: map['programName'],
      projectId: map['projectId'],
      projectName: map['projectName'],
      ace: map['ace'] ?? false,
      admin: map['admin'] ?? false,
      moderator: map['moderator'] ?? false,
      observer: map['observer'] ?? false,
      workspace: map['workspace'] ?? false,
      hrm: map['hrm'] ?? false,
      ais: map['ais'] ?? false,
      accountant: map['accountant'] ?? false,
      auditor: map['auditor'] ?? false,
      portfolio: map['portfolio'] ?? false,
      crm: map['crm'] ?? false,
      marketing: map['marketing'] ?? false,
      catalog: map['catalog'] ?? false,
      seller: map['seller'] ?? false,
      reserve: map['reserve'] ?? false,
      academy: map['academy'] ?? false,
      librarian: map['librarian'] ?? false,
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

  static List<UserRole> listFromMaps(dynamic data, bool isFirestore) {
    if (data == null) return const [];
    final list = List<dynamic>.from(data);
    return list.map((e) => UserRole.fromMap(e, null, isFirestore)).toList();
  }
}
