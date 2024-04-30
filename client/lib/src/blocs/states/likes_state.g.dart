import '../../domain/entities/like.g.dart';

enum LikesStateStatus {
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

extension LikesStateStatusExt on LikesStateStatus {
  bool get isIdle => this == LikesStateStatus.idle;

  bool get isCreating => this == LikesStateStatus.creating;
  bool get isCanceledCreate => this == LikesStateStatus.canceledCreate;
  bool get isCreated => this == LikesStateStatus.created;
  bool get isFailedCreate => this == LikesStateStatus.failedCreate;

  bool get isStreaming => this == LikesStateStatus.streaming;
  bool get isStreamed => this == LikesStateStatus.streamed;
  bool get isFailedStream => this == LikesStateStatus.failedStream;

  bool get isFetching => this == LikesStateStatus.fetching;
  bool get isFetched => this == LikesStateStatus.fetched;
  bool get isFailedFetch => this == LikesStateStatus.failedFetch;

  bool get isFetchingMore => this == LikesStateStatus.fetchingMore;
  bool get isFetchedMore => this == LikesStateStatus.fetchedMore;
  bool get isFailedFetchMore => this == LikesStateStatus.failedFetchMore;

  bool get isSearching => this == LikesStateStatus.searching;
  bool get isSearched => this == LikesStateStatus.searched;
  bool get isFailedSearch => this == LikesStateStatus.failedSearch;

  bool get isUpdating => this == LikesStateStatus.updating;
  bool get isCanceledUpdate => this == LikesStateStatus.canceledUpdate;
  bool get isUpdated => this == LikesStateStatus.updated;
  bool get isFailedUpdate => this == LikesStateStatus.failedUpdate;

  bool get isDeleting => this == LikesStateStatus.deleting;
  bool get isCancelDelete => this == LikesStateStatus.cancelDelete;
  bool get isDeleted => this == LikesStateStatus.deleted;
  bool get isFailedDelete => this == LikesStateStatus.failedDelete;

  bool get isBackingUp => this == LikesStateStatus.backingUp;
  bool get isCancelBackup => this == LikesStateStatus.cancelBackup;
  bool get isBackedUp => this == LikesStateStatus.backedUp;
  bool get isFailedBackup => this == LikesStateStatus.failedBackup;

  bool get isRestoring => this == LikesStateStatus.restoring;
  bool get isCancelRestore => this == LikesStateStatus.cancelRestore;
  bool get isRestored => this == LikesStateStatus.restored;
  bool get isFailedRestore => this == LikesStateStatus.failedRestore;

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

  static LikesStateStatus fromName(String? name,
      [LikesStateStatus value = LikesStateStatus.idle]) {
    if (name == null) return value;
    try {
      return LikesStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class LikesState {
  final LikesStateStatus status;
  final String? error;
  final bool isSortedAscending;
  final String? lastQueriedId;

  /// Total number of `likes` filtered and queried
  /// which is expected to be fetched.
  /// All of the documents are fetched if the length
  /// of `likes` is greater of equal to this.
  final int? totalLikes;
  final Map<String, List<dynamic>> filters;
  final List<Like> selected;
  final List<Like> searchResult;
  final List<Like> likes;

  bool get isAllSelected {
    return likes.isNotEmpty && selected.length == likes.length;
  }

  bool get isAllDataReceived {
    if (totalLikes == null) return false;
    return likes.length >= totalLikes!;
  }

  bool get isLoadedLikesEmpty {
    final isStreamed = status.isStreamed;
    final isFetched = status.isFetched;
    final isFetchedMore = status.isFetchedMore;
    final isSuccess = isStreamed || isFetched || isFetchedMore;
    return isSuccess && likes.isEmpty;
  }

  const LikesState({
    required this.status,
    required this.error,
    required this.isSortedAscending,
    required this.lastQueriedId,
    required this.totalLikes,
    required this.filters,
    required this.selected,
    required this.searchResult,
    required this.likes,
  });

  const LikesState.init({
    this.status = LikesStateStatus.idle,
    this.error,
    this.isSortedAscending = true,
    this.lastQueriedId,
    this.totalLikes,
    this.filters = const {},
    this.selected = const [],
    this.searchResult = const [],
    this.likes = const [],
  });

  LikesState copyWith({
    LikesStateStatus? status,
    String? error,
    bool? isSortedAscending,
    String? lastQueriedId,
    int? totalLikes,
    Map<String, List<dynamic>>? filters,
    List<Like>? selected,
    List<Like>? searchResult,
    List<Like>? likes,
  }) {
    return LikesState(
      status: status ?? this.status,
      error: error ?? this.error,
      isSortedAscending: isSortedAscending ?? this.isSortedAscending,
      lastQueriedId: lastQueriedId ?? this.lastQueriedId,
      totalLikes: totalLikes ?? this.totalLikes,
      filters: filters ?? this.filters,
      selected: selected ?? this.selected,
      searchResult: searchResult ?? this.searchResult,
      likes: likes ?? this.likes,
    );
  }

  LikesState idleState() {
    return LikesState(
      status: LikesStateStatus.idle,
      error: null,
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalLikes: totalLikes,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      likes: likes,
    );
  }

  LikesState loadingState(LikesStateStatus status) {
    return LikesState(
      status: status,
      error: null,
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalLikes: totalLikes,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      likes: likes,
    );
  }

  LikesState successState(
    LikesStateStatus status, {
    bool? isSortedAscending,
    String? lastQueriedId,
    int? totalLikes,
    Map<String, List<dynamic>>? filters,
    List<Like>? selected,
    List<Like>? searchResult,
    List<Like>? likes,
  }) {
    return LikesState(
      status: status,
      error: null,
      isSortedAscending: isSortedAscending ?? this.isSortedAscending,
      lastQueriedId: lastQueriedId ?? this.lastQueriedId,
      totalLikes: totalLikes ?? this.totalLikes,
      filters: filters ?? this.filters,
      selected: selected ?? this.selected,
      searchResult: searchResult ?? this.searchResult,
      likes: likes ?? this.likes,
    );
  }

  LikesState failureState(
    LikesStateStatus status,
    dynamic error,
  ) {
    return LikesState(
      status: status,
      error: '$error',
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalLikes: totalLikes,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      likes: likes,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'isSortedAscending': isSortedAscending,
      'lastQueriedId': lastQueriedId,
      'totalLikes': totalLikes,
      'filters': filters,
      'selected': selected.map((e) => e.toMap(isFirestore)).toList(),
      'searchResult': searchResult.map((e) => e.toMap(isFirestore)).toList(),
      'likes': likes.map((e) => e.toMap(isFirestore)).toList(),
    };
  }
}
