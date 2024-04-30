import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dtos/get_list_request.g.dart';
import 'dtos/get_list_response.g.dart';
import 'dtos/restore_mode.g.dart';

import '../domain/entities/feed_back_round.g.dart';
import 'gateways/converse_repository.g.dart';
import 'states/feed_back_rounds_state.g.dart';

class FeedBackRoundsBloc extends Cubit<FeedBackRoundsState> {
  final ConverseRepository _repository;
  FeedBackRoundsBloc(ConverseRepository converseRepository)
      : _repository = converseRepository,
        super(const FeedBackRoundsState.init());

  void toInitState() {
    emit(const FeedBackRoundsState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(FeedBackRoundsStateStatus status, dynamic error) {
    emit(state.failureState(status, error));
  }

  void replaceFeedBackRound(int index, FeedBackRound feedBackRound) {
    var newFeedBackRounds = List<FeedBackRound>.from(state.feedBackRounds);
    newFeedBackRounds[index] = feedBackRound;
    emit(state.copyWith(feedBackRounds: newFeedBackRounds));
  }

  void selectFeedBackRound(FeedBackRound feedBackRound) {
    var selected = List<FeedBackRound>.from(state.selected);
    if (selected.any((e) => e.id == feedBackRound.id)) {
      selected.removeWhere((e) => e.id == feedBackRound.id);
      emit(state.copyWith(selected: selected));
      return;
    }
    selected.add(feedBackRound);
    emit(state.copyWith(selected: selected));
  }

  void setSelected(List<FeedBackRound> selected) {
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
    emit(state.copyWith(
        selected: List<FeedBackRound>.from(state.feedBackRounds)));
  }

  void sortBy(String key) {
    emit(state.copyWith(isSortedAscending: !state.isSortedAscending));
    var map = state.feedBackRounds.map((e) => e.toMap(false)).toList();
    map.sort((a, b) {
      final aKey = (a[key] as String?) ?? '';
      final bKey = (b[key] as String?) ?? '';
      if (state.isSortedAscending) return aKey.compareTo(bKey);
      return bKey.compareTo(aKey);
    });
    var sortedfeedBackRounds =
        map.map((e) => FeedBackRound.fromMap(e, null, false)).toList();
    emit(state.copyWith(feedBackRounds: sortedfeedBackRounds));
  }

  StreamSubscription<GetListResponse<FeedBackRound>>? _feedBackRoundsSub;
  Future<void> streamFeedBackRounds({
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isNotEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isLessThan = const <String, dynamic>{},
    Map<String, dynamic> isLessOrEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isGreaterThan = const <String, dynamic>{},
    Map<String, dynamic> isGreaterOrEqualTo = const <String, dynamic>{},
    Map<String, List<dynamic>>? filters,
    int? limit = 11,
    Map<String, bool> orderBy = const <String, bool>{},
    bool includeUserId = false,
    bool includeBusinessId = false,
  }) async {
    try {
      emit(state.loadingState(FeedBackRoundsStateStatus.streaming));
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
        isTotalCounted: state.totalFeedBackRounds != null,
        limit: limit,
        orderBy: orderBy,
      );

      await _feedBackRoundsSub?.cancel();
      _feedBackRoundsSub = _repository.streamFeedBackRounds(request).listen(
        (resp) {
          emit(state.successState(
            FeedBackRoundsStateStatus.streamed,
            feedBackRounds: resp.entities,
            lastQueriedId: resp.entities.isEmpty ? null : resp.entities.last.id,
            totalFeedBackRounds: resp.totalCount,
          ));
        },
        onError: (err) =>
            state.failureState(FeedBackRoundsStateStatus.failedStream, err),
      );
    } catch (err) {
      emit(state.failureState(FeedBackRoundsStateStatus.failedStream, err));
    }
  }

  Future<void> fetchFeedBackRounds({
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isNotEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isLessThan = const <String, dynamic>{},
    Map<String, dynamic> isLessOrEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isGreaterThan = const <String, dynamic>{},
    Map<String, dynamic> isGreaterOrEqualTo = const <String, dynamic>{},
    Map<String, List<dynamic>>? filters,
    int? limit = 11,
    Map<String, bool> orderBy = const <String, bool>{},
    bool includeUserId = false,
    bool includeBusinessId = false,
  }) async {
    try {
      emit(state.loadingState(FeedBackRoundsStateStatus.fetching));
      if (filters != null) emit(state.copyWith(filters: filters));
      await _feedBackRoundsSub?.cancel();
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

      final resp = await _repository.fetchFeedBackRounds(GetListRequest.init(
        isEqualToQueries: isEqualToQueries,
        isNotEqualToQueries: isNotEqualTo,
        isLessThanQueries: isLessThan,
        isLessOrEqualToQueries: isLessOrEqualTo,
        isGreaterThanQueries: isGreaterThan,
        isGreaterOrEqualToQueries: isGreaterOrEqualTo,
        lastQueriedId: state.lastQueriedId,
        orQueries: state.filters,
        isTotalCounted: state.totalFeedBackRounds != null,
        limit: limit,
        orderBy: orderBy,
      ));

      emit(state.successState(
        FeedBackRoundsStateStatus.fetched,
        feedBackRounds: resp.entities,
        lastQueriedId: resp.entities.isEmpty ? null : resp.entities.last.id,
        totalFeedBackRounds: resp.totalCount,
      ));
    } catch (err) {
      emit(state.failureState(FeedBackRoundsStateStatus.failedFetch, err));
    }
  }

  Future<void> fetchMoreFeedBackRounds({
    String? searchTag,
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isNotEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isLessThan = const <String, dynamic>{},
    Map<String, dynamic> isLessOrEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isGreaterThan = const <String, dynamic>{},
    Map<String, dynamic> isGreaterOrEqualTo = const <String, dynamic>{},
    Map<String, List<dynamic>>? filters,
    int? limit = 11,
    Map<String, bool> orderBy = const <String, bool>{},
    bool includeUserId = false,
    bool includeBusinessId = false,
  }) async {
    try {
      emit(state.loadingState(FeedBackRoundsStateStatus.fetchingMore));
      if (filters != null) emit(state.copyWith(filters: filters));
      if (state.isAllDataReceived) {
        emit(state.successState(FeedBackRoundsStateStatus.fetchedMore));
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

      final resp = await _repository.fetchFeedBackRounds(GetListRequest.init(
        isEqualToQueries: isEqualToQueries,
        isNotEqualToQueries: isNotEqualTo,
        isLessThanQueries: isLessThan,
        isLessOrEqualToQueries: isLessOrEqualTo,
        isGreaterThanQueries: isGreaterThan,
        isGreaterOrEqualToQueries: isGreaterOrEqualTo,
        lastQueriedId: state.lastQueriedId,
        searchTag: (searchTag ?? '').trim().isEmpty ? null : searchTag?.trim(),
        orQueries: state.filters,
        isTotalCounted: state.totalFeedBackRounds != null,
        limit: limit,
        orderBy: orderBy,
      ));

      String? lastFeedBackRoundId;
      if (resp.entities.isNotEmpty) {
        lastFeedBackRoundId = resp.entities.last.id;
      }

      var newfeedBackRounds = List<FeedBackRound>.from(state.feedBackRounds);
      for (var entity in resp.entities) {
        final foundIndex =
            newfeedBackRounds.indexWhere((e) => e.id == entity.id);
        if (foundIndex >= 0) {
          newfeedBackRounds.removeAt(foundIndex);
          newfeedBackRounds.insert(foundIndex, entity);
        } else {
          newfeedBackRounds.add(entity);
        }
      }

      emit(state.successState(
        FeedBackRoundsStateStatus.fetchedMore,
        feedBackRounds: newfeedBackRounds,
        lastQueriedId: lastFeedBackRoundId,
        totalFeedBackRounds: resp.totalCount,
      ));
    } catch (err) {
      emit(state.failureState(FeedBackRoundsStateStatus.failedFetch, err));
    }
  }

  Future<void> searchFeedBackRounds(
    String searchTag, {
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isNotEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isLessThan = const <String, dynamic>{},
    Map<String, dynamic> isLessOrEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isGreaterThan = const <String, dynamic>{},
    Map<String, dynamic> isGreaterOrEqualTo = const <String, dynamic>{},
    Map<String, List<dynamic>>? filters,
    int? limit = 11,
    Map<String, bool> orderBy = const <String, bool>{},
    bool includeUserId = false,
    bool includeBusinessId = false,
  }) async {
    try {
      emit(state.loadingState(FeedBackRoundsStateStatus.searching));
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

      final result = await _repository.fetchFeedBackRounds(request);
      if (searchTag.trim().isEmpty) {
        emit(state.successState(FeedBackRoundsStateStatus.streamed));
        return;
      }

      emit(state.successState(
        FeedBackRoundsStateStatus.searched,
        searchResult: result.entities,
      ));
    } catch (e) {
      emit(state.failureState(FeedBackRoundsStateStatus.failedSearch, e));
    }
  }

  void deleteFeedBackRound(String? id) async {
    if (id == null) return;
    try {
      emit(state.loadingState(FeedBackRoundsStateStatus.deleting));
      _feedBackRoundsSub?.pause();

      await _repository.deleteFeedBackRound(id);
      emit(state.successState(FeedBackRoundsStateStatus.deleted));

      _feedBackRoundsSub?.resume();
    } catch (err) {
      emit(state.failureState(FeedBackRoundsStateStatus.failedDelete, err));
    }
  }

  void deleteSelected() async {
    try {
      emit(state.loadingState(FeedBackRoundsStateStatus.deleting));
      _feedBackRoundsSub?.pause();

      var feedBackRoundIds = state.selected.map((e) => e.id ?? '').toList();
      feedBackRoundIds.removeWhere((e) => e.isEmpty);
      await _repository.deleteFeedBackRounds(feedBackRoundIds);
      emit(state.successState(FeedBackRoundsStateStatus.deleted));

      _feedBackRoundsSub?.resume();
    } catch (err) {
      emit(state.failureState(FeedBackRoundsStateStatus.failedDelete, err));
    }
  }

  void deleteAll() async {
    try {
      emit(state.loadingState(FeedBackRoundsStateStatus.deleting));
      _feedBackRoundsSub?.pause();

      var feedBackRoundIds =
          state.feedBackRounds.map((e) => e.id ?? '').toList();
      feedBackRoundIds.removeWhere((e) => e.isEmpty);

      await _repository.deleteFeedBackRounds(feedBackRoundIds);

      emit(state.successState(FeedBackRoundsStateStatus.deleted));
      _feedBackRoundsSub?.resume();
    } catch (err) {
      emit(state.failureState(FeedBackRoundsStateStatus.failedDelete, err));
    }
  }

  void backUpSelected() async {
    try {
      emit(state.loadingState(FeedBackRoundsStateStatus.backingUp));
      await _repository.backUpFeedBackRounds(state.selected);
      emit(state.successState(FeedBackRoundsStateStatus.backedUp));
    } catch (err) {
      emit(state.failureState(FeedBackRoundsStateStatus.failedBackup, err));
    }
  }

  void backUpAll({
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    bool includeUserId = false,
    bool includeBusinessId = false,
  }) async {
    try {
      emit(state.loadingState(FeedBackRoundsStateStatus.backingUp));
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

      await _repository.backUpAllFeedBackRounds(isEqualToQueries);
      emit(state.successState(FeedBackRoundsStateStatus.backedUp));
    } catch (err) {
      emit(state.failureState(FeedBackRoundsStateStatus.failedBackup, err));
    }
  }

  void restoreFeedBackRounds(
    RestoreMode mode, {
    Map<String, dynamic> replacements = const <String, dynamic>{},
    bool includeUserId = false,
    bool includeBusinessId = false,
  }) async {
    try {
      emit(state.loadingState(FeedBackRoundsStateStatus.restoring));
      _feedBackRoundsSub?.pause();

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

      await _repository.restoreFeedBackRounds(allReplacements, mode);

      emit(state.successState(FeedBackRoundsStateStatus.restored));
      _feedBackRoundsSub?.resume();
    } catch (err) {
      emit(state.failureState(FeedBackRoundsStateStatus.failedRestore, err));
    }
  }

  Future<void> createFeedBackRounds(
      [List<FeedBackRound> feedBackRounds = const []]) async {
    try {
      emit(state.loadingState(FeedBackRoundsStateStatus.creating));
      _feedBackRoundsSub?.pause();
      final user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      var newList = feedBackRounds.map((e) {
        return e.copyWith(
          creationDate: DateTime.now(),
          creatorId: userId,
        );
      }).toList();

      if (newList.isEmpty) {
        newList = state.feedBackRounds.map((e) {
          return e.copyWith(
            creationDate: DateTime.now(),
            creatorId: userId,
          );
        }).toList();
      }

      await _repository.createFeedBackRounds(newList);
      emit(state.successState(FeedBackRoundsStateStatus.created));

      _feedBackRoundsSub?.resume();
    } catch (e) {
      emit(state.failureState(FeedBackRoundsStateStatus.failedCreate, e));
    }
  }

  Future<void> updateFeedBackRounds(
      [List<FeedBackRound> feedBackRounds = const []]) async {
    try {
      emit(state.loadingState(FeedBackRoundsStateStatus.updating));
      _feedBackRoundsSub?.pause();
      final user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      var newList = feedBackRounds.map((e) {
        return e.copyWith(
          creationDate: DateTime.now(),
          creatorId: userId,
        );
      }).toList();

      if (newList.isEmpty) {
        newList = state.feedBackRounds.map((e) {
          return e.copyWith(
            creationDate: DateTime.now(),
            creatorId: userId,
          );
        }).toList();
      }

      await _repository.updateFeedBackRounds(newList);
      emit(state.successState(FeedBackRoundsStateStatus.updated));

      _feedBackRoundsSub?.resume();
    } catch (e) {
      emit(state.failureState(FeedBackRoundsStateStatus.failedUpdate, e));
    }
  }

  @override
  Future<void> close() async {
    await _feedBackRoundsSub?.cancel();
    return super.close();
  }
}
