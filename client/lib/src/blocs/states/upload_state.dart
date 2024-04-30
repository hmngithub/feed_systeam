import 'dart:typed_data';

import 'package:converse_client/src/domain/enums/media_type.g.dart';

class AppFile {
  final String name;

  final String path;
  final String extension;
  final Uint8List data;
  final MediaType type;

  const AppFile({
    required this.name,
    required this.extension,
    required this.data,
    required this.path,
    required this.type,
  });

  AppFile copyWith({
    String? name,
    String? extention,
    Uint8List? data,
    String? path,
    MediaType? type,
  }) {
    return AppFile(
      name: name ?? this.name,
      extension: extention ?? this.extension,
      data: data ?? this.data,
      path: path ?? this.path,
      type: type ?? this.type,
    );
  }
}

enum UploadStateStatus {
  idle,
  invalid,
  uploading,
  uploaded,
  failedUploading,

  deleting,
  deleted,
  failedDelete,
}

extension UploadStateStatusExt on UploadStateStatus {
  bool get isIdle => this == UploadStateStatus.idle;
  bool get isInvalid => this == UploadStateStatus.invalid;

  bool get isUploading => this == UploadStateStatus.uploading;
  bool get isuploaded => this == UploadStateStatus.uploaded;
  bool get isFailedUpload => this == UploadStateStatus.failedUploading;

  bool get isDeleting => this == UploadStateStatus.deleting;
  bool get isDeleted => this == UploadStateStatus.deleted;
  bool get isFailedDelete => this == UploadStateStatus.failedDelete;

  bool get isLoading {
    if (isUploading) return true;
    if (isDeleting) return true;
    return false;
  }

  bool get isSuccess {
    if (isuploaded) return true;
    if (isDeleted) return true;
    return false;
  }

  bool get isFailure {
    if (isFailedUpload) return true;
    if (isFailedDelete) return true;
    if (isInvalid) return true;
    return false;
  }

  bool get isCommanding {
    if (isUploading) return true;
    if (isDeleting) return true;
    return false;
  }

  bool get isCommanded {
    if (isuploaded) return true;
    if (isDeleted) return true;
    return false;
  }

  bool get isFailedCommand {
    if (isFailedUpload) return true;
    if (isFailedDelete) return true;
    if (isInvalid) return true;
    return false;
  }

  static UploadStateStatus fromName(String? name,
      [UploadStateStatus value = UploadStateStatus.idle]) {
    if (name == null) return value;
    try {
      return UploadStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class UploadState {
  final UploadStateStatus status;
  final String? error;
  final List<AppFile> files;
  final List<String> urls;
  final bool isUpdate;

  const UploadState({
    required this.status,
    required this.error,
    required this.files,
    required this.urls,
    required this.isUpdate,
  });

  const UploadState.init({
    this.status = UploadStateStatus.idle,
    this.error,
    this.files = const [],
    this.urls = const [],
    this.isUpdate = false,
  });

  UploadState copyWith({
    UploadStateStatus? status,
    String? error,
    List<AppFile>? files,
    List<String>? urls,
    bool? isUpdate,
  }) {
    return UploadState(
      status: status ?? this.status,
      error: error ?? this.error,
      files: files ?? this.files,
      urls: urls ?? this.urls,
      isUpdate: isUpdate ?? this.isUpdate,
    );
  }

  UploadState idleState() {
    return UploadState(
      status: UploadStateStatus.idle,
      error: null,
      files: files,
      urls: urls,
      isUpdate: isUpdate,
    );
  }

  UploadState loadingState(UploadStateStatus status) {
    return UploadState(
      status: status,
      error: null,
      files: files,
      urls: urls,
      isUpdate: isUpdate,
    );
  }

  UploadState successState(
    UploadStateStatus status, {
    List<String>? urls,
    List<AppFile>? files,
  }) {
    return UploadState(
      status: status,
      error: null,
      files: files ?? this.files,
      urls: urls ?? this.urls,
      isUpdate: isUpdate,
    );
  }

  UploadState failureState(UploadStateStatus status, {dynamic error}) {
    return UploadState(
      status: status,
      error: (error ?? '').toString(),
      files: files,
      urls: urls,
      isUpdate: isUpdate,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'files': files,
      'urls': urls,
      'isUpdate': isUpdate,
    };
  }

  factory UploadState.fromMap(Map<String, dynamic> map) {
    return UploadState(
      status: UploadStateStatusExt.fromName(map['status']),
      error: map['error'].toString(),
      files: map['files'],
      urls: map['urls'],
      isUpdate: map['isUpdate'],
    );
  }
}
