import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dtos/get_list_request.g.dart';
import 'dtos/get_list_response.g.dart';
import 'dtos/restore_mode.g.dart';

import '../domain/entities/like.g.dart';
import 'gateways/converse_repository.g.dart';
import 'states/likes_state.g.dart';

class LikesBloc extends Cubit<LikesState> {
  final ConverseRepository _repository;
  LikesBloc(ConverseRepository converseRepository)
      : _repository = converseRepository,
        super(const LikesState.init());

  void toInitState() {
    emit(const LikesState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(LikesStateStatus status, dynamic error) {
    emit(state.failureState(status, error));
  }

  void replaceLike(int index, Like like) {
    var newLikes = List<Like>.from(state.likes);
    newLikes[index] = like;
    emit(state.copyWith(likes: newLikes));
  }

  void selectLike(Like like) {
    var selected = List<Like>.from(state.selected);
    if (selected.any((e) => e.id == like.id)) {
      selected.removeWhere((e) => e.id == like.id);
      emit(state.copyWith(selected: selected));
      return;
    }
    selected.add(like);
    emit(state.copyWith(selected: selected));
  }

  void setSelected(List<Like> selected) {
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
    emit(state.copyWith(selected: List<Like>.from(state.likes)));
  }

  void sortBy(String key) {
    emit(state.copyWith(isSortedAscending: !state.isSortedAscending));
    var map = state.likes.map((e) => e.toMap(false)).toList();
    map.sort((a, b) {
      final aKey = (a[key] as String?) ?? '';
      final bKey = (b[key] as String?) ?? '';
      if (state.isSortedAscending) return aKey.compareTo(bKey);
      return bKey.compareTo(aKey);
    });
    var sortedlikes = map.map((e) => Like.fromMap(e, null, false)).toList();
    emit(state.copyWith(likes: sortedlikes));
  }

  StreamSubscription<GetListResponse<Like>>? _likesSub;
  Future<void> streamLikes({
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isNotEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isLessThan = const <String, dynamic>{},
    Map<String, dynamic> isLessOrEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isGreaterThan = const <String, dynamic>{},
    Map<String, dynamic> isGreaterOrEqualTo = const <String, dynamic>{},
    Map<String, List<dynamic>>? filters,
    int? limit = 11,
    Map<String, bool> orderBy = const <String, bool>{},
    bool includeUserId = true,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(LikesStateStatus.streaming));
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
        isTotalCounted: state.totalLikes != null,
        limit: limit,
        orderBy: orderBy,
      );

      await _likesSub?.cancel();
      _likesSub = _repository.streamLikes(request).listen(
        (resp) {
          emit(state.successState(
            LikesStateStatus.streamed,
            likes: resp.entities,
            lastQueriedId: resp.entities.isEmpty ? null : resp.entities.last.id,
            totalLikes: resp.totalCount,
          ));
        },
        onError: (err) =>
            state.failureState(LikesStateStatus.failedStream, err),
      );
    } catch (err) {
      emit(state.failureState(LikesStateStatus.failedStream, err));
    }
  }

