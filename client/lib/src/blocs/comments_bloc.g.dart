import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dtos/get_list_request.g.dart';
import 'dtos/get_list_response.g.dart';
import 'dtos/restore_mode.g.dart';

import '../domain/entities/comment.g.dart';
import 'gateways/converse_repository.g.dart';
import 'states/comments_state.g.dart';

class CommentsBloc extends Cubit<CommentsState> {
  final ConverseRepository _repository;
  CommentsBloc(ConverseRepository converseRepository)
      : _repository = converseRepository,
        super(const CommentsState.init());

  void toInitState() {
    emit(const CommentsState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(CommentsStateStatus status, dynamic error) {
    emit(state.failureState(status, error));
  }

  void replaceComment(int index, Comment comment) {
    var newComments = List<Comment>.from(state.comments);
    newComments[index] = comment;
    emit(state.copyWith(comments: newComments));
  }

  void selectComment(Comment comment) {
    var selected = List<Comment>.from(state.selected);
    if (selected.any((e) => e.id == comment.id)) {
      selected.removeWhere((e) => e.id == comment.id);
      emit(state.copyWith(selected: selected));
      return;
    }
    selected.add(comment);
    emit(state.copyWith(selected: selected));
  }

  void setSelected(List<Comment> selected) {
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
    emit(state.copyWith(selected: List<Comment>.from(state.comments)));
  }

  void sortBy(String key) {
    emit(state.copyWith(isSortedAscending: !state.isSortedAscending));
    var map = state.comments.map((e) => e.toMap(false)).toList();
    map.sort((a, b) {
      final aKey = (a[key] as String?) ?? '';
      final bKey = (b[key] as String?) ?? '';
      if (state.isSortedAscending) return aKey.compareTo(bKey);
      return bKey.compareTo(aKey);
    });
    var sortedcomments =
        map.map((e) => Comment.fromMap(e, null, false)).toList();
    emit(state.copyWith(comments: sortedcomments));
  }

  StreamSubscription<GetListResponse<Comment>>? _commentsSub;
  Future<void> streamComments({
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
      emit(state.loadingState(CommentsStateStatus.streaming));
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
        isTotalCounted: state.totalComments != null,
        limit: limit,
        orderBy: orderBy,
      );

      await _commentsSub?.cancel();
      _commentsSub = _repository.streamComments(request).listen(
        (resp) {
          emit(state.successState(
            CommentsStateStatus.streamed,
            comments: resp.entities,
            lastQueriedId: resp.entities.isEmpty ? null : resp.entities.last.id,
            totalComments: resp.totalCount,
          ));
        },
        onError: (err) =>
            state.failureState(CommentsStateStatus.failedStream, err),
      );
    } catch (err) {
      emit(state.failureState(CommentsStateStatus.failedStream, err));
    }
  }

  Future<void> fetchComments({
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
      emit(state.loadingState(CommentsStateStatus.fetching));
      if (filters != null) emit(state.copyWith(filters: filters));
      await _commentsSub?.cancel();
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

      final resp = await _repository.fetchComments(GetListRequest.init(
        isEqualToQueries: isEqualToQueries,
        isNotEqualToQueries: isNotEqualTo,
        isLessThanQueries: isLessThan,
        isLessOrEqualToQueries: isLessOrEqualTo,
        isGreaterThanQueries: isGreaterThan,
        isGreaterOrEqualToQueries: isGreaterOrEqualTo,
        lastQueriedId: state.lastQueriedId,
        orQueries: state.filters,
        isTotalCounted: state.totalComments != null,
        limit: limit,
        orderBy: orderBy,
      ));

      emit(state.successState(
        CommentsStateStatus.fetched,
        comments: resp.entities,
        lastQueriedId: resp.entities.isEmpty ? null : resp.entities.last.id,
        totalComments: resp.totalCount,
      ));
    } catch (err) {
      emit(state.failureState(CommentsStateStatus.failedFetch, err));
    }
  }

  Future<void> fetchMoreComments({
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
      emit(state.loadingState(CommentsStateStatus.fetchingMore));
      if (filters != null) emit(state.copyWith(filters: filters));
      if (state.isAllDataReceived) {
        emit(state.successState(CommentsStateStatus.fetchedMore));
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

      final resp = await _repository.fetchComments(GetListRequest.init(
        isEqualToQueries: isEqualToQueries,
        isNotEqualToQueries: isNotEqualTo,
        isLessThanQueries: isLessThan,
        isLessOrEqualToQueries: isLessOrEqualTo,
        isGreaterThanQueries: isGreaterThan,
        isGreaterOrEqualToQueries: isGreaterOrEqualTo,
        lastQueriedId: state.lastQueriedId,
        searchTag: (searchTag ?? '').trim().isEmpty ? null : searchTag?.trim(),
        orQueries: state.filters,
        isTotalCounted: state.totalComments != null,
        limit: limit,
        orderBy: orderBy,
      ));

      String? lastCommentId;
      if (resp.entities.isNotEmpty) {
        lastCommentId = resp.entities.last.id;
      }

      var newcomments = List<Comment>.from(state.comments);
      for (var entity in resp.entities) {
        final foundIndex = newcomments.indexWhere((e) => e.id == entity.id);
        if (foundIndex >= 0) {
          newcomments.removeAt(foundIndex);
          newcomments.insert(foundIndex, entity);
        } else {
          newcomments.add(entity);
        }
      }

      emit(state.successState(
        CommentsStateStatus.fetchedMore,
        comments: newcomments,
        lastQueriedId: lastCommentId,
        totalComments: resp.totalCount,
      ));
    } catch (err) {
      emit(state.failureState(CommentsStateStatus.failedFetch, err));
    }
  }

  Future<void> searchComments(
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
      emit(state.loadingState(CommentsStateStatus.searching));
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

      final result = await _repository.fetchComments(request);
      if (searchTag.trim().isEmpty) {
        emit(state.successState(CommentsStateStatus.streamed));
        return;
      }

      emit(state.successState(
        CommentsStateStatus.searched,
        searchResult: result.entities,
      ));
    } catch (e) {
      emit(state.failureState(CommentsStateStatus.failedSearch, e));
    }
  }

  void deleteComment(String? id) async {
    if (id == null) return;
    try {
      emit(state.loadingState(CommentsStateStatus.deleting));
      _commentsSub?.pause();

      await _repository.deleteComment(id);
      emit(state.successState(CommentsStateStatus.deleted));

      _commentsSub?.resume();
    } catch (err) {
      emit(state.failureState(CommentsStateStatus.failedDelete, err));
    }
  }

  void deleteSelected() async {
    try {
      emit(state.loadingState(CommentsStateStatus.deleting));
      _commentsSub?.pause();

      var commentIds = state.selected.map((e) => e.id ?? '').toList();
      commentIds.removeWhere((e) => e.isEmpty);
      await _repository.deleteComments(commentIds);
      emit(state.successState(CommentsStateStatus.deleted));

      _commentsSub?.resume();
    } catch (err) {
      emit(state.failureState(CommentsStateStatus.failedDelete, err));
    }
  }

  void deleteAll() async {
    try {
      emit(state.loadingState(CommentsStateStatus.deleting));
      _commentsSub?.pause();

      var commentIds = state.comments.map((e) => e.id ?? '').toList();
      commentIds.removeWhere((e) => e.isEmpty);

      await _repository.deleteComments(commentIds);

      emit(state.successState(CommentsStateStatus.deleted));
      _commentsSub?.resume();
    } catch (err) {
      emit(state.failureState(CommentsStateStatus.failedDelete, err));
    }
  }

  void backUpSelected() async {
    try {
      emit(state.loadingState(CommentsStateStatus.backingUp));
      await _repository.backUpComments(state.selected);
      emit(state.successState(CommentsStateStatus.backedUp));
    } catch (err) {
      emit(state.failureState(CommentsStateStatus.failedBackup, err));
    }
  }

  void backUpAll({
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    bool includeUserId = false,
    bool includeBusinessId = false,
  }) async {
    try {
      emit(state.loadingState(CommentsStateStatus.backingUp));
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

      await _repository.backUpAllComments(isEqualToQueries);
      emit(state.successState(CommentsStateStatus.backedUp));
    } catch (err) {
      emit(state.failureState(CommentsStateStatus.failedBackup, err));
    }
  }

  void restoreComments(
    RestoreMode mode, {
    Map<String, dynamic> replacements = const <String, dynamic>{},
    bool includeUserId = false,
    bool includeBusinessId = false,
  }) async {
    try {
      emit(state.loadingState(CommentsStateStatus.restoring));
      _commentsSub?.pause();

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

      await _repository.restoreComments(allReplacements, mode);

      emit(state.successState(CommentsStateStatus.restored));
      _commentsSub?.resume();
    } catch (err) {
      emit(state.failureState(CommentsStateStatus.failedRestore, err));
    }
  }

  Future<void> createComments([List<Comment> comments = const []]) async {
    try {
      emit(state.loadingState(CommentsStateStatus.creating));
      _commentsSub?.pause();
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      var newList = comments.map((e) {
        return e.copyWith(
          businessId: businessId,
          userId: userId,
          creationDate: DateTime.now(),
          creatorId: userId,
        );
      }).toList();

      if (newList.isEmpty) {
        newList = state.comments.map((e) {
          return e.copyWith(
            businessId: businessId,
            userId: userId,
            creationDate: DateTime.now(),
            creatorId: userId,
          );
        }).toList();
      }

      await _repository.createComments(newList);
      emit(state.successState(CommentsStateStatus.created));

      _commentsSub?.resume();
    } catch (e) {
      emit(state.failureState(CommentsStateStatus.failedCreate, e));
    }
  }

  Future<void> updateComments([List<Comment> comments = const []]) async {
    try {
      emit(state.loadingState(CommentsStateStatus.updating));
      _commentsSub?.pause();
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      var newList = comments.map((e) {
        return e.copyWith(
          businessId: businessId,
          // userId: userId,
          lastModifiedDate: DateTime.now(),
          lastModifierId: userId,
        );
      }).toList();

      if (newList.isEmpty) {
        newList = state.comments.map((e) {
          return e.copyWith(
            businessId: businessId,
            // userId: userId,
            lastModifiedDate: DateTime.now(),
            lastModifierId: userId,
          );
        }).toList();
      }

      await _repository.updateComments(newList);
      emit(state.successState(CommentsStateStatus.updated));

      _commentsSub?.resume();
    } catch (e) {
      emit(state.failureState(CommentsStateStatus.failedUpdate, e));
    }
  }

  @override
  Future<void> close() async {
    await _commentsSub?.cancel();
    return super.close();
  }
}
