import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dtos/get_list_request.g.dart';
import 'dtos/get_list_response.g.dart';
import 'dtos/restore_mode.g.dart';

import '../domain/entities/feed.g.dart';
import 'gateways/converse_repository.g.dart';
import 'states/feeds_state.g.dart';

class FeedsBloc extends Cubit<FeedsState> {
  final ConverseRepository _repository;
  FeedsBloc(ConverseRepository converseRepository)
      : _repository = converseRepository,
        super(const FeedsState.init());

  void toInitState() {
    emit(const FeedsState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(FeedsStateStatus status, dynamic error) {
    emit(state.failureState(status, error));
  }

  void replaceFeed(int index, Feed feed) {
    var newFeeds = List<Feed>.from(state.feeds);
    newFeeds[index] = feed;
    emit(state.copyWith(feeds: newFeeds));
  }

  void selectFeed(Feed feed) {
    var selected = List<Feed>.from(state.selected);
    if (selected.any((e) => e.id == feed.id)) {
      selected.removeWhere((e) => e.id == feed.id);
      emit(state.copyWith(selected: selected));
      return;
    }
    selected.add(feed);
    emit(state.copyWith(selected: selected));
  }

  void setSelected(List<Feed> selected) {
    if (state.selected.isNotEmpty) {
      emit(state.copyWith(selected: []));
      return;
    }
    emit(state.copyWith(selected: selected));
  }

  void selectAll() {
    if (state.selected.isNotEmpty) {
      emit(state.copyWith(selected: []));
      return;
    }
    emit(state.copyWith(selected: List<Feed>.from(state.feeds)));
  }

  void sortBy(String key) {
    emit(state.copyWith(isSortedAscending: !state.isSortedAscending));
    var map = state.feeds.map((e) => e.toMap(false)).toList();
    map.sort((a, b) {
      final aKey = (a[key] as String?) ?? '';
      final bKey = (b[key] as String?) ?? '';
      if (state.isSortedAscending) return aKey.compareTo(bKey);
      return bKey.compareTo(aKey);
    });
    var sortedfeeds = map.map((e) => Feed.fromMap(e, null, false)).toList();
    emit(state.copyWith(feeds: sortedfeeds));
  }

  StreamSubscription<GetListResponse<Feed>>? _feedsSub;
  Future<void> streamFeeds({
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isNotEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isLessThan = const <String, dynamic>{},
    Map<String, dynamic> isLessOrEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isGreaterThan = const <String, dynamic>{},
    Map<String, dynamic> isGreaterOrEqualTo = const <String, dynamic>{},
    Map<String, List<dynamic>>? filters,
    int? limit = 11,
    Map<String, bool> orderBy = const {'creationDate': true},
    bool includeUserId = false,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(FeedsStateStatus.streaming));
      if (filters != null) emit(state.copyWith(filters: filters));
      final user = await _repository.fetchCurrentUserInfo();

      var isEqualToQueries = Map<String, dynamic>.from(isEqualTo);
      if (includeUserId) {
        final userId = user.id;
        if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';
        isEqualToQueries['userId'] = userId;
      }

      if (includeBusinessId) {
        final businessId = user.role.business;
        if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';
        isEqualToQueries['businessId'] = businessId;
      }

      final request = GetListRequest.init(
        isEqualToQueries: isEqualToQueries,
        isNotEqualToQueries: isNotEqualTo,
        isLessThanQueries: isLessThan,
        isLessOrEqualToQueries: isLessOrEqualTo,
        isGreaterThanQueries: isGreaterThan,
        isGreaterOrEqualToQueries: isGreaterOrEqualTo,
        lastQueriedId: state.lastQueriedId,
        orQueries: state.filters,
        isTotalCounted: state.totalFeeds != null,
        limit: limit,
        orderBy: orderBy,
      );

      await _feedsSub?.cancel();
      _feedsSub = _repository.streamFeeds(request).listen(
        (resp) {
          emit(state.successState(
            FeedsStateStatus.streamed,
            feeds: resp.entities,
            lastQueriedId: resp.entities.isEmpty ? null : resp.entities.last.id,
            totalFeeds: resp.totalCount,
          ));
        },
        onError: (err) =>
            state.failureState(FeedsStateStatus.failedStream, err),
      );
    } catch (err) {
      emit(state.failureState(FeedsStateStatus.failedStream, err));
    }
  }

  Future<void> fetchFeeds({
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isNotEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isLessThan = const <String, dynamic>{},
    Map<String, dynamic> isLessOrEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isGreaterThan = const <String, dynamic>{},
    Map<String, dynamic> isGreaterOrEqualTo = const <String, dynamic>{},
    Map<String, List<dynamic>>? filters,
    int? limit = 11,
    Map<String, bool> orderBy = const {'creationDate': true},
    bool includeUserId = false,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(FeedsStateStatus.fetching));
      if (filters != null) emit(state.copyWith(filters: filters));
      await _feedsSub?.cancel();
      final user = await _repository.fetchCurrentUserInfo();

      var isEqualToQueries = Map<String, dynamic>.from(isEqualTo);
      if (includeUserId) {
        final userId = user.id;
        if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';
        isEqualToQueries['userId'] = userId;
      }

      if (includeBusinessId) {
        final businessId = user.role.business;
        if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';
        isEqualToQueries['businessId'] = businessId;
      }

      final resp = await _repository.fetchFeeds(GetListRequest.init(
        isEqualToQueries: isEqualToQueries,
        isNotEqualToQueries: isNotEqualTo,
        isLessThanQueries: isLessThan,
        isLessOrEqualToQueries: isLessOrEqualTo,
        isGreaterThanQueries: isGreaterThan,
        isGreaterOrEqualToQueries: isGreaterOrEqualTo,
        lastQueriedId: state.lastQueriedId,
        orQueries: state.filters,
        isTotalCounted: state.totalFeeds != null,
        limit: limit,
        orderBy: orderBy,
      ));

      emit(state.successState(
        FeedsStateStatus.fetched,
        feeds: resp.entities,
        lastQueriedId: resp.entities.isEmpty ? null : resp.entities.last.id,
        totalFeeds: resp.totalCount,
      ));
    } catch (err) {
      emit(state.failureState(FeedsStateStatus.failedFetch, err));
    }
  }

