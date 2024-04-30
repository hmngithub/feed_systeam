import '../../domain/entities/media.g.dart';

enum MediasStateStatus {
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

extension MediasStateStatusExt on MediasStateStatus {
  bool get isIdle => this == MediasStateStatus.idle;

  bool get isCreating => this == MediasStateStatus.creating;
  bool get isCanceledCreate => this == MediasStateStatus.canceledCreate;
  bool get isCreated => this == MediasStateStatus.created;
  bool get isFailedCreate => this == MediasStateStatus.failedCreate;

  bool get isStreaming => this == MediasStateStatus.streaming;
  bool get isStreamed => this == MediasStateStatus.streamed;
  bool get isFailedStream => this == MediasStateStatus.failedStream;

  bool get isFetching => this == MediasStateStatus.fetching;
  bool get isFetched => this == MediasStateStatus.fetched;
  bool get isFailedFetch => this == MediasStateStatus.failedFetch;

  bool get isFetchingMore => this == MediasStateStatus.fetchingMore;
  bool get isFetchedMore => this == MediasStateStatus.fetchedMore;
  bool get isFailedFetchMore => this == MediasStateStatus.failedFetchMore;

  bool get isSearching => this == MediasStateStatus.searching;
  bool get isSearched => this == MediasStateStatus.searched;
  bool get isFailedSearch => this == MediasStateStatus.failedSearch;

  bool get isUpdating => this == MediasStateStatus.updating;
  bool get isCanceledUpdate => this == MediasStateStatus.canceledUpdate;
  bool get isUpdated => this == MediasStateStatus.updated;
  bool get isFailedUpdate => this == MediasStateStatus.failedUpdate;

  bool get isDeleting => this == MediasStateStatus.deleting;
  bool get isCancelDelete => this == MediasStateStatus.cancelDelete;
  bool get isDeleted => this == MediasStateStatus.deleted;
  bool get isFailedDelete => this == MediasStateStatus.failedDelete;

  bool get isBackingUp => this == MediasStateStatus.backingUp;
  bool get isCancelBackup => this == MediasStateStatus.cancelBackup;
  bool get isBackedUp => this == MediasStateStatus.backedUp;
  bool get isFailedBackup => this == MediasStateStatus.failedBackup;

  bool get isRestoring => this == MediasStateStatus.restoring;
  bool get isCancelRestore => this == MediasStateStatus.cancelRestore;
  bool get isRestored => this == MediasStateStatus.restored;
  bool get isFailedRestore => this == MediasStateStatus.failedRestore;

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

  static MediasStateStatus fromName(String? name,
      [MediasStateStatus value = MediasStateStatus.idle]) {
    if (name == null) return value;
    try {
      return MediasStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class MediasState {
  final MediasStateStatus status;
  final String? error;
  final bool isSortedAscending;
  final String? lastQueriedId;

  /// Total number of `medias` filtered and queried
  /// which is expected to be fetched.
  /// All of the documents are fetched if the length
  /// of `medias` is greater of equal to this.
  final int? totalMedias;
  final Map<String, List<dynamic>> filters;
  final List<Media> selected;
  final List<Media> searchResult;
  final List<Media> medias;

  bool get isAllSelected {
    return medias.isNotEmpty && selected.length == medias.length;
  }

  bool get isAllDataReceived {
    if (totalMedias == null) return false;
    return medias.length >= totalMedias!;
  }

  bool get isLoadedMediasEmpty {
    final isStreamed = status.isStreamed;
    final isFetched = status.isFetched;
    final isFetchedMore = status.isFetchedMore;
    final isSuccess = isStreamed || isFetched || isFetchedMore;
    return isSuccess && medias.isEmpty;
  }

  const MediasState({
    required this.status,
    required this.error,
    required this.isSortedAscending,
    required this.lastQueriedId,
    required this.totalMedias,
    required this.filters,
    required this.selected,
    required this.searchResult,
    required this.medias,
  });

  const MediasState.init({
    this.status = MediasStateStatus.idle,
    this.error,
    this.isSortedAscending = true,
    this.lastQueriedId,
    this.totalMedias,
    this.filters = const {},
    this.selected = const [],
    this.searchResult = const [],
    this.medias = const [],
  });

  MediasState copyWith({
    MediasStateStatus? status,
    String? error,
    bool? isSortedAscending,
    String? lastQueriedId,
    int? totalMedias,
    Map<String, List<dynamic>>? filters,
    List<Media>? selected,
    List<Media>? searchResult,
    List<Media>? medias,
  }) {
    return MediasState(
      status: status ?? this.status,
      error: error ?? this.error,
      isSortedAscending: isSortedAscending ?? this.isSortedAscending,
      lastQueriedId: lastQueriedId ?? this.lastQueriedId,
      totalMedias: totalMedias ?? this.totalMedias,
      filters: filters ?? this.filters,
      selected: selected ?? this.selected,
      searchResult: searchResult ?? this.searchResult,
      medias: medias ?? this.medias,
    );
  }

  MediasState idleState() {
    return MediasState(
      status: MediasStateStatus.idle,
      error: null,
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalMedias: totalMedias,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      medias: medias,
    );
  }

  MediasState loadingState(MediasStateStatus status) {
    return MediasState(
      status: status,
      error: null,
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalMedias: totalMedias,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      medias: medias,
    );
  }

  MediasState successState(
    MediasStateStatus status, {
    bool? isSortedAscending,
    String? lastQueriedId,
    int? totalMedias,
    Map<String, List<dynamic>>? filters,
    List<Media>? selected,
    List<Media>? searchResult,
    List<Media>? medias,
  }) {
    return MediasState(
      status: status,
      error: null,
      isSortedAscending: isSortedAscending ?? this.isSortedAscending,
      lastQueriedId: lastQueriedId ?? this.lastQueriedId,
      totalMedias: totalMedias ?? this.totalMedias,
      filters: filters ?? this.filters,
      selected: selected ?? this.selected,
      searchResult: searchResult ?? this.searchResult,
      medias: medias ?? this.medias,
    );
  }

  MediasState failureState(
    MediasStateStatus status,
    dynamic error,
  ) {
    return MediasState(
      status: status,
      error: '$error',
      isSortedAscending: isSortedAscending,
      lastQueriedId: lastQueriedId,
      totalMedias: totalMedias,
      filters: filters,
      selected: selected,
      searchResult: searchResult,
      medias: medias,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'isSortedAscending': isSortedAscending,
      'lastQueriedId': lastQueriedId,
      'totalMedias': totalMedias,
      'filters': filters,
      'selected': selected.map((e) => e.toMap(isFirestore)).toList(),
      'searchResult': searchResult.map((e) => e.toMap(isFirestore)).toList(),
      'medias': medias.map((e) => e.toMap(isFirestore)).toList(),
    };
  }
}
