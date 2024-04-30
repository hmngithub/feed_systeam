import 'dart:async';

import '../domain/entities/comment.g.dart';
import 'gateways/converse_repository.g.dart';
import 'states/comment_state.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentBloc extends Cubit<CommentState> {
  final ConverseRepository _repository;
  CommentBloc(ConverseRepository converseRepository)
      : _repository = converseRepository,
        super(const CommentState.init());

  void setComment(Comment? comment) {
    if (comment == null) return;
    emit(state.copyWith(comment: comment));
  }

  void setCommentId(String? id, [bool cache = false]) async {
    if (id == null) return;
    final comment = state.comment.copyWith(id: id);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentContent(String? content, [bool cache = false]) async {
    if (content == null) return;
    final comment = state.comment.copyWith(content: content);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentIsReply(bool? isReply, [bool cache = false]) async {
    if (isReply == null) return;
    final comment = state.comment.copyWith(isReply: isReply);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentBusinessId(String? businessId, [bool cache = false]) async {
    if (businessId == null) return;
    final comment = state.comment.copyWith(businessId: businessId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentBranchId(String? branchId, [bool cache = false]) async {
    if (branchId == null) return;
    final comment = state.comment.copyWith(branchId: branchId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentFacultyId(String? facultyId, [bool cache = false]) async {
    if (facultyId == null) return;
    final comment = state.comment.copyWith(facultyId: facultyId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentDepartmentId(String? departmentId,
      [bool cache = false]) async {
    if (departmentId == null) return;
    final comment = state.comment.copyWith(departmentId: departmentId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentDivsionId(String? divsionId, [bool cache = false]) async {
    if (divsionId == null) return;
    final comment = state.comment.copyWith(divsionId: divsionId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentTeamId(String? teamId, [bool cache = false]) async {
    if (teamId == null) return;
    final comment = state.comment.copyWith(teamId: teamId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentDegreeId(String? degreeId, [bool cache = false]) async {
    if (degreeId == null) return;
    final comment = state.comment.copyWith(degreeId: degreeId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentSpecializationId(String? specializationId,
      [bool cache = false]) async {
    if (specializationId == null) return;
    final comment = state.comment.copyWith(specializationId: specializationId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentLevelId(String? levelId, [bool cache = false]) async {
    if (levelId == null) return;
    final comment = state.comment.copyWith(levelId: levelId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentCourseId(String? courseId, [bool cache = false]) async {
    if (courseId == null) return;
    final comment = state.comment.copyWith(courseId: courseId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentUnitId(String? unitId, [bool cache = false]) async {
    if (unitId == null) return;
    final comment = state.comment.copyWith(unitId: unitId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentUnitContentId(String? unitContentId,
      [bool cache = false]) async {
    if (unitContentId == null) return;
    final comment = state.comment.copyWith(unitContentId: unitContentId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentFeedId(String? feedId, [bool cache = false]) async {
    if (feedId == null) return;
    final comment = state.comment.copyWith(feedId: feedId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentTaskId(String? taskId, [bool cache = false]) async {
    if (taskId == null) return;
    final comment = state.comment.copyWith(taskId: taskId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentParentId(String? parentId, [bool cache = false]) async {
    if (parentId == null) return;
    final comment = state.comment.copyWith(parentId: parentId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentStakeholderId(String? stakeholderId,
      [bool cache = false]) async {
    if (stakeholderId == null) return;
    final comment = state.comment.copyWith(stakeholderId: stakeholderId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentEnrollmentId(String? enrollmentId,
      [bool cache = false]) async {
    if (enrollmentId == null) return;
    final comment = state.comment.copyWith(enrollmentId: enrollmentId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentUserId(String? userId, [bool cache = false]) async {
    if (userId == null) return;
    final comment = state.comment.copyWith(userId: userId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentUserImageUrl(String? userImageUrl,
      [bool cache = false]) async {
    if (userImageUrl == null) return;
    final comment = state.comment.copyWith(userImageUrl: userImageUrl);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentUserFullName(String? userFullName,
      [bool cache = false]) async {
    if (userFullName == null) return;
    final comment = state.comment.copyWith(userFullName: userFullName);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentCreationDate(DateTime? creationDate,
      [bool cache = false]) async {
    if (creationDate == null) return;
    final comment = state.comment.copyWith(creationDate: creationDate);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentCreatorId(String? creatorId, [bool cache = false]) async {
    if (creatorId == null) return;
    final comment = state.comment.copyWith(creatorId: creatorId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentLastModifiedDate(DateTime? lastModifiedDate,
      [bool cache = false]) async {
    if (lastModifiedDate == null) return;
    final comment = state.comment.copyWith(lastModifiedDate: lastModifiedDate);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void setCommentLastModifierId(String? lastModifierId,
      [bool cache = false]) async {
    if (lastModifierId == null) return;
    final comment = state.comment.copyWith(lastModifierId: lastModifierId);
    emit(state.copyWith(comment: comment));
    if (cache) return await updateComment();
  }

  void toInitState() {
    emit(const CommentState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(CommentStateStatus status, dynamic error) {
    emit(state.failureState(status, error: error));
  }

  /// Generates a random ID using uuid
  String generateId() {
    return _repository.generateRandomId();
  }

  /// Persists the `Comment` with the provided properties from the current BLoC.
  /// If the `Comment` already exists, its modified properties are persisted.
  /// If the `Comment` does not exist, a new `Comment` with an automatically
  /// generated ID is created and presisted.
  void saveComment([String? commentId]) async {
    if (state.comment.id != null) {
      await updateComment();
      return;
    }
    createComment(commentId);
  }

  /// Persists the `Comment` with the provided properties from the current BLoC,
  /// which has a **One-To-One** relationship with the current `ConverseUser`.
  /// The persisted `Comment` ID is equivalent to the current `ConverseUser` ID.
  /// If the `Comment` already exists, its modified properties are persisted.
  /// If the `Comment` does not exist, a new `Comment` with the current
  /// `ConverseUser` ID will be created and presisted.
  void saveUserComment() async {
    if (state.comment.id != null) {
      await updateComment();
      return;
    }
    createUserComment();
  }

  /// Persists the `Comment` with the provided properties from the current BLoC,
  /// which has a **One-To-Many** relationship with the current `ConverseUser`.
  /// The persisted `Comment` ID is assigned to the current `ConverseUser` as `comment`Id.
  /// If the `Comment` already exists, its modified properties are persisted.
  /// If the `Comment` does not exist, a new `Comment` with an automatically
  /// generated ID is created and presisted.
  void saveCommentOfUser() async {
    final commentId = state.comment.id;
    if (commentId == null || commentId.isEmpty) {
      return createCommentOfUser();
    }
    await updateComment();
  }

  void saveCommentForUser() async {
    final commentId = state.comment.id;
    if (commentId == null || commentId.isEmpty) {
      return createCommentForUser();
    }
    await updateComment();
  }

  /// Persists the `Comment` with the provided properties from the current BLoC,
  /// and an automatically generated ID.
  void createComment([String? commentId]) async {
    try {
      emit(state.loadingState(CommentStateStatus.creating));
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      if ((commentId ?? '').trim().isNotEmpty) {
        final newComment = state.comment.copyWith(
          id: commentId?.trim(),
          businessId: businessId,
          creationDate: DateTime.now(),
          creatorId: userId,
        );

        await _repository.createCommentWithId(
          commentId!.trim(),
          newComment,
        );

        emit(state.successState(
          CommentStateStatus.created,
          comment: newComment,
        ));

        return;
      }

      final newComment = state.comment.copyWith(
        businessId: businessId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      final newId = await _repository.createComment(newComment);
      emit(state.successState(
        CommentStateStatus.created,
        comment: newComment.copyWith(id: newId),
      ));
    } catch (err) {
      emit(state.failureState(CommentStateStatus.failedCreate, error: err));
    }
  }

  /// Persists the `Comment` with the provided properties from the current BLoC,
  /// and an automatically generated ID, which has a **One-To-One** relationship with
  /// the current `ConverseUser`.
  /// The persisted `Comment` ID is equivalent to the current `ConverseUser` ID.
  void createUserComment() async {
    try {
      emit(state.loadingState(CommentStateStatus.creating));
      final user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final newComment = state.comment.copyWith(
        id: userId,
        businessId: businessId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      await _repository.createCommentWithId(userId!, newComment);
      emit(state.successState(
        CommentStateStatus.created,
        comment: newComment,
      ));
    } catch (err) {
      emit(state.failureState(CommentStateStatus.failedCreate, error: err));
    }
  }

  /// Persists the `Comment` with the provided properties from the current BLoC,
  /// and an automatically generated ID, which has a **One-To-Many** relationship with
  /// the current `ConverseUser`.
  void createCommentOfUser() async {
    try {
      emit(state.loadingState(CommentStateStatus.creating));
      var user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      // if ((user.commentId ?? '').trim().isEmpty) {
      // final newComment = state.comment.copyWith(
      //    businessId: businessId,
      //    creationDate: DateTime.now(),
      //    creatorId: userId,
      // );

      // final newId = await _repository.createComment(newComment);

      // final newUser = user.copyWith(
      //   commentId: newId,
      //   lastModifiedDate: DateTime.now(),
      //   lastModifierId: userId,
      // );

      // await _repository.updateUserInfo(newUser);
      // emit(state.successState(
      //  CommentStateStatus.created,
      //  comment: newComment.copyWith(id: newId),
      // ));
      // return;
      // }
      emit(state.successState(CommentStateStatus.created));
    } catch (err) {
      emit(state.failureState(CommentStateStatus.failedCreate, error: err));
    }
  }

// Create a Comment which has the user ID as its attribute
// One User can have multiple {entityCamelPlural}
  void createCommentForUser() async {
    try {
      emit(state.loadingState(CommentStateStatus.creating));
      var user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final newComment = state.comment.copyWith(
        userId: userId,
        businessId: businessId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      final newId = await _repository.createComment(newComment);
      emit(state.successState(
        CommentStateStatus.created,
        comment: newComment.copyWith(id: newId),
      ));
      return;
    } catch (err) {
      emit(state.failureState(CommentStateStatus.failedCreate, error: err));
    }
  }

  /// All business subscriptions are done through
  /// this subscriber.
  StreamSubscription<Comment>? _commentSub;

  /// Streams the presisted `Comment` to the current BLoC.
  /// Nothing will be emitted if `id` is null or empty.
  void streamComment(String? id) async {
    if (id == null) return;
    try {
      emit(state.loadingState(CommentStateStatus.streaming));
      await _commentSub?.cancel();
      _commentSub = _repository.streamComment(id).listen((comment) {
        emit(state.successState(CommentStateStatus.streamed, comment: comment));
      },
          onError: (err) => emit(
              state.failureState(CommentStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(CommentStateStatus.failedStream, error: err));
    }
  }

  /// Streams the presisted `Comment`, which has a **One-To-One** relationship
  /// with the current `ConverseUser`, back to the current BLoC.
  /// Nothing will be emitted if the `ConverseUser` is not signed in.
  /// The `Comment` is streamed based on the current `ConverseUser` ID.
  void streamUserComment() async {
    try {
      emit(state.loadingState(CommentStateStatus.streaming));
      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      await _commentSub?.cancel();
      _commentSub = _repository.streamComment(user.id!).listen((comment) {
        emit(state.successState(CommentStateStatus.streamed, comment: comment));
      },
          onError: (err) => emit(
              state.failureState(CommentStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(CommentStateStatus.failedStream, error: err));
    }
  }

  /// This streams the presisted `Comment` of the current `ConverseUser` from the
  /// `ConverseRepository` and stores the result inside this bloc's `state`.
  /// The relationship between `Comment` and `ConverseUser`, in this scenario, is **One-to-Many**,
  /// which means that a single `Comment` could belong to multiple `ConverseUsers`.
  void streamCommentOfUser() async {
    try {
      emit(state.loadingState(CommentStateStatus.streaming));
      await _commentSub?.cancel();

      var user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      // String? commentId = user.commentId;
      // if ((commentId ?? '').isEmpty) throw 'NoEntityId';

      // _commentSub = _repository.streamComment(commentId!).listen((comment) {
      //   emit(state.successState(CommentStateStatus.streamed, comment: comment));
      // }, onError: (err) => emit(state.failureState(CommentStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(CommentStateStatus.failedStream, error: err));
    }
  }

  /// Fetches the presisted `Comment` back to the current BLoC.
  /// Nothing will be returned if `id` is null or empty.
  void fetchComment(String? commentId) async {
    if (commentId == null) return;
    try {
      emit(state.loadingState(CommentStateStatus.fetching));
      await _commentSub?.cancel();
      final comment = await _repository.fetchComment(commentId);
      emit(state.successState(
        CommentStateStatus.fetched,
        comment: comment,
      ));
    } catch (err) {
      emit(state.failureState(CommentStateStatus.failedFetch, error: err));
    }
  }

  /// Fetches the presisted `Comment`, which has a **One-To-One** relationship
  /// with the current `ConverseUser`, back to the current BLoC.
  /// Nothing will be returned if the `ConverseUser` is not signed in.
  /// The `Comment` is returned based on the current `ConverseUser` ID.
  void fetchUserComment() async {
    try {
      emit(state.loadingState(CommentStateStatus.fetching));
      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      await _commentSub?.cancel();
      final result = await _repository.fetchComment(user.id!);
      emit(state.successState(
        CommentStateStatus.fetched,
        comment: result,
      ));
    } catch (err) {
      emit(state.failureState(CommentStateStatus.failedFetch, error: err));
    }
  }

  /// This fetches the presisted `Comment` of the current `ConverseUser` from the
  /// `ConverseRepository` and stores the result inside this bloc's `state`.
  /// The relationship between `Comment` and `ConverseUser`, in this scenario, is **One-to-Many**,
  /// which means that a single `Comment` could belong to multiple `ConverseUsers`.
  void fetchCommentOfUser() async {
    try {
      emit(state.loadingState(CommentStateStatus.fetching));
      await _commentSub?.cancel();
      var user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      // String? commentId = user.commentId;
      // if (commentId == null ||commentId.isEmpty) throw 'NoEntityId';

      // final comment = await _repository.fetchComment(commentId);
      // emit(state.successState(
      //  CommentStateStatus.fetched,
      //  comment: comment,
      // ));
    } catch (err) {
      emit(state.failureState(CommentStateStatus.failedFetch, error: err));
    }
  }

  Future<void> updateComment() async {
    try {
      emit(state.loadingState(CommentStateStatus.updating));

      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';
      if ((state.comment.id ?? '').isEmpty) throw 'NoEntityId';

      final modifiedComment = state.comment.copyWith(
        lastModifiedDate: DateTime.now(),
        lastModifierId: user.id,
      );

      await _repository.updateComment(modifiedComment);
      emit(state.successState(
        CommentStateStatus.updated,
        comment: modifiedComment,
      ));
    } catch (err) {
      emit(state.failureState(CommentStateStatus.failedUpdate, error: err));
    }
  }

  void deleteComment([String? id]) async {
    try {
      emit(state.loadingState(CommentStateStatus.deleting));
      if ((id ?? state.comment.id) == null) throw 'NoEntityId';
      await _repository.deleteComment(id ?? state.comment.id!);
      emit(state.successState(CommentStateStatus.deleted));
    } catch (err) {
      emit(state.failureState(CommentStateStatus.failedDelete, error: err));
    }
  }

  @override
  Future<void> close() async {
    await _commentSub?.cancel();
    return super.close();
  }
}
