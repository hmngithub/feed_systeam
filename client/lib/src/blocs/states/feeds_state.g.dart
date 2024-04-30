import '../../domain/entities/feed.g.dart';

enum FeedsStateStatus {
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

extension FeedsStateStatusExt on FeedsStateStatus {
  bool get isIdle => this == FeedsStateStatus.idle;

  bool get isCreating => this == FeedsStateStatus.creating;
  bool get isCanceledCreate => this == FeedsStateStatus.canceledCreate;
  bool get isCreated => this == FeedsStateStatus.created;
  bool get isFailedCreate => this == FeedsStateStatus.failedCreate;

  bool get isStreaming => this == FeedsStateStatus.streaming;
  bool get isStreamed => this == FeedsStateStatus.streamed;
  bool get isFailedStream => this == FeedsStateStatus.failedStream;

  bool get isFetching => this == FeedsStateStatus.fetching;
  bool get isFetched => this == FeedsStateStatus.fetched;
  bool get isFailedFetch => this == FeedsStateStatus.failedFetch;

  bool get isFetchingMore => this == FeedsStateStatus.fetchingMore;
  bool get isFetchedMore => this == FeedsStateStatus.fetchedMore;
  bool get isFailedFetchMore => this == FeedsStateStatus.failedFetchMore;

  bool get isSearching => this == FeedsStateStatus.searching;
  bool get isSearched => this == FeedsStateStatus.searched;
  bool get isFailedSearch => this == FeedsStateStatus.failedSearch;

  bool get isUpdating => this == FeedsStateStatus.updating;
  bool get isCanceledUpdate => this == FeedsStateStatus.canceledUpdate;
  bool get isUpdated => this == FeedsStateStatus.updated;
  bool get isFailedUpdate => this == FeedsStateStatus.failedUpdate;

  bool get isDeleting => this == FeedsStateStatus.deleting;
  bool get isCancelDelete => this == FeedsStateStatus.cancelDelete;
  bool get isDeleted => this == FeedsStateStatus.deleted;
  bool get isFailedDelete => this == FeedsStateStatus.failedDelete;

  bool get isBackingUp => this == FeedsStateStatus.backingUp;
  bool get isCancelBackup => this == FeedsStateStatus.cancelBackup;
  bool get isBackedUp => this == FeedsStateStatus.backedUp;
  bool get isFailedBackup => this == FeedsStateStatus.failedBackup;

  bool get isRestoring => this == FeedsStateStatus.restoring;
  bool get isCancelRestore => this == FeedsStateStatus.cancelRestore;
  bool get isRestored => this == FeedsStateStatus.restored;
  bool get isFailedRestore => this == FeedsStateStatus.failedRestore;

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

  static FeedsStateStatus fromName(String? name,
      [FeedsStateStatus value = FeedsStateStatus.idle]) {
    if (name == null) return value;
    try {
      return FeedsStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class FeedsState {
  final FeedsStateStatus status;
  final String? error;
  final bool isSortedAscending;
  final String? lastQueriedId;

  /// Total number of `feeds` filtered and queried
  /// which is expected to be fetched.
  /// All of the documents are fetched if the length
  /// of `feeds` is greater of equal to this.
  final int? totalFeeds;
  final Map<String, List<dynamic>> filters;
  final List<Feed> selected;
  final List<Feed> searchResult;
  final List<Feed> feeds;

  bool get isAllSelected {
    return feeds.isNotEmpty && selected.length == feeds.length;
  }

  bool get isAllDataReceived {
    if (totalFeeds == null) return false;
    return feeds.length >= totalFeeds!;
  }

  bool get isLoadedFeedsEmpty {
    final isStreamed = status.isStreamed;
    final isFetched = status.isFetched;
    final isFetchedMore = status.isFetchedMore;
    final isSuccess = isStreamed || isFetched || isFetchedMore;
    return isSuccess && feeds.isEmpty;
  }

  const FeedsState({
    required this.status,
    required this.error,
    required this.isSortedAscending,
    required this.lastQueriedId,
    required this.totalFeeds,
    required this.filters,
    required this.selected,
    required this.searchResult,
    required this.feeds,
  });

  const FeedsState.init({
    this.status = FeedsStateStatus.idle,
    this.error,
    this.isSortedAscending = true,
    this.lastQueriedId,
    this.totalFeeds,
    this.filters = const {},
    this.selected = const [],
    this.searchResult = const [],
    this.feeds = const [],
  });

  FeedsState copyWith({
    FeedsStateStatus? status,
    String? error,
    bool? isSortedAscending,
    String? lastQueriedId,
    int? totalFeeds,
    Map<String, List<dynamic>>? filters,
    List<Feed>? selected,
    List<Feed>? searchResult,
    List<Feed>? feeds,
  }) {
    return FeedsState(
      status: status ?? this.status,
      error: error ?? this.error,
      isSortedAscending: isSortedAscending ?? this.isSortedAscending,
      lastQueriedId: lastQueriedId ?? this.lastQueriedId,
      totalFeeds: totalFeeds ?? this.totalFeeds,
      filters: filters ?? this.filters,
      selected: selected ?? this.selected,
      searchResult: searchResult ?? this.searchResult,
      feeds: feeds ?? this.feeds,
    );
  }

  FeedsState idleState() {
    return FeedsState(
      status: FeedsStateStatus.idle,
      error: null,
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalFeeds: totalFeeds,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      feeds: feeds,
    );
  }

  FeedsState loadingState(FeedsStateStatus status) {
    return FeedsState(
      status: status,
      error: null,
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalFeeds: totalFeeds,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      feeds: feeds,
    );
  }

  FeedsState successState(
    FeedsStateStatus status, {
    bool? isSortedAscending,
    String? lastQueriedId,
    int? totalFeeds,
    Map<String, List<dynamic>>? filters,
    List<Feed>? selected,
    List<Feed>? searchResult,
    List<Feed>? feeds,
  }) {
    return FeedsState(
      status: status,
      error: null,
      isSortedAscending: isSortedAscending ?? this.isSortedAscending,
      lastQueriedId: lastQueriedId ?? this.lastQueriedId,
      totalFeeds: totalFeeds ?? this.totalFeeds,
      filters: filters ?? this.filters,
      selected: selected ?? this.selected,
      searchResult: searchResult ?? this.searchResult,
      feeds: feeds ?? this.feeds,
    );
  }

  FeedsState failureState(
    FeedsStateStatus status,
    dynamic error,
  ) {
    return FeedsState(
      status: status,
      error: '$error',
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalFeeds: totalFeeds,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      feeds: feeds,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'isSortedAscending': isSortedAscending,
      'lastQueriedId': lastQueriedId,
      'totalFeeds': totalFeeds,
      'filters': filters,
      'selected': selected.map((e) => e.toMap(isFirestore)).toList(),
      'searchResult': searchResult.map((e) => e.toMap(isFirestore)).toList(),
      'feeds': feeds.map((e) => e.toMap(isFirestore)).toList(),
    };
  }
}
