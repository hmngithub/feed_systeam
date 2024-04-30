import '../../domain/entities/media.g.dart';

enum MediaStateStatus {
  idle,
  invalid,

  creating,
  created,
  failedCreate,

  streaming,
  streamed,
  failedStream,

  fetching,
  fetched,
  failedFetch,

  updating,
  updated,
  failedUpdate,

  deleting,
  deleted,
  failedDelete,
}

extension MediaStateStatusExt on MediaStateStatus {
  bool get isIdle => this == MediaStateStatus.idle;
  bool get isInvalid => this == MediaStateStatus.invalid;

  bool get isCreating => this == MediaStateStatus.creating;
  bool get isCreated => this == MediaStateStatus.created;
  bool get isFailedCreate => this == MediaStateStatus.failedCreate;

  bool get isStreaming => this == MediaStateStatus.streaming;
  bool get isStreamed => this == MediaStateStatus.streamed;
  bool get isFailedStream => this == MediaStateStatus.failedStream;

  bool get isFetching => this == MediaStateStatus.fetching;
  bool get isFetched => this == MediaStateStatus.fetched;
  bool get isFailedFetch => this == MediaStateStatus.failedFetch;

  bool get isUpdating => this == MediaStateStatus.updating;
  bool get isUpdated => this == MediaStateStatus.updated;
  bool get isFailedUpdate => this == MediaStateStatus.failedUpdate;

  bool get isDeleting => this == MediaStateStatus.deleting;
  bool get isDeleted => this == MediaStateStatus.deleted;
  bool get isFailedDelete => this == MediaStateStatus.failedDelete;

  bool get isLoading {
    if (isCreating) return true;
    if (isStreaming) return true;
    if (isFetching) return true;
    if (isUpdating) return true;
    if (isDeleting) return true;
    return false;
  }

  bool get isSuccess {
    if (isCreated) return true;
    if (isStreamed) return true;
    if (isFetched) return true;
    if (isUpdated) return true;
    if (isDeleted) return true;
    return false;
  }

  bool get isFailure {
    if (isFailedCreate) return true;
    if (isFailedStream) return true;
    if (isFailedFetch) return true;
    if (isFailedUpdate) return true;
    if (isFailedDelete) return true;
    if (isInvalid) return true;
    return false;
  }

  bool get isCommanding {
    if (isCreating) return true;
    if (isUpdating) return true;
    if (isDeleting) return true;
    return false;
  }

  bool get isQuerying {
    if (isStreaming) return true;
    if (isFetching) return true;
    return false;
  }

  bool get isCommanded {
    if (isCreated) return true;
    if (isUpdated) return true;
    if (isDeleted) return true;
    return false;
  }

  bool get isQueried {
    if (isStreamed) return true;
    if (isFetched) return true;
    return false;
  }

  bool get isFailedCommand {
    if (isFailedCreate) return true;
    if (isFailedUpdate) return true;
    if (isFailedDelete) return true;
    if (isInvalid) return true;
    return false;
  }

  bool get isFailedQuery {
    if (isFailedStream) return true;
    if (isFailedFetch) return true;
    return false;
  }

  static MediaStateStatus fromName(String? name,
      [MediaStateStatus value = MediaStateStatus.idle]) {
    if (name == null) return value;
    try {
      return MediaStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class MediaState {
  final MediaStateStatus status;
  final String? error;
  final Media media;

  const MediaState({
    required this.status,
    required this.error,
    required this.media,
  });

  const MediaState.init({
    this.status = MediaStateStatus.idle,
    this.error,
    this.media = const Media.init(),
  });

  MediaState copyWith({
    MediaStateStatus? status,
    String? error,
    Media? media,
  }) {
    return MediaState(
      status: status ?? this.status,
      error: error ?? this.error,
      media: media ?? this.media,
    );
  }

  MediaState idleState() {
    return MediaState(
      status: MediaStateStatus.idle,
      error: null,
      media: media,
    );
  }

  MediaState loadingState(MediaStateStatus status) {
    return MediaState(
      status: status,
      error: null,
      media: media,
    );
  }

  MediaState successState(
    MediaStateStatus status, {
    Media? media,
  }) {
    return MediaState(
      status: status,
      error: null,
      media: media ?? this.media,
    );
  }

  MediaState failureState(MediaStateStatus status, {dynamic error}) {
    return MediaState(
      status: status,
      error: (error ?? '').toString(),
      media: media,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'media': media.toMap(isFirestore),
    };
  }

  factory MediaState.fromMap(Map<String, dynamic> map) {
    return MediaState(
      status: MediaStateStatusExt.fromName(map['status']),
      error: map['error'].toString(),
      media: Media.fromMap(map['media'], null, false),
    );
  }
}
