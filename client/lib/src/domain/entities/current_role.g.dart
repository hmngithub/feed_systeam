class CurrentRole {
  final String? id;
  final String? title;
  final String? role;
  final String? business;
  final String? branch;
  final String? faculty;
  final String? department;
  final String? division;
  final String? team;
  final String? warehouse;
  final String? strategy;
  final String? program;
  final String? project;
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

  const CurrentRole({
    required this.id,
    required this.title,
    required this.role,
    required this.business,
    required this.branch,
    required this.faculty,
    required this.department,
    required this.division,
    required this.team,
    required this.warehouse,
    required this.strategy,
    required this.program,
    required this.project,
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
  });

  const CurrentRole.init({
    this.id,
    this.title,
    this.role,
    this.business,
    this.branch,
    this.faculty,
    this.department,
    this.division,
    this.team,
    this.warehouse,
    this.strategy,
    this.program,
    this.project,
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
  });

  CurrentRole copyWith({
    String? id,
    String? title,
    String? role,
    String? business,
    String? branch,
    String? faculty,
    String? department,
    String? division,
    String? team,
    String? warehouse,
    String? strategy,
    String? program,
    String? project,
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
  }) {
    return CurrentRole(
      id: id ?? this.id,
      title: title ?? this.title,
      role: role ?? this.role,
      business: business ?? this.business,
      branch: branch ?? this.branch,
      faculty: faculty ?? this.faculty,
      department: department ?? this.department,
      division: division ?? this.division,
      team: team ?? this.team,
      warehouse: warehouse ?? this.warehouse,
      strategy: strategy ?? this.strategy,
      program: program ?? this.program,
      project: project ?? this.project,
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
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'role': role,
      'business': business,
      'branch': branch,
      'faculty': faculty,
      'department': department,
      'division': division,
      'team': team,
      'warehouse': warehouse,
      'strategy': strategy,
      'program': program,
      'project': project,
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
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory CurrentRole.fromMap(dynamic data,
      [String? id, bool isFirestore = true]) {
    if (data == null) return const CurrentRole.init();
    final map = Map<String, dynamic>.from(data);
    return CurrentRole(
      id: id ?? map['id'],
      title: map['title'],
      role: map['role'],
      business: map['business'],
      branch: map['branch'],
      faculty: map['faculty'],
      department: map['department'],
      division: map['division'],
      team: map['team'],
      warehouse: map['warehouse'],
      strategy: map['strategy'],
      program: map['program'],
      project: map['project'],
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
    );
  }

  static List<CurrentRole> listFromMaps(dynamic data, bool isFirestore) {
    if (data == null) return const [];
    final list = List<dynamic>.from(data);
    return list.map((e) => CurrentRole.fromMap(e, null, isFirestore)).toList();
  }
}
