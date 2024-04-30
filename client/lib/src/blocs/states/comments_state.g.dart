import '../../domain/entities/comment.g.dart';

enum CommentsStateStatus {
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

extension CommentsStateStatusExt on CommentsStateStatus {
  bool get isIdle => this == CommentsStateStatus.idle;

  bool get isCreating => this == CommentsStateStatus.creating;
  bool get isCanceledCreate => this == CommentsStateStatus.canceledCreate;
  bool get isCreated => this == CommentsStateStatus.created;
  bool get isFailedCreate => this == CommentsStateStatus.failedCreate;

  bool get isStreaming => this == CommentsStateStatus.streaming;
  bool get isStreamed => this == CommentsStateStatus.streamed;
  bool get isFailedStream => this == CommentsStateStatus.failedStream;

  bool get isFetching => this == CommentsStateStatus.fetching;
  bool get isFetched => this == CommentsStateStatus.fetched;
  bool get isFailedFetch => this == CommentsStateStatus.failedFetch;

  bool get isFetchingMore => this == CommentsStateStatus.fetchingMore;
  bool get isFetchedMore => this == CommentsStateStatus.fetchedMore;
  bool get isFailedFetchMore => this == CommentsStateStatus.failedFetchMore;

  bool get isSearching => this == CommentsStateStatus.searching;
  bool get isSearched => this == CommentsStateStatus.searched;
  bool get isFailedSearch => this == CommentsStateStatus.failedSearch;

  bool get isUpdating => this == CommentsStateStatus.updating;
  bool get isCanceledUpdate => this == CommentsStateStatus.canceledUpdate;
  bool get isUpdated => this == CommentsStateStatus.updated;
  bool get isFailedUpdate => this == CommentsStateStatus.failedUpdate;

  bool get isDeleting => this == CommentsStateStatus.deleting;
  bool get isCancelDelete => this == CommentsStateStatus.cancelDelete;
  bool get isDeleted => this == CommentsStateStatus.deleted;
  bool get isFailedDelete => this == CommentsStateStatus.failedDelete;

  bool get isBackingUp => this == CommentsStateStatus.backingUp;
  bool get isCancelBackup => this == CommentsStateStatus.cancelBackup;
  bool get isBackedUp => this == CommentsStateStatus.backedUp;
  bool get isFailedBackup => this == CommentsStateStatus.failedBackup;

  bool get isRestoring => this == CommentsStateStatus.restoring;
  bool get isCancelRestore => this == CommentsStateStatus.cancelRestore;
  bool get isRestored => this == CommentsStateStatus.restored;
  bool get isFailedRestore => this == CommentsStateStatus.failedRestore;

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

  static CommentsStateStatus fromName(String? name,
      [CommentsStateStatus value = CommentsStateStatus.idle]) {
    if (name == null) return value;
    try {
      return CommentsStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class CommentsState {
  final CommentsStateStatus status;
  final String? error;
  final bool isSortedAscending;
  final String? lastQueriedId;

  /// Total number of `comments` filtered and queried
  /// which is expected to be fetched.
  /// All of the documents are fetched if the length
  /// of `comments` is greater of equal to this.
  final int? totalComments;
  final Map<String, List<dynamic>> filters;
  final List<Comment> selected;
  final List<Comment> searchResult;
  final List<Comment> comments;

  bool get isAllSelected {
    return comments.isNotEmpty && selected.length == comments.length;
  }

  bool get isAllDataReceived {
    if (totalComments == null) return false;
    return comments.length >= totalComments!;
  }

  bool get isLoadedCommentsEmpty {
    final isStreamed = status.isStreamed;
    final isFetched = status.isFetched;
    final isFetchedMore = status.isFetchedMore;
    final isSuccess = isStreamed || isFetched || isFetchedMore;
    return isSuccess && comments.isEmpty;
  }

  const CommentsState({
    required this.status,
    required this.error,
    required this.isSortedAscending,
    required this.lastQueriedId,
    required this.totalComments,
    required this.filters,
    required this.selected,
    required this.searchResult,
    required this.comments,
  });

  const CommentsState.init({
    this.status = CommentsStateStatus.idle,
    this.error,
    this.isSortedAscending = true,
    this.lastQueriedId,
    this.totalComments,
    this.filters = const {},
    this.selected = const [],
    this.searchResult = const [],
    this.comments = const [],
  });

  CommentsState copyWith({
    CommentsStateStatus? status,
    String? error,
    bool? isSortedAscending,
    String? lastQueriedId,
    int? totalComments,
    Map<String, List<dynamic>>? filters,
    List<Comment>? selected,
    List<Comment>? searchResult,
    List<Comment>? comments,
  }) {
    return CommentsState(
      status: status ?? this.status,
      error: error ?? this.error,
      isSortedAscending: isSortedAscending ?? this.isSortedAscending,
      lastQueriedId: lastQueriedId ?? this.lastQueriedId,
      totalComments: totalComments ?? this.totalComments,
      filters: filters ?? this.filters,
      selected: selected ?? this.selected,
      searchResult: searchResult ?? this.searchResult,
      comments: comments ?? this.comments,
    );
  }

  CommentsState idleState() {
    return CommentsState(
      status: CommentsStateStatus.idle,
      error: null,
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalComments: totalComments,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      comments: comments,
    );
  }

  CommentsState loadingState(CommentsStateStatus status) {
    return CommentsState(
      status: status,
      error: null,
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalComments: totalComments,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      comments: comments,
    );
  }

  CommentsState successState(
    CommentsStateStatus status, {
    bool? isSortedAscending,
    String? lastQueriedId,
    int? totalComments,
    Map<String, List<dynamic>>? filters,
    List<Comment>? selected,
    List<Comment>? searchResult,
    List<Comment>? comments,
  }) {
    return CommentsState(
      status: status,
      error: null,
      isSortedAscending: isSortedAscending ?? this.isSortedAscending,
      lastQueriedId: lastQueriedId ?? this.lastQueriedId,
      totalComments: totalComments ?? this.totalComments,
      filters: filters ?? this.filters,
      selected: selected ?? this.selected,
      searchResult: searchResult ?? this.searchResult,
      comments: comments ?? this.comments,
    );
  }

  CommentsState failureState(
    CommentsStateStatus status,
    dynamic error,
  ) {
    return CommentsState(
      status: status,
      error: '$error',
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalComments: totalComments,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      comments: comments,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'isSortedAscending': isSortedAscending,
      'lastQueriedId': lastQueriedId,
      'totalComments': totalComments,
      'filters': filters,
      'selected': selected.map((e) => e.toMap(isFirestore)).toList(),
      'searchResult': searchResult.map((e) => e.toMap(isFirestore)).toList(),
      'comments': comments.map((e) => e.toMap(isFirestore)).toList(),
    };
  }
}
