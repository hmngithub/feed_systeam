import '../../domain/entities/like.g.dart';

enum LikeStateStatus {
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

extension LikeStateStatusExt on LikeStateStatus {
  bool get isIdle => this == LikeStateStatus.idle;
  bool get isInvalid => this == LikeStateStatus.invalid;

  bool get isCreating => this == LikeStateStatus.creating;
  bool get isCreated => this == LikeStateStatus.created;
  bool get isFailedCreate => this == LikeStateStatus.failedCreate;

  bool get isStreaming => this == LikeStateStatus.streaming;
  bool get isStreamed => this == LikeStateStatus.streamed;
  bool get isFailedStream => this == LikeStateStatus.failedStream;

  bool get isFetching => this == LikeStateStatus.fetching;
  bool get isFetched => this == LikeStateStatus.fetched;
  bool get isFailedFetch => this == LikeStateStatus.failedFetch;

  bool get isUpdating => this == LikeStateStatus.updating;
  bool get isUpdated => this == LikeStateStatus.updated;
  bool get isFailedUpdate => this == LikeStateStatus.failedUpdate;

  bool get isDeleting => this == LikeStateStatus.deleting;
  bool get isDeleted => this == LikeStateStatus.deleted;
  bool get isFailedDelete => this == LikeStateStatus.failedDelete;

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

  static LikeStateStatus fromName(String? name,
      [LikeStateStatus value = LikeStateStatus.idle]) {
    if (name == null) return value;
    try {
      return LikeStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class LikeState {
  final LikeStateStatus status;
  final String? error;
  final Like like;

  const LikeState({
    required this.status,
    required this.error,
    required this.like,
  });

  const LikeState.init({
    this.status = LikeStateStatus.idle,
    this.error,
    this.like = const Like.init(),
  });

  LikeState copyWith({
    LikeStateStatus? status,
    String? error,
    Like? like,
  }) {
    return LikeState(
      status: status ?? this.status,
      error: error ?? this.error,
      like: like ?? this.like,
    );
  }

  LikeState idleState() {
    return LikeState(
      status: LikeStateStatus.idle,
      error: null,
      like: like,
    );
  }

  LikeState loadingState(LikeStateStatus status) {
    return LikeState(
      status: status,
      error: null,
      like: like,
    );
  }

  LikeState successState(
    LikeStateStatus status, {
    Like? like,
  }) {
    return LikeState(
      status: status,
      error: null,
      like: like ?? this.like,
    );
  }

  LikeState failureState(LikeStateStatus status, {dynamic error}) {
    return LikeState(
      status: status,
      error: (error ?? '').toString(),
      like: like,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'like': like.toMap(isFirestore),
    };
  }

  factory LikeState.fromMap(Map<String, dynamic> map) {
    return LikeState(
      status: LikeStateStatusExt.fromName(map['status']),
      error: map['error'].toString(),
      like: Like.fromMap(map['like'], null, false),
    );
  }
}
