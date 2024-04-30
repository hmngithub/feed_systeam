Add this inside comments bloc: 

```dart
class UploadBloc extends Cubit<UploadState> {
  final Reference _ref;
  UploadBloc(Reference ref)
      : _ref = ref,
        super(const UploadState.init());

  void setInit() {
    emit(state.copyWith(
      isUpdate: false,
      status: UploadStateStatus.idle,
      files: [],
      urls: [],
    ));
  }

  void setUrlsInit() {
    emit(state.copyWith(urls: []));
  }

  void setFiles(List<PlatformFile> files) {
    emit(state.copyWith(files: files));
  }

  void setSucceded() {
    emit(state.successState(UploadStateStatus.uploaded));
  }

  void setUrls(List<String> urls) {
    emit(state.copyWith(urls: urls));
  }

  void setIsUpdate(bool isUpdate) {
    emit(state.copyWith(isUpdate: isUpdate));
  }

  void setIdl() {
    emit(state.copyWith(status: UploadStateStatus.idle));
  }

  void uploadVoice(Uint8List voice) async {
    final imageRef = _ref.child("${DateTime.now()}.wav");
    await imageRef.putData(voice);
    final url = await imageRef.getDownloadURL();
    var voiceUrl = <String>[];
    voiceUrl.add(url);
    emit(state.copyWith(urls: voiceUrl));
  }

  void addToUrls(String url) {
    var newUrls = List<String>.from(state.urls);
    newUrls.add(url);
    emit(state.copyWith(urls: newUrls));
  }

  void uploadFile() async {
    setUrlsInit();
    try {
      emit(state.loadingState(UploadStateStatus.uploading));
      for (int i = 0; i < state.files.length; i++) {
        final imageRef = _ref.child(
            "${state.files[i].name}${DateTime.now()}.${state.files[i].extension}");
        await imageRef.putData(state.files[i].bytes!);
        final url = await imageRef.getDownloadURL();
        addToUrls(url);
      }
      emit(state.successState(UploadStateStatus.uploaded));
    } catch (e) {
      emit(state.failureState(UploadStateStatus.failedUploading));
    }
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
  final List<PlatformFile> files;
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
    List<PlatformFile>? files,
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
    List<PlatformFile>? files,
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


```