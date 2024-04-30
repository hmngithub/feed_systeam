import '../../domain/entities/comment.g.dart';

enum CommentStateStatus {
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

extension CommentStateStatusExt on CommentStateStatus {
  bool get isIdle => this == CommentStateStatus.idle;
  bool get isInvalid => this == CommentStateStatus.invalid;

  bool get isCreating => this == CommentStateStatus.creating;
  bool get isCreated => this == CommentStateStatus.created;
  bool get isFailedCreate => this == CommentStateStatus.failedCreate;

  bool get isStreaming => this == CommentStateStatus.streaming;
  bool get isStreamed => this == CommentStateStatus.streamed;
  bool get isFailedStream => this == CommentStateStatus.failedStream;

  bool get isFetching => this == CommentStateStatus.fetching;
  bool get isFetched => this == CommentStateStatus.fetched;
  bool get isFailedFetch => this == CommentStateStatus.failedFetch;

  bool get isUpdating => this == CommentStateStatus.updating;
  bool get isUpdated => this == CommentStateStatus.updated;
  bool get isFailedUpdate => this == CommentStateStatus.failedUpdate;

  bool get isDeleting => this == CommentStateStatus.deleting;
  bool get isDeleted => this == CommentStateStatus.deleted;
  bool get isFailedDelete => this == CommentStateStatus.failedDelete;

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

  static CommentStateStatus fromName(String? name,
      [CommentStateStatus value = CommentStateStatus.idle]) {
    if (name == null) return value;
    try {
      return CommentStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class CommentState {
  final CommentStateStatus status;
  final String? error;
  final Comment comment;

  const CommentState({
    required this.status,
    required this.error,
    required this.comment,
  });

  const CommentState.init({
    this.status = CommentStateStatus.idle,
    this.error,
    this.comment = const Comment.init(),
  });

  CommentState copyWith({
    CommentStateStatus? status,
    String? error,
    Comment? comment,
  }) {
    return CommentState(
      status: status ?? this.status,
      error: error ?? this.error,
      comment: comment ?? this.comment,
    );
  }

  CommentState idleState() {
    return CommentState(
      status: CommentStateStatus.idle,
      error: null,
      comment: comment,
    );
  }

  CommentState loadingState(CommentStateStatus status) {
    return CommentState(
      status: status,
      error: null,
      comment: comment,
    );
  }

  CommentState successState(
    CommentStateStatus status, {
    Comment? comment,
  }) {
    return CommentState(
      status: status,
      error: null,
      comment: comment ?? this.comment,
    );
  }

  CommentState failureState(CommentStateStatus status, {dynamic error}) {
    return CommentState(
      status: status,
      error: (error ?? '').toString(),
      comment: comment,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'comment': comment.toMap(isFirestore),
    };
  }

  factory CommentState.fromMap(Map<String, dynamic> map) {
    return CommentState(
      status: CommentStateStatusExt.fromName(map['status']),
      error: map['error'].toString(),
      comment: Comment.fromMap(map['comment'], null, false),
    );
  }
}
