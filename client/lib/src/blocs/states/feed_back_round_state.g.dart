import '../../domain/entities/feed_back_round.g.dart';

enum FeedBackRoundStateStatus {
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

extension FeedBackRoundStateStatusExt on FeedBackRoundStateStatus {
  bool get isIdle => this == FeedBackRoundStateStatus.idle;
  bool get isInvalid => this == FeedBackRoundStateStatus.invalid;

  bool get isCreating => this == FeedBackRoundStateStatus.creating;
  bool get isCreated => this == FeedBackRoundStateStatus.created;
  bool get isFailedCreate => this == FeedBackRoundStateStatus.failedCreate;

  bool get isStreaming => this == FeedBackRoundStateStatus.streaming;
  bool get isStreamed => this == FeedBackRoundStateStatus.streamed;
  bool get isFailedStream => this == FeedBackRoundStateStatus.failedStream;

  bool get isFetching => this == FeedBackRoundStateStatus.fetching;
  bool get isFetched => this == FeedBackRoundStateStatus.fetched;
  bool get isFailedFetch => this == FeedBackRoundStateStatus.failedFetch;

  bool get isUpdating => this == FeedBackRoundStateStatus.updating;
  bool get isUpdated => this == FeedBackRoundStateStatus.updated;
  bool get isFailedUpdate => this == FeedBackRoundStateStatus.failedUpdate;

  bool get isDeleting => this == FeedBackRoundStateStatus.deleting;
  bool get isDeleted => this == FeedBackRoundStateStatus.deleted;
  bool get isFailedDelete => this == FeedBackRoundStateStatus.failedDelete;

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

  static FeedBackRoundStateStatus fromName(String? name,
      [FeedBackRoundStateStatus value = FeedBackRoundStateStatus.idle]) {
    if (name == null) return value;
    try {
      return FeedBackRoundStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class FeedBackRoundState {
  final FeedBackRoundStateStatus status;
  final String? error;
  final FeedBackRound feedBackRound;

  const FeedBackRoundState({
    required this.status,
    required this.error,
    required this.feedBackRound,
  });

  const FeedBackRoundState.init({
    this.status = FeedBackRoundStateStatus.idle,
    this.error,
    this.feedBackRound = const FeedBackRound.init(),
  });

  FeedBackRoundState copyWith({
    FeedBackRoundStateStatus? status,
    String? error,
    FeedBackRound? feedBackRound,
  }) {
    return FeedBackRoundState(
      status: status ?? this.status,
      error: error ?? this.error,
      feedBackRound: feedBackRound ?? this.feedBackRound,
    );
  }

  FeedBackRoundState idleState() {
    return FeedBackRoundState(
      status: FeedBackRoundStateStatus.idle,
      error: null,
      feedBackRound: feedBackRound,
    );
  }

  FeedBackRoundState loadingState(FeedBackRoundStateStatus status) {
    return FeedBackRoundState(
      status: status,
      error: null,
      feedBackRound: feedBackRound,
    );
  }

  FeedBackRoundState successState(
    FeedBackRoundStateStatus status, {
    FeedBackRound? feedBackRound,
  }) {
    return FeedBackRoundState(
      status: status,
      error: null,
      feedBackRound: feedBackRound ?? this.feedBackRound,
    );
  }

  FeedBackRoundState failureState(FeedBackRoundStateStatus status,
      {dynamic error}) {
    return FeedBackRoundState(
      status: status,
      error: (error ?? '').toString(),
      feedBackRound: feedBackRound,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'feedBackRound': feedBackRound.toMap(isFirestore),
    };
  }

  factory FeedBackRoundState.fromMap(Map<String, dynamic> map) {
    return FeedBackRoundState(
      status: FeedBackRoundStateStatusExt.fromName(map['status']),
      error: map['error'].toString(),
      feedBackRound: FeedBackRound.fromMap(map['feedBackRound'], null, false),
    );
  }
}
