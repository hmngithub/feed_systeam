import '../enums/auth_method.g.dart';
import 'current_role.g.dart';

class ConverseUser {
  final String? id;
  final String? imageUrl;
  final String? namePrefix;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final AuthMethod authMethod;
  final String? email;
  final String? password;
  final CurrentRole role;
  final DateTime? registerDate;
  final DateTime? creationDate;
  final String? creatorId;
  final DateTime? lastModifiedDate;
  final String? lastModifierId;

  String get fullName {
    var buffer = StringBuffer();

    if ((namePrefix ?? '').isNotEmpty) {
      buffer.write(namePrefix ?? '');
    }

    if ((firstName ?? '').isNotEmpty) {
      buffer.write(' ${firstName ?? ''}');
    }

    if ((middleName ?? '').isNotEmpty) {
      buffer.write(' ${middleName ?? ''}');
    }

    if ((lastName ?? '').isNotEmpty) {
      buffer.write(' ${lastName ?? ''}');
    }

    var name = buffer.toString();
    if (name.startsWith(' ')) {
      name = name.replaceFirst(' ', '');
    }

    return name;
  }

  const ConverseUser({
    required this.id,
    required this.imageUrl,
    required this.namePrefix,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.authMethod,
    required this.email,
    required this.password,
    required this.role,
    required this.registerDate,
    required this.creationDate,
    required this.creatorId,
    required this.lastModifiedDate,
    required this.lastModifierId,
  });

  const ConverseUser.init({
    this.id,
    this.imageUrl,
    this.namePrefix,
    this.firstName,
    this.middleName,
    this.lastName,
    this.authMethod = AuthMethod.unknown,
    this.email,
    this.password,
    this.role = const CurrentRole.init(),
    this.registerDate,
    this.creationDate,
    this.creatorId,
    this.lastModifiedDate,
    this.lastModifierId,
  });

  ConverseUser copyWith({
    String? id,
    String? imageUrl,
    String? namePrefix,
    String? firstName,
    String? middleName,
    String? lastName,
    AuthMethod? authMethod,
    String? email,
    String? password,
    CurrentRole? role,
    DateTime? registerDate,
    DateTime? creationDate,
    String? creatorId,
    DateTime? lastModifiedDate,
    String? lastModifierId,
  }) {
    return ConverseUser(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      namePrefix: namePrefix ?? this.namePrefix,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      authMethod: authMethod ?? this.authMethod,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      registerDate: registerDate ?? this.registerDate,
      creationDate: creationDate ?? this.creationDate,
      creatorId: creatorId ?? this.creatorId,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      lastModifierId: lastModifierId ?? this.lastModifierId,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    var map = <String, dynamic>{
      'id': id,
      'imageUrl': imageUrl,
      'namePrefix': namePrefix,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'authMethod': authMethod.name,
      'email': email,
      'password': password,
      'role': role.toMap(isFirestore),
      'registerDate': isFirestore
          ? registerDate?.toUtc()
          : registerDate?.toUtc().toIso8601String(),
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
        namePrefix ?? '',
        namePrefix?.toLowerCase() ?? '',
        namePrefix?.toUpperCase() ?? '',
        ...(namePrefix?.split(' ') ?? []),
        ...(namePrefix?.toLowerCase().split(' ') ?? []),
        ...(namePrefix?.toUpperCase().split(' ') ?? []),
        namePrefix?.replaceAll(' ', '') ?? '',
        namePrefix?.replaceAll(' ', '').toLowerCase() ?? '',
        namePrefix?.replaceAll(' ', '').toUpperCase() ?? '',
        firstName ?? '',
        firstName?.toLowerCase() ?? '',
        firstName?.toUpperCase() ?? '',
        ...(firstName?.split(' ') ?? []),
        ...(firstName?.toLowerCase().split(' ') ?? []),
        ...(firstName?.toUpperCase().split(' ') ?? []),
        firstName?.replaceAll(' ', '') ?? '',
        firstName?.replaceAll(' ', '').toLowerCase() ?? '',
        firstName?.replaceAll(' ', '').toUpperCase() ?? '',
        middleName ?? '',
        middleName?.toLowerCase() ?? '',
        middleName?.toUpperCase() ?? '',
        ...(middleName?.split(' ') ?? []),
        ...(middleName?.toLowerCase().split(' ') ?? []),
        ...(middleName?.toUpperCase().split(' ') ?? []),
        middleName?.replaceAll(' ', '') ?? '',
        middleName?.replaceAll(' ', '').toLowerCase() ?? '',
        middleName?.replaceAll(' ', '').toUpperCase() ?? '',
        lastName ?? '',
        lastName?.toLowerCase() ?? '',
        lastName?.toUpperCase() ?? '',
        ...(lastName?.split(' ') ?? []),
        ...(lastName?.toLowerCase().split(' ') ?? []),
        ...(lastName?.toUpperCase().split(' ') ?? []),
        lastName?.replaceAll(' ', '') ?? '',
        lastName?.replaceAll(' ', '').toLowerCase() ?? '',
        lastName?.replaceAll(' ', '').toUpperCase() ?? '',
        authMethod.name,
        authMethod.name.toLowerCase(),
        authMethod.name.toUpperCase(),
        email ?? '',
        email?.toLowerCase() ?? '',
        email?.toUpperCase() ?? '',
        ...(email?.split(' ') ?? []),
        ...(email?.toLowerCase().split(' ') ?? []),
        ...(email?.toUpperCase().split(' ') ?? []),
        email?.replaceAll(' ', '') ?? '',
        email?.replaceAll(' ', '').toLowerCase() ?? '',
        email?.replaceAll(' ', '').toUpperCase() ?? '',
        password ?? '',
        password?.toLowerCase() ?? '',
        password?.toUpperCase() ?? '',
        ...(password?.split(' ') ?? []),
        ...(password?.toLowerCase().split(' ') ?? []),
        ...(password?.toUpperCase().split(' ') ?? []),
        password?.replaceAll(' ', '') ?? '',
        password?.replaceAll(' ', '').toLowerCase() ?? '',
        password?.replaceAll(' ', '').toUpperCase() ?? '',
        fullName,
        fullName.toUpperCase(),
        fullName.toLowerCase(),
      }.toSet().toList()
        ..removeWhere((e) => e == ''),
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  factory ConverseUser.fromMap(dynamic data,
      [String? id, bool isFirestore = true]) {
    if (data == null) return const ConverseUser.init();
    final map = Map<String, dynamic>.from(data);
    return ConverseUser(
      id: id ?? map['id'],
      imageUrl: map['imageUrl'],
      namePrefix: map['namePrefix'],
      firstName: map['firstName'],
      middleName: map['middleName'],
      lastName: map['lastName'],
      authMethod: AuthMethodParser.fromName(map['authMethod']),
      email: map['email'],
      password: map['password'],
      role: CurrentRole.fromMap(map['role'], null, isFirestore),
      registerDate: _toDateTime(map['registerDate'], isFirestore),
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

  static List<ConverseUser> listFromMaps(dynamic data, bool isFirestore) {
    if (data == null) return const [];
    final list = List<dynamic>.from(data);
    return list.map((e) => ConverseUser.fromMap(e, null, isFirestore)).toList();
  }
}
