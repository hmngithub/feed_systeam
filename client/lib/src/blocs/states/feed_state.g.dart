import '../../domain/entities/feed.g.dart';

enum FeedStateStatus {
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

extension FeedStateStatusExt on FeedStateStatus {
  bool get isIdle => this == FeedStateStatus.idle;
  bool get isInvalid => this == FeedStateStatus.invalid;

  bool get isCreating => this == FeedStateStatus.creating;
  bool get isCreated => this == FeedStateStatus.created;
  bool get isFailedCreate => this == FeedStateStatus.failedCreate;

  bool get isStreaming => this == FeedStateStatus.streaming;
  bool get isStreamed => this == FeedStateStatus.streamed;
  bool get isFailedStream => this == FeedStateStatus.failedStream;

  bool get isFetching => this == FeedStateStatus.fetching;
  bool get isFetched => this == FeedStateStatus.fetched;
  bool get isFailedFetch => this == FeedStateStatus.failedFetch;

  bool get isUpdating => this == FeedStateStatus.updating;
  bool get isUpdated => this == FeedStateStatus.updated;
  bool get isFailedUpdate => this == FeedStateStatus.failedUpdate;

  bool get isDeleting => this == FeedStateStatus.deleting;
  bool get isDeleted => this == FeedStateStatus.deleted;
  bool get isFailedDelete => this == FeedStateStatus.failedDelete;

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

  static FeedStateStatus fromName(String? name,
      [FeedStateStatus value = FeedStateStatus.idle]) {
    if (name == null) return value;
    try {
      return FeedStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class FeedState {
  final FeedStateStatus status;
  final String? error;
  final Feed feed;

  const FeedState({
    required this.status,
    required this.error,
    required this.feed,
  });

  const FeedState.init({
    this.status = FeedStateStatus.idle,
    this.error,
    this.feed = const Feed.init(),
  });

  FeedState copyWith({
    FeedStateStatus? status,
    String? error,
    Feed? feed,
  }) {
    return FeedState(
      status: status ?? this.status,
      error: error ?? this.error,
      feed: feed ?? this.feed,
    );
  }

  FeedState idleState() {
    return FeedState(
      status: FeedStateStatus.idle,
      error: null,
      feed: feed,
    );
  }

  FeedState loadingState(FeedStateStatus status) {
    return FeedState(
      status: status,
      error: null,
      feed: feed,
    );
  }

  FeedState successState(
    FeedStateStatus status, {
    Feed? feed,
  }) {
    return FeedState(
      status: status,
      error: null,
      feed: feed ?? this.feed,
    );
  }

  FeedState failureState(FeedStateStatus status, {dynamic error}) {
    return FeedState(
      status: status,
      error: (error ?? '').toString(),
      feed: feed,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'feed': feed.toMap(isFirestore),
    };
  }

  factory FeedState.fromMap(Map<String, dynamic> map) {
    return FeedState(
      status: FeedStateStatusExt.fromName(map['status']),
      error: map['error'].toString(),
      feed: Feed.fromMap(map['feed'], null, false),
    );
  }
}
