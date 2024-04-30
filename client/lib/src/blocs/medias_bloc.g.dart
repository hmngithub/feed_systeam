import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dtos/get_list_request.g.dart';
import 'dtos/get_list_response.g.dart';
import 'dtos/restore_mode.g.dart';

import '../domain/entities/media.g.dart';
import 'gateways/converse_repository.g.dart';
import 'states/medias_state.g.dart';

class MediasBloc extends Cubit<MediasState> {
  final ConverseRepository _repository;
  MediasBloc(ConverseRepository converseRepository)
      : _repository = converseRepository,
        super(const MediasState.init());

  void toInitState() {
    emit(const MediasState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(MediasStateStatus status, dynamic error) {
    emit(state.failureState(status, error));
  }

  void replaceMedia(int index, Media media) {
    var newMedias = List<Media>.from(state.medias);
    newMedias[index] = media;
    emit(state.copyWith(medias: newMedias));
  }

  void selectMedia(Media media) {
    var selected = List<Media>.from(state.selected);
    if (selected.any((e) => e.id == media.id)) {
      selected.removeWhere((e) => e.id == media.id);
      emit(state.copyWith(selected: selected));
      return;
    }
    selected.add(media);
    emit(state.copyWith(selected: selected));
  }

  void setSelected(List<Media> selected) {
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
    emit(state.copyWith(selected: List<Media>.from(state.medias)));
  }

  void sortBy(String key) {
    emit(state.copyWith(isSortedAscending: !state.isSortedAscending));
    var map = state.medias.map((e) => e.toMap(false)).toList();
    map.sort((a, b) {
      final aKey = (a[key] as String?) ?? '';
      final bKey = (b[key] as String?) ?? '';
      if (state.isSortedAscending) return aKey.compareTo(bKey);
      return bKey.compareTo(aKey);
    });
    var sortedmedias = map.map((e) => Media.fromMap(e, null, false)).toList();
    emit(state.copyWith(medias: sortedmedias));
  }

  StreamSubscription<GetListResponse<Media>>? _mediasSub;
  Future<void> streamMedias({
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
      emit(state.loadingState(MediasStateStatus.streaming));
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
        isTotalCounted: state.totalMedias != null,
        limit: limit,
        orderBy: orderBy,
      );

      await _mediasSub?.cancel();
      _mediasSub = _repository.streamMedias(request).listen(
        (resp) {
          emit(state.successState(
            MediasStateStatus.streamed,
            medias: resp.entities,
            lastQueriedId: resp.entities.isEmpty ? null : resp.entities.last.id,
            totalMedias: resp.totalCount,
          ));
        },
        onError: (err) =>
            state.failureState(MediasStateStatus.failedStream, err),
      );
    } catch (err) {
      emit(state.failureState(MediasStateStatus.failedStream, err));
    }
  }

  Future<void> fetchMedias({
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
      emit(state.loadingState(MediasStateStatus.fetching));
      if (filters != null) emit(state.copyWith(filters: filters));
      await _mediasSub?.cancel();
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

      final resp = await _repository.fetchMedias(GetListRequest.init(
        isEqualToQueries: isEqualToQueries,
        isNotEqualToQueries: isNotEqualTo,
        isLessThanQueries: isLessThan,
        isLessOrEqualToQueries: isLessOrEqualTo,
        isGreaterThanQueries: isGreaterThan,
        isGreaterOrEqualToQueries: isGreaterOrEqualTo,
        lastQueriedId: state.lastQueriedId,
        orQueries: state.filters,
        isTotalCounted: state.totalMedias != null,
        limit: limit,
        orderBy: orderBy,
      ));

      emit(state.successState(
        MediasStateStatus.fetched,
        medias: resp.entities,
        lastQueriedId: resp.entities.isEmpty ? null : resp.entities.last.id,
        totalMedias: resp.totalCount,
      ));
    } catch (err) {
      emit(state.failureState(MediasStateStatus.failedFetch, err));
    }
  }

  Future<void> fetchMoreMedias({
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
      emit(state.loadingState(MediasStateStatus.fetchingMore));
      if (filters != null) emit(state.copyWith(filters: filters));
      if (state.isAllDataReceived) {
        emit(state.successState(MediasStateStatus.fetchedMore));
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

      final resp = await _repository.fetchMedias(GetListRequest.init(
        isEqualToQueries: isEqualToQueries,
        isNotEqualToQueries: isNotEqualTo,
        isLessThanQueries: isLessThan,
        isLessOrEqualToQueries: isLessOrEqualTo,
        isGreaterThanQueries: isGreaterThan,
        isGreaterOrEqualToQueries: isGreaterOrEqualTo,
        lastQueriedId: state.lastQueriedId,
        searchTag: (searchTag ?? '').trim().isEmpty ? null : searchTag?.trim(),
        orQueries: state.filters,
        isTotalCounted: state.totalMedias != null,
        limit: limit,
        orderBy: orderBy,
      ));

      String? lastMediaId;
      if (resp.entities.isNotEmpty) {
        lastMediaId = resp.entities.last.id;
      }

      var newmedias = List<Media>.from(state.medias);
      for (var entity in resp.entities) {
        final foundIndex = newmedias.indexWhere((e) => e.id == entity.id);
        if (foundIndex >= 0) {
          newmedias.removeAt(foundIndex);
          newmedias.insert(foundIndex, entity);
        } else {
          newmedias.add(entity);
        }
      }

      emit(state.successState(
        MediasStateStatus.fetchedMore,
        medias: newmedias,
        lastQueriedId: lastMediaId,
        totalMedias: resp.totalCount,
      ));
    } catch (err) {
      emit(state.failureState(MediasStateStatus.failedFetch, err));
    }
  }

  Future<void> searchMedias(
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
      emit(state.loadingState(MediasStateStatus.searching));
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

      final result = await _repository.fetchMedias(request);
      if (searchTag.trim().isEmpty) {
        emit(state.successState(MediasStateStatus.streamed));
        return;
      }

      emit(state.successState(
        MediasStateStatus.searched,
        searchResult: result.entities,
      ));
    } catch (e) {
      emit(state.failureState(MediasStateStatus.failedSearch, e));
    }
  }

  void deleteMedia(String? id) async {
    if (id == null) return;
    try {
      emit(state.loadingState(MediasStateStatus.deleting));
      _mediasSub?.pause();

      await _repository.deleteMedia(id);
      emit(state.successState(MediasStateStatus.deleted));

      _mediasSub?.resume();
    } catch (err) {
      emit(state.failureState(MediasStateStatus.failedDelete, err));
    }
  }

  void deleteSelected() async {
    try {
      emit(state.loadingState(MediasStateStatus.deleting));
      _mediasSub?.pause();

      var mediaIds = state.selected.map((e) => e.id ?? '').toList();
      mediaIds.removeWhere((e) => e.isEmpty);
      await _repository.deleteMedias(mediaIds);
      emit(state.successState(MediasStateStatus.deleted));

      _mediasSub?.resume();
    } catch (err) {
      emit(state.failureState(MediasStateStatus.failedDelete, err));
    }
  }

  void deleteAll() async {
    try {
      emit(state.loadingState(MediasStateStatus.deleting));
      _mediasSub?.pause();

      var mediaIds = state.medias.map((e) => e.id ?? '').toList();
      mediaIds.removeWhere((e) => e.isEmpty);

      await _repository.deleteMedias(mediaIds);

      emit(state.successState(MediasStateStatus.deleted));
      _mediasSub?.resume();
    } catch (err) {
      emit(state.failureState(MediasStateStatus.failedDelete, err));
    }
  }

  void backUpSelected() async {
    try {
      emit(state.loadingState(MediasStateStatus.backingUp));
      await _repository.backUpMedias(state.selected);
      emit(state.successState(MediasStateStatus.backedUp));
    } catch (err) {
      emit(state.failureState(MediasStateStatus.failedBackup, err));
    }
  }

  void backUpAll({
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    bool includeUserId = false,
    bool includeBusinessId = false,
  }) async {
    try {
      emit(state.loadingState(MediasStateStatus.backingUp));
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

      await _repository.backUpAllMedias(isEqualToQueries);
      emit(state.successState(MediasStateStatus.backedUp));
    } catch (err) {
      emit(state.failureState(MediasStateStatus.failedBackup, err));
    }
  }

  void restoreMedias(
    RestoreMode mode, {
    Map<String, dynamic> replacements = const <String, dynamic>{},
    bool includeUserId = false,
    bool includeBusinessId = false,
  }) async {
    try {
      emit(state.loadingState(MediasStateStatus.restoring));
      _mediasSub?.pause();

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

      await _repository.restoreMedias(allReplacements, mode);

      emit(state.successState(MediasStateStatus.restored));
      _mediasSub?.resume();
    } catch (err) {
      emit(state.failureState(MediasStateStatus.failedRestore, err));
    }
  }

  Future<void> createMedias([List<Media> medias = const []]) async {
    try {
      emit(state.loadingState(MediasStateStatus.creating));
      _mediasSub?.pause();
      final user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      var newList = medias.map((e) {
        return e.copyWith(
          creationDate: DateTime.now(),
          creatorId: userId,
        );
      }).toList();

      if (newList.isEmpty) {
        newList = state.medias.map((e) {
          return e.copyWith(
            creationDate: DateTime.now(),
            creatorId: userId,
          );
        }).toList();
      }

      await _repository.createMedias(newList);
      emit(state.successState(MediasStateStatus.created));

      _mediasSub?.resume();
    } catch (e) {
      emit(state.failureState(MediasStateStatus.failedCreate, e));
    }
  }

  Future<void> updateMedias([List<Media> medias = const []]) async {
    try {
      emit(state.loadingState(MediasStateStatus.updating));
      _mediasSub?.pause();
      final user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      var newList = medias.map((e) {
        return e.copyWith(
          creationDate: DateTime.now(),
          creatorId: userId,
        );
      }).toList();

      if (newList.isEmpty) {
        newList = state.medias.map((e) {
          return e.copyWith(
            creationDate: DateTime.now(),
            creatorId: userId,
          );
        }).toList();
      }

      await _repository.updateMedias(newList);
      emit(state.successState(MediasStateStatus.updated));

      _mediasSub?.resume();
    } catch (e) {
      emit(state.failureState(MediasStateStatus.failedUpdate, e));
    }
  }

  @override
  Future<void> close() async {
    await _mediasSub?.cancel();
    return super.close();
  }
}
