import '../../domain/entities/feed_back_round.g.dart';

enum FeedBackRoundsStateStatus {
  idle,

  creating,
  canceledCreate,
  created,
  failedCreate,

  streaming,
  streamed,
  failedStream,

  fetching,
  fetched,
  failedFetch,

  fetchingMore,
  fetchedMore,
  failedFetchMore,

  searching,
  searched,
  failedSearch,

  updating,
  canceledUpdate,
  updated,
  failedUpdate,

  deleting,
  cancelDelete,
  deleted,
  failedDelete,

  backingUp,
  cancelBackup,
  backedUp,
  failedBackup,

  restoring,
  cancelRestore,
  restored,
  failedRestore,
}

extension FeedBackRoundsStateStatusExt on FeedBackRoundsStateStatus {
  bool get isIdle => this == FeedBackRoundsStateStatus.idle;

  bool get isCreating => this == FeedBackRoundsStateStatus.creating;
  bool get isCanceledCreate => this == FeedBackRoundsStateStatus.canceledCreate;
  bool get isCreated => this == FeedBackRoundsStateStatus.created;
  bool get isFailedCreate => this == FeedBackRoundsStateStatus.failedCreate;

  bool get isStreaming => this == FeedBackRoundsStateStatus.streaming;
  bool get isStreamed => this == FeedBackRoundsStateStatus.streamed;
  bool get isFailedStream => this == FeedBackRoundsStateStatus.failedStream;

  bool get isFetching => this == FeedBackRoundsStateStatus.fetching;
  bool get isFetched => this == FeedBackRoundsStateStatus.fetched;
  bool get isFailedFetch => this == FeedBackRoundsStateStatus.failedFetch;

  bool get isFetchingMore => this == FeedBackRoundsStateStatus.fetchingMore;
  bool get isFetchedMore => this == FeedBackRoundsStateStatus.fetchedMore;
  bool get isFailedFetchMore =>
      this == FeedBackRoundsStateStatus.failedFetchMore;

  bool get isSearching => this == FeedBackRoundsStateStatus.searching;
  bool get isSearched => this == FeedBackRoundsStateStatus.searched;
  bool get isFailedSearch => this == FeedBackRoundsStateStatus.failedSearch;

  bool get isUpdating => this == FeedBackRoundsStateStatus.updating;
  bool get isCanceledUpdate => this == FeedBackRoundsStateStatus.canceledUpdate;
  bool get isUpdated => this == FeedBackRoundsStateStatus.updated;
  bool get isFailedUpdate => this == FeedBackRoundsStateStatus.failedUpdate;

  bool get isDeleting => this == FeedBackRoundsStateStatus.deleting;
  bool get isCancelDelete => this == FeedBackRoundsStateStatus.cancelDelete;
  bool get isDeleted => this == FeedBackRoundsStateStatus.deleted;
  bool get isFailedDelete => this == FeedBackRoundsStateStatus.failedDelete;

  bool get isBackingUp => this == FeedBackRoundsStateStatus.backingUp;
  bool get isCancelBackup => this == FeedBackRoundsStateStatus.cancelBackup;
  bool get isBackedUp => this == FeedBackRoundsStateStatus.backedUp;
  bool get isFailedBackup => this == FeedBackRoundsStateStatus.failedBackup;

  bool get isRestoring => this == FeedBackRoundsStateStatus.restoring;
  bool get isCancelRestore => this == FeedBackRoundsStateStatus.cancelRestore;
  bool get isRestored => this == FeedBackRoundsStateStatus.restored;
  bool get isFailedRestore => this == FeedBackRoundsStateStatus.failedRestore;

  bool get isLoading {
    if (isCreating) return true;
    if (isStreaming) return true;
    if (isFetching) return true;
    if (isFetchedMore) return true;
    if (isSearching) return true;
    if (isUpdating) return true;
    if (isDeleting) return true;
    if (isBackingUp) return true;
    if (isRestoring) return true;
    return false;
  }

  bool get isSuccess {
    if (isCreated) return true;
    if (isStreamed) return true;
    if (isFetched) return true;
    if (isFetchedMore) return true;
    if (isSearched) return true;
    if (isUpdated) return true;
    if (isDeleted) return true;
    if (isBackedUp) return true;
    if (isRestored) return true;
    return false;
  }

  bool get isFailure {
    if (isFailedCreate) return true;
    if (isFailedStream) return true;
    if (isFailedFetch) return true;
    if (isFailedFetchMore) return true;
    if (isFailedSearch) return true;
    if (isFailedUpdate) return true;
    if (isFailedDelete) return true;
    if (isFailedBackup) return true;
    if (isFailedRestore) return true;
    return false;
  }

  bool get isCommanding {
    if (isCreating) return true;
    if (isUpdating) return true;
    if (isDeleting) return true;
    if (isRestoring) return true;
    return false;
  }

  bool get isCommanded {
    if (isCreated) return true;
    if (isUpdated) return true;
    if (isDeleted) return true;
    if (isRestored) return true;
    return false;
  }

  bool get isFailedCommand {
    if (isFailedCreate) return true;
    if (isFailedUpdate) return true;
    if (isFailedDelete) return true;
    if (isFailedRestore) return true;
    return false;
  }

  bool get isQuering {
    if (isStreaming) return true;
    if (isFetching) return true;
    if (isFetchedMore) return true;
    if (isSearching) return true;
    if (isBackingUp) return true;
    return false;
  }

  bool get isQueried {
    if (isStreamed) return true;
    if (isFetched) return true;
    if (isFetchedMore) return true;
    if (isSearched) return true;
    if (isBackedUp) return true;
    return false;
  }