  Future<void> fetchLikes({
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isNotEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isLessThan = const <String, dynamic>{},
    Map<String, dynamic> isLessOrEqualTo = const <String, dynamic>{},
    Map<String, dynamic> isGreaterThan = const <String, dynamic>{},
    Map<String, dynamic> isGreaterOrEqualTo = const <String, dynamic>{},
    Map<String, List<dynamic>>? filters,
    int? limit = 11,
    Map<String, bool> orderBy = const <String, bool>{},
    bool includeUserId = true,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(LikesStateStatus.fetching));
      if (filters != null) emit(state.copyWith(filters: filters));
      await _likesSub?.cancel();
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

      final resp = await _repository.fetchLikes(GetListRequest.init(
        isEqualToQueries: isEqualToQueries,
        isNotEqualToQueries: isNotEqualTo,
        isLessThanQueries: isLessThan,
        isLessOrEqualToQueries: isLessOrEqualTo,
        isGreaterThanQueries: isGreaterThan,
        isGreaterOrEqualToQueries: isGreaterOrEqualTo,
        lastQueriedId: state.lastQueriedId,
        orQueries: state.filters,
        isTotalCounted: state.totalLikes != null,
        limit: limit,
        orderBy: orderBy,
      ));

      emit(state.successState(
        LikesStateStatus.fetched,
        likes: resp.entities,
        lastQueriedId: resp.entities.isEmpty ? null : resp.entities.last.id,
        totalLikes: resp.totalCount,
      ));
    } catch (err) {
      emit(state.failureState(LikesStateStatus.failedFetch, err));
    }
  }

  Future<void> fetchMoreLikes({
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
    bool includeUserId = true,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(LikesStateStatus.fetchingMore));
      if (filters != null) emit(state.copyWith(filters: filters));
      if (state.isAllDataReceived) {
        emit(state.successState(LikesStateStatus.fetchedMore));
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

      final resp = await _repository.fetchLikes(GetListRequest.init(
        isEqualToQueries: isEqualToQueries,
        isNotEqualToQueries: isNotEqualTo,
        isLessThanQueries: isLessThan,
        isLessOrEqualToQueries: isLessOrEqualTo,
        isGreaterThanQueries: isGreaterThan,
        isGreaterOrEqualToQueries: isGreaterOrEqualTo,
        lastQueriedId: state.lastQueriedId,
        searchTag: (searchTag ?? '').trim().isEmpty ? null : searchTag?.trim(),
        orQueries: state.filters,
        isTotalCounted: state.totalLikes != null,
        limit: limit,
        orderBy: orderBy,
      ));

      String? lastLikeId;
      if (resp.entities.isNotEmpty) {
        lastLikeId = resp.entities.last.id;
      }

      var newlikes = List<Like>.from(state.likes);
      for (var entity in resp.entities) {
        final foundIndex = newlikes.indexWhere((e) => e.id == entity.id);
        if (foundIndex >= 0) {
          newlikes.removeAt(foundIndex);
          newlikes.insert(foundIndex, entity);
        } else {
          newlikes.add(entity);
        }
      }

      emit(state.successState(
        LikesStateStatus.fetchedMore,
        likes: newlikes,
        lastQueriedId: lastLikeId,
        totalLikes: resp.totalCount,
      ));
    } catch (err) {
      emit(state.failureState(LikesStateStatus.failedFetch, err));
    }
  }

  Future<void> searchLikes(
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
    bool includeUserId = true,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(LikesStateStatus.searching));
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

      final result = await _repository.fetchLikes(request);
      if (searchTag.trim().isEmpty) {
        emit(state.successState(LikesStateStatus.streamed));
        return;
      }

      emit(state.successState(
        LikesStateStatus.searched,
        searchResult: result.entities,
      ));
    } catch (e) {
      emit(state.failureState(LikesStateStatus.failedSearch, e));
    }
  }

  void deleteLike(String? id) async {
    if (id == null) return;
    try {
      emit(state.loadingState(LikesStateStatus.deleting));
      _likesSub?.pause();

      await _repository.deleteLike(id);
      emit(state.successState(LikesStateStatus.deleted));

      _likesSub?.resume();
    } catch (err) {
      emit(state.failureState(LikesStateStatus.failedDelete, err));
    }
  }

  void deleteSelected() async {
    try {
      emit(state.loadingState(LikesStateStatus.deleting));
      _likesSub?.pause();

      var likeIds = state.selected.map((e) => e.id ?? '').toList();
      likeIds.removeWhere((e) => e.isEmpty);
      await _repository.deleteLikes(likeIds);
      emit(state.successState(LikesStateStatus.deleted));

      _likesSub?.resume();
    } catch (err) {
      emit(state.failureState(LikesStateStatus.failedDelete, err));
    }
  }

  void deleteAll() async {
    try {
      emit(state.loadingState(LikesStateStatus.deleting));
      _likesSub?.pause();

      var likeIds = state.likes.map((e) => e.id ?? '').toList();
      likeIds.removeWhere((e) => e.isEmpty);

      await _repository.deleteLikes(likeIds);

      emit(state.successState(LikesStateStatus.deleted));
      _likesSub?.resume();
    } catch (err) {
      emit(state.failureState(LikesStateStatus.failedDelete, err));
    }
  }

  void backUpSelected() async {
    try {
      emit(state.loadingState(LikesStateStatus.backingUp));
      await _repository.backUpLikes(state.selected);
      emit(state.successState(LikesStateStatus.backedUp));
    } catch (err) {
      emit(state.failureState(LikesStateStatus.failedBackup, err));
    }
  }

  void backUpAll({
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    bool includeUserId = true,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(LikesStateStatus.backingUp));
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

      await _repository.backUpAllLikes(isEqualToQueries);
      emit(state.successState(LikesStateStatus.backedUp));
    } catch (err) {
      emit(state.failureState(LikesStateStatus.failedBackup, err));
    }
  }

  void restoreLikes(
    RestoreMode mode, {
    Map<String, dynamic> replacements = const <String, dynamic>{},
    bool includeUserId = true,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(LikesStateStatus.restoring));
      _likesSub?.pause();

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

      await _repository.restoreLikes(allReplacements, mode);

      emit(state.successState(LikesStateStatus.restored));
      _likesSub?.resume();
    } catch (err) {
      emit(state.failureState(LikesStateStatus.failedRestore, err));
    }
  }

  Future<void> createLikes([List<Like> likes = const []]) async {
    try {
      emit(state.loadingState(LikesStateStatus.creating));
      _likesSub?.pause();
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      var newList = likes.map((e) {
        return e.copyWith(
          businessId: businessId,
          userId: userId,
          creationDate: DateTime.now(),
          creatorId: userId,
        );
      }).toList();

      if (newList.isEmpty) {
        newList = state.likes.map((e) {
          return e.copyWith(
            businessId: businessId,
            userId: userId,
            creationDate: DateTime.now(),
            creatorId: userId,
          );
        }).toList();
      }

      await _repository.createLikes(newList);
      emit(state.successState(LikesStateStatus.created));

      _likesSub?.resume();
    } catch (e) {
      emit(state.failureState(LikesStateStatus.failedCreate, e));
    }
  }

  Future<void> updateLikes([List<Like> likes = const []]) async {
    try {
      emit(state.loadingState(LikesStateStatus.updating));
      _likesSub?.pause();
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      var newList = likes.map((e) {
        return e.copyWith(
          businessId: businessId,
          // userId: userId,
          lastModifiedDate: DateTime.now(),
          lastModifierId: userId,
        );
      }).toList();

      if (newList.isEmpty) {
        newList = state.likes.map((e) {
          return e.copyWith(
            businessId: businessId,
            // userId: userId,
            lastModifiedDate: DateTime.now(),
            lastModifierId: userId,
          );
        }).toList();
      }

      await _repository.updateLikes(newList);
      emit(state.successState(LikesStateStatus.updated));

      _likesSub?.resume();
    } catch (e) {
      emit(state.failureState(LikesStateStatus.failedUpdate, e));
    }
  }

  @override
  Future<void> close() async {
    await _likesSub?.cancel();
    return super.close();
  }
}