  Future<void> fetchMoreFeeds({
    String? searchTag,
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isNotEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isLessThan = const <String, dynamic>{},
    Map<String, dynamic> isLessOrEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isGreaterThan = const <String, dynamic>{},
    Map<String, dynamic> isGreaterOrEqualTo = const <String, dynamic>{},
    Map<String, List<dynamic>>? filters,
    int? limit = 11,
    Map<String, bool> orderBy = const {'creationDate': true},
    bool includeUserId = false,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(FeedsStateStatus.fetchingMore));
      if (filters != null) emit(state.copyWith(filters: filters));
      if (state.isAllDataReceived) {
        emit(state.successState(FeedsStateStatus.fetchedMore));
        return;
      }

      final user = await _repository.fetchCurrentUserInfo();
      var isEqualToQueries = Map<String, dynamic>.from(isEqualTo);
      if (includeUserId) {
        final userId = user.id;
        if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';
        isEqualToQueries['userId'] = userId;
      }

      if (includeBusinessId) {
        final businessId = user.role.business;
        if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';
        isEqualToQueries['businessId'] = businessId;
      }

      final resp = await _repository.fetchFeeds(GetListRequest.init(
        isEqualToQueries: isEqualToQueries,
        isNotEqualToQueries: isNotEqualTo,
        isLessThanQueries: isLessThan,
        isLessOrEqualToQueries: isLessOrEqualTo,
        isGreaterThanQueries: isGreaterThan,
        isGreaterOrEqualToQueries: isGreaterOrEqualTo,
        lastQueriedId: state.lastQueriedId,
        searchTag: (searchTag ?? '').trim().isEmpty ? null : searchTag?.trim(),
        orQueries: state.filters,
        isTotalCounted: state.totalFeeds != null,
        limit: limit,
        orderBy: orderBy,
      ));

      String? lastFeedId;
      if (resp.entities.isNotEmpty) {
        lastFeedId = resp.entities.last.id;
      }

      var newfeeds = List<Feed>.from(state.feeds);
      for (var entity in resp.entities) {
        final foundIndex = newfeeds.indexWhere((e) => e.id == entity.id);
        if (foundIndex >= 0) {
          newfeeds.removeAt(foundIndex);
          newfeeds.insert(foundIndex, entity);
        } else {
          newfeeds.add(entity);
        }
      }

      emit(state.successState(
        FeedsStateStatus.fetchedMore,
        feeds: newfeeds,
        lastQueriedId: lastFeedId,
        totalFeeds: resp.totalCount,
      ));
    } catch (err) {
      emit(state.failureState(FeedsStateStatus.failedFetch, err));
    }
  }

  Future<void> searchFeeds(
    String searchTag, {
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isNotEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isLessThan = const <String, dynamic>{},
    Map<String, dynamic> isLessOrEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isGreaterThan = const <String, dynamic>{},
    Map<String, dynamic> isGreaterOrEqualTo = const <String, dynamic>{},
    Map<String, List<dynamic>>? filters,
    int? limit = 11,
    Map<String, bool> orderBy = const {'creationDate': true},
    bool includeUserId = false,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(FeedsStateStatus.searching));
      if (filters != null) emit(state.copyWith(filters: filters));
      final user = await _repository.fetchCurrentUserInfo();

      var isEqualToQueries = Map<String, dynamic>.from(isEqualTo);
      if (includeUserId) {
        final userId = user.id;
        if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';
        isEqualToQueries['userId'] = userId;
      }

      if (includeBusinessId) {
        final businessId = user.role.business;
        if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';
        isEqualToQueries['businessId'] = businessId;
      }

      final request = GetListRequest.init(
        isEqualToQueries: isEqualToQueries,
        isNotEqualToQueries: isNotEqualTo,
        isLessThanQueries: isLessThan,
        isLessOrEqualToQueries: isLessOrEqualTo,
        isGreaterThanQueries: isGreaterThan,
        isGreaterOrEqualToQueries: isGreaterOrEqualTo,
        searchTag: searchTag.trim(),
        orderBy: orderBy,
        limit: limit,
      );

      final result = await _repository.fetchFeeds(request);
      if (searchTag.trim().isEmpty) {
        emit(state.successState(FeedsStateStatus.streamed));
        return;
      }

      emit(state.successState(
        FeedsStateStatus.searched,
        searchResult: result.entities,
      ));
    } catch (e) {
      emit(state.failureState(FeedsStateStatus.failedSearch, e));
    }
  }

  void deleteFeed(String? id) async {
    if (id == null) return;
    try {
      emit(state.loadingState(FeedsStateStatus.deleting));
      _feedsSub?.pause();

      await _repository.deleteFeed(id);
      emit(state.successState(FeedsStateStatus.deleted));

      _feedsSub?.resume();
    } catch (err) {
      emit(state.failureState(FeedsStateStatus.failedDelete, err));
    }
  }

  void deleteSelected() async {
    try {
      emit(state.loadingState(FeedsStateStatus.deleting));
      _feedsSub?.pause();

      var feedIds = state.selected.map((e) => e.id ?? '').toList();
      feedIds.removeWhere((e) => e.isEmpty);
      await _repository.deleteFeeds(feedIds);
      emit(state.successState(FeedsStateStatus.deleted));

      _feedsSub?.resume();
    } catch (err) {
      emit(state.failureState(FeedsStateStatus.failedDelete, err));
    }
  }

  void deleteAll() async {
    try {
      emit(state.loadingState(FeedsStateStatus.deleting));
      _feedsSub?.pause();

      var feedIds = state.feeds.map((e) => e.id ?? '').toList();
      feedIds.removeWhere((e) => e.isEmpty);

      await _repository.deleteFeeds(feedIds);

      emit(state.successState(FeedsStateStatus.deleted));
      _feedsSub?.resume();
    } catch (err) {
      emit(state.failureState(FeedsStateStatus.failedDelete, err));
    }
  }

  void backUpSelected() async {
    try {
      emit(state.loadingState(FeedsStateStatus.backingUp));
      await _repository.backUpFeeds(state.selected);
      emit(state.successState(FeedsStateStatus.backedUp));
    } catch (err) {
      emit(state.failureState(FeedsStateStatus.failedBackup, err));
    }
  }

  void backUpAll({
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    bool includeUserId = false,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(FeedsStateStatus.backingUp));
      final user = await _repository.fetchCurrentUserInfo();

      var isEqualToQueries = Map<String, dynamic>.from(isEqualTo);
      if (includeUserId) {
        final userId = user.id;
        if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';
        isEqualToQueries['userId'] = userId;
      }

      if (includeBusinessId) {
        final businessId = user.role.business;
        if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';
        isEqualToQueries['businessId'] = businessId;
      }

      await _repository.backUpAllFeeds(isEqualToQueries);
      emit(state.successState(FeedsStateStatus.backedUp));
    } catch (err) {
      emit(state.failureState(FeedsStateStatus.failedBackup, err));
    }
  }

  void restoreFeeds(
    RestoreMode mode, {
    Map<String, dynamic> replacements = const <String, dynamic>{},
    bool includeUserId = false,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(FeedsStateStatus.restoring));
      _feedsSub?.pause();

      final user = await _repository.fetchCurrentUserInfo();
      var allReplacements = Map<String, dynamic>.from(replacements);
      if (includeUserId) {
        final userId = user.id;
        if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';
        allReplacements['userId'] = userId;
      }

      if (includeBusinessId) {
        final businessId = user.role.business;
        if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';
        allReplacements['businessId'] = businessId;
      }

      await _repository.restoreFeeds(allReplacements, mode);

      emit(state.successState(FeedsStateStatus.restored));
      _feedsSub?.resume();
    } catch (err) {
      emit(state.failureState(FeedsStateStatus.failedRestore, err));
    }
  }

  Future<void> createFeeds([List<Feed> feeds = const []]) async {
    try {
      emit(state.loadingState(FeedsStateStatus.creating));
      _feedsSub?.pause();
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      var newList = feeds.map((e) {
        return e.copyWith(
          businessId: businessId,
          userId: userId,
          creationDate: DateTime.now(),
          creatorId: userId,
        );
      }).toList();

      if (newList.isEmpty) {
        newList = state.feeds.map((e) {
          return e.copyWith(
            businessId: businessId,
            userId: userId,
            creationDate: DateTime.now(),
            creatorId: userId,
          );
        }).toList();
      }

      await _repository.createFeeds(newList);
      emit(state.successState(FeedsStateStatus.created));

      _feedsSub?.resume();
    } catch (e) {
      emit(state.failureState(FeedsStateStatus.failedCreate, e));
    }
  }

  Future<void> updateFeeds([List<Feed> feeds = const []]) async {
    try {
      emit(state.loadingState(FeedsStateStatus.updating));
      _feedsSub?.pause();
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      var newList = feeds.map((e) {
        return e.copyWith(
          businessId: businessId,
          // userId: userId,
          lastModifiedDate: DateTime.now(),
          lastModifierId: userId,
        );
      }).toList();

      if (newList.isEmpty) {
        newList = state.feeds.map((e) {
          return e.copyWith(
            businessId: businessId,
            // userId: userId,
            lastModifiedDate: DateTime.now(),
            lastModifierId: userId,
          );
        }).toList();
      }

      await _repository.updateFeeds(newList);
      emit(state.successState(FeedsStateStatus.updated));

      _feedsSub?.resume();
    } catch (e) {
      emit(state.failureState(FeedsStateStatus.failedUpdate, e));
    }
  }

  @override
  Future<void> close() async {
    await _feedsSub?.cancel();
    return super.close();
  }
}