  bool get isFailedQuery {
    if (isFailedStream) return true;
    if (isFailedFetch) return true;
    if (isFailedFetchMore) return true;
    if (isFailedSearch) return true;
    if (isFailedBackup) return true;
    return false;
  }

  bool get canFetchMore {
    return !isFailure &&
        !isLoading &&
        !isCommanded &&
        !isSearched &&
        !isSearching &&
        !isBackingUp &&
        !isBackedUp;
  }

  static FeedBackRoundsStateStatus fromName(String? name,
      [FeedBackRoundsStateStatus value = FeedBackRoundsStateStatus.idle]) {
    if (name == null) return value;
    try {
      return FeedBackRoundsStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class FeedBackRoundsState {
  final FeedBackRoundsStateStatus status;
  final String? error;
  final bool isSortedAscending;
  final String? lastQueriedId;

  /// Total number of `feedBackRounds` filtered and queried
  /// which is expected to be fetched.
  /// All of the documents are fetched if the length
  /// of `feedBackRounds` is greater of equal to this.
  final int? totalFeedBackRounds;
  final Map<String, List<dynamic>> filters;
  final List<FeedBackRound> selected;
  final List<FeedBackRound> searchResult;
  final List<FeedBackRound> feedBackRounds;

  bool get isAllSelected {
    return feedBackRounds.isNotEmpty &&
        selected.length == feedBackRounds.length;
  }

  bool get isAllDataReceived {
    if (totalFeedBackRounds == null) return false;
    return feedBackRounds.length >= totalFeedBackRounds!;
  }

  bool get isLoadedFeedBackRoundsEmpty {
    final isStreamed = status.isStreamed;
    final isFetched = status.isFetched;
    final isFetchedMore = status.isFetchedMore;
    final isSuccess = isStreamed || isFetched || isFetchedMore;
    return isSuccess && feedBackRounds.isEmpty;
  }

  const FeedBackRoundsState({
    required this.status,
    required this.error,
    required this.isSortedAscending,
    required this.lastQueriedId,
    required this.totalFeedBackRounds,
    required this.filters,
    required this.selected,
    required this.searchResult,
    required this.feedBackRounds,
  });

  const FeedBackRoundsState.init({
    this.status = FeedBackRoundsStateStatus.idle,
    this.error,
    this.isSortedAscending = true,
    this.lastQueriedId,
    this.totalFeedBackRounds,
    this.filters = const {},
    this.selected = const [],
    this.searchResult = const [],
    this.feedBackRounds = const [],
  });

  FeedBackRoundsState copyWith({
    FeedBackRoundsStateStatus? status,
    String? error,
    bool? isSortedAscending,
    String? lastQueriedId,
    int? totalFeedBackRounds,
    Map<String, List<dynamic>>? filters,
    List<FeedBackRound>? selected,
    List<FeedBackRound>? searchResult,
    List<FeedBackRound>? feedBackRounds,
  }) {
    return FeedBackRoundsState(
      status: status ?? this.status,
      error: error ?? this.error,
      isSortedAscending: isSortedAscending ?? this.isSortedAscending,
      lastQueriedId: lastQueriedId ?? this.lastQueriedId,
      totalFeedBackRounds: totalFeedBackRounds ?? this.totalFeedBackRounds,
      filters: filters ?? this.filters,
      selected: selected ?? this.selected,
      searchResult: searchResult ?? this.searchResult,
      feedBackRounds: feedBackRounds ?? this.feedBackRounds,
    );
  }

  FeedBackRoundsState idleState() {
    return FeedBackRoundsState(
      status: FeedBackRoundsStateStatus.idle,
      error: null,
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalFeedBackRounds: totalFeedBackRounds,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      feedBackRounds: feedBackRounds,
    );
  }

  FeedBackRoundsState loadingState(FeedBackRoundsStateStatus status) {
    return FeedBackRoundsState(
      status: status,
      error: null,
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalFeedBackRounds: totalFeedBackRounds,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      feedBackRounds: feedBackRounds,
    );
  }

  FeedBackRoundsState successState(
    FeedBackRoundsStateStatus status, {
    bool? isSortedAscending,
    String? lastQueriedId,
    int? totalFeedBackRounds,
    Map<String, List<dynamic>>? filters,
    List<FeedBackRound>? selected,
    List<FeedBackRound>? searchResult,
    List<FeedBackRound>? feedBackRounds,
  }) {
    return FeedBackRoundsState(
      status: status,
      error: null,
      isSortedAscending: isSortedAscending ?? this.isSortedAscending,
      lastQueriedId: lastQueriedId ?? this.lastQueriedId,
      totalFeedBackRounds: totalFeedBackRounds ?? this.totalFeedBackRounds,
      filters: filters ?? this.filters,
      selected: selected ?? this.selected,
      searchResult: searchResult ?? this.searchResult,
      feedBackRounds: feedBackRounds ?? this.feedBackRounds,
    );
  }

  FeedBackRoundsState failureState(
    FeedBackRoundsStateStatus status,
    dynamic error,
  ) {
    return FeedBackRoundsState(
      status: status,
      error: '$error',
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalFeedBackRounds: totalFeedBackRounds,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      feedBackRounds: feedBackRounds,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'isSortedAscending': isSortedAscending,
      'lastQueriedId': lastQueriedId,
      'totalFeedBackRounds': totalFeedBackRounds,
      'filters': filters,
      'selected': selected.map((e) => e.toMap(isFirestore)).toList(),
      'searchResult': searchResult.map((e) => e.toMap(isFirestore)).toList(),
      'feedBackRounds':
          feedBackRounds.map((e) => e.toMap(isFirestore)).toList(),
    };
  }
}
