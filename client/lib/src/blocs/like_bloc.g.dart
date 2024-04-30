import 'dart:async';

import '../domain/entities/like.g.dart';
import 'gateways/converse_repository.g.dart';
import 'states/like_state.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeBloc extends Cubit<LikeState> {
  final ConverseRepository _repository;
  LikeBloc(ConverseRepository converseRepository)
      : _repository = converseRepository,
        super(const LikeState.init());

  void setLike(Like? like) {
    if (like == null) return;
    emit(state.copyWith(like: like));
  }

  void setLikeId(String? id, [bool cache = false]) async {
    if (id == null) return;
    final like = state.like.copyWith(id: id);
    emit(state.copyWith(like: like));
    if (cache) return await updateLike();
  }

  void setLikeBusinessId(String? businessId, [bool cache = false]) async {
    if (businessId == null) return;
    final like = state.like.copyWith(businessId: businessId);
    emit(state.copyWith(like: like));
    if (cache) return await updateLike();
  }

  void setLikeFeedId(String? feedId, [bool cache = false]) async {
    if (feedId == null) return;
    final like = state.like.copyWith(feedId: feedId);
    emit(state.copyWith(like: like));
    if (cache) return await updateLike();
  }

  void setLikeUserId(String? userId, [bool cache = false]) async {
    if (userId == null) return;
    final like = state.like.copyWith(userId: userId);
    emit(state.copyWith(like: like));
    if (cache) return await updateLike();
  }

  void setLikeCreationDate(DateTime? creationDate, [bool cache = false]) async {
    if (creationDate == null) return;
    final like = state.like.copyWith(creationDate: creationDate);
    emit(state.copyWith(like: like));
    if (cache) return await updateLike();
  }

  void setLikeCreatorId(String? creatorId, [bool cache = false]) async {
    if (creatorId == null) return;
    final like = state.like.copyWith(creatorId: creatorId);
    emit(state.copyWith(like: like));
    if (cache) return await updateLike();
  }

  void setLikeCreatorFirstName(String? creatorFirstName,
      [bool cache = false]) async {
    if (creatorFirstName == null) return;
    final like = state.like.copyWith(creatorFirstName: creatorFirstName);
    emit(state.copyWith(like: like));
    if (cache) return await updateLike();
  }

  void setLikeCreatorLastName(String? creatorLastName,
      [bool cache = false]) async {
    if (creatorLastName == null) return;
    final like = state.like.copyWith(creatorLastName: creatorLastName);
    emit(state.copyWith(like: like));
    if (cache) return await updateLike();
  }

  void setLikeLastModifiedDate(DateTime? lastModifiedDate,
      [bool cache = false]) async {
    if (lastModifiedDate == null) return;
    final like = state.like.copyWith(lastModifiedDate: lastModifiedDate);
    emit(state.copyWith(like: like));
    if (cache) return await updateLike();
  }

  void setLikeLastModifierId(String? lastModifierId,
      [bool cache = false]) async {
    if (lastModifierId == null) return;
    final like = state.like.copyWith(lastModifierId: lastModifierId);
    emit(state.copyWith(like: like));
    if (cache) return await updateLike();
  }

  void toInitState() {
    emit(const LikeState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(LikeStateStatus status, dynamic error) {
    emit(state.failureState(status, error: error));
  }

  /// Generates a random ID using uuid
  String generateId() {
    return _repository.generateRandomId();
  }

  /// Persists the `Like` with the provided properties from the current BLoC.
  /// If the `Like` already exists, its modified properties are persisted.
  /// If the `Like` does not exist, a new `Like` with an automatically
  /// generated ID is created and presisted.
  void saveLike([String? likeId]) async {
    if (state.like.id != null) {
      await updateLike();
      return;
    }
    createLike(likeId);
  }

  /// Persists the `Like` with the provided properties from the current BLoC,
  /// which has a **One-To-One** relationship with the current `ConverseUser`.
  /// The persisted `Like` ID is equivalent to the current `ConverseUser` ID.
  /// If the `Like` already exists, its modified properties are persisted.
  /// If the `Like` does not exist, a new `Like` with the current
  /// `ConverseUser` ID will be created and presisted.
  void saveUserLike() async {
    if (state.like.id != null) {
      await updateLike();
      return;
    }
    createUserLike();
  }

  /// Persists the `Like` with the provided properties from the current BLoC,
  /// which has a **One-To-Many** relationship with the current `ConverseUser`.
  /// The persisted `Like` ID is assigned to the current `ConverseUser` as `like`Id.
  /// If the `Like` already exists, its modified properties are persisted.
  /// If the `Like` does not exist, a new `Like` with an automatically
  /// generated ID is created and presisted.
  void saveLikeOfUser() async {
    final likeId = state.like.id;
    if (likeId == null || likeId.isEmpty) {
      return createLikeOfUser();
    }
    await updateLike();
  }

  void saveLikeForUser() async {
    final likeId = state.like.id;
    if (likeId == null || likeId.isEmpty) {
      return createLikeForUser();
    }
    await updateLike();
  }

  /// Persists the `Like` with the provided properties from the current BLoC,
  /// and an automatically generated ID.
  void createLike([String? likeId]) async {
    try {
      emit(state.loadingState(LikeStateStatus.creating));
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      if ((likeId ?? '').trim().isNotEmpty) {
        final newLike = state.like.copyWith(
          id: likeId?.trim(),
          businessId: businessId,
          creationDate: DateTime.now(),
          creatorId: userId,
        );

        await _repository.createLikeWithId(
          likeId!.trim(),
          newLike,
        );

        emit(state.successState(
          LikeStateStatus.created,
          like: newLike,
        ));

        return;
      }

      final newLike = state.like.copyWith(
        businessId: businessId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      final newId = await _repository.createLike(newLike);
      emit(state.successState(
        LikeStateStatus.created,
        like: newLike.copyWith(id: newId),
      ));
    } catch (err) {
      emit(state.failureState(LikeStateStatus.failedCreate, error: err));
    }
  }

  /// Persists the `Like` with the provided properties from the current BLoC,
  /// and an automatically generated ID, which has a **One-To-One** relationship with
  /// the current `ConverseUser`.
  /// The persisted `Like` ID is equivalent to the current `ConverseUser` ID.
  void createUserLike() async {
    try {
      emit(state.loadingState(LikeStateStatus.creating));
      final user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final newLike = state.like.copyWith(
        id: userId,
        businessId: businessId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      await _repository.createLikeWithId(userId!, newLike);
      emit(state.successState(
        LikeStateStatus.created,
        like: newLike,
      ));
    } catch (err) {
      emit(state.failureState(LikeStateStatus.failedCreate, error: err));
    }
  }

  /// Persists the `Like` with the provided properties from the current BLoC,
  /// and an automatically generated ID, which has a **One-To-Many** relationship with
  /// the current `ConverseUser`.
  void createLikeOfUser() async {
    try {
      emit(state.loadingState(LikeStateStatus.creating));
      var user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      // if ((user.likeId ?? '').trim().isEmpty) {
      // final newLike = state.like.copyWith(
      //    businessId: businessId,
      //    creationDate: DateTime.now(),
      //    creatorId: userId,
      // );

      // final newId = await _repository.createLike(newLike);

      // final newUser = user.copyWith(
      //   likeId: newId,
      //   lastModifiedDate: DateTime.now(),
      //   lastModifierId: userId,
      // );

      // await _repository.updateUserInfo(newUser);
      // emit(state.successState(
      //  LikeStateStatus.created,
      //  like: newLike.copyWith(id: newId),
      // ));
      // return;
      // }
      emit(state.successState(LikeStateStatus.created));
    } catch (err) {
      emit(state.failureState(LikeStateStatus.failedCreate, error: err));
    }
  }

// Create a Like which has the user ID as its attribute
// One User can have multiple {entityCamelPlural}
  void createLikeForUser() async {
    try {
      emit(state.loadingState(LikeStateStatus.creating));
      var user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final newLike = state.like.copyWith(
        userId: userId,
        businessId: businessId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      final newId = await _repository.createLike(newLike);
      emit(state.successState(
        LikeStateStatus.created,
        like: newLike.copyWith(id: newId),
      ));
      return;
    } catch (err) {
      emit(state.failureState(LikeStateStatus.failedCreate, error: err));
    }
  }

  /// All business subscriptions are done through
  /// this subscriber.
  StreamSubscription<Like>? _likeSub;

  /// Streams the presisted `Like` to the current BLoC.
  /// Nothing will be emitted if `id` is null or empty.
  void streamLike(String? id) async {
    if (id == null) return;
    try {
      emit(state.loadingState(LikeStateStatus.streaming));
      await _likeSub?.cancel();
      _likeSub = _repository.streamLike(id).listen((like) {
        emit(state.successState(LikeStateStatus.streamed, like: like));
      },
          onError: (err) => emit(
              state.failureState(LikeStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(LikeStateStatus.failedStream, error: err));
    }
  }

  /// Streams the presisted `Like`, which has a **One-To-One** relationship
  /// with the current `ConverseUser`, back to the current BLoC.
  /// Nothing will be emitted if the `ConverseUser` is not signed in.
  /// The `Like` is streamed based on the current `ConverseUser` ID.
  void streamUserLike() async {
    try {
      emit(state.loadingState(LikeStateStatus.streaming));
      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      await _likeSub?.cancel();
      _likeSub = _repository.streamLike(user.id!).listen((like) {
        emit(state.successState(LikeStateStatus.streamed, like: like));
      },
          onError: (err) => emit(
              state.failureState(LikeStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(LikeStateStatus.failedStream, error: err));
    }
  }

  /// This streams the presisted `Like` of the current `ConverseUser` from the
  /// `ConverseRepository` and stores the result inside this bloc's `state`.
  /// The relationship between `Like` and `ConverseUser`, in this scenario, is **One-to-Many**,
  /// which means that a single `Like` could belong to multiple `ConverseUsers`.
  void streamLikeOfUser() async {
    try {
      emit(state.loadingState(LikeStateStatus.streaming));
      await _likeSub?.cancel();

      var user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      // String? likeId = user.likeId;
      // if ((likeId ?? '').isEmpty) throw 'NoEntityId';

      // _likeSub = _repository.streamLike(likeId!).listen((like) {
      //   emit(state.successState(LikeStateStatus.streamed, like: like));
      // }, onError: (err) => emit(state.failureState(LikeStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(LikeStateStatus.failedStream, error: err));
    }
  }

  /// Fetches the presisted `Like` back to the current BLoC.
  /// Nothing will be returned if `id` is null or empty.
  void fetchLike(String? likeId) async {
    if (likeId == null) return;
    try {
      emit(state.loadingState(LikeStateStatus.fetching));
      await _likeSub?.cancel();
      final like = await _repository.fetchLike(likeId);
      emit(state.successState(
        LikeStateStatus.fetched,
        like: like,
      ));
    } catch (err) {
      emit(state.failureState(LikeStateStatus.failedFetch, error: err));
    }
  }

  /// Fetches the presisted `Like`, which has a **One-To-One** relationship
  /// with the current `ConverseUser`, back to the current BLoC.
  /// Nothing will be returned if the `ConverseUser` is not signed in.
  /// The `Like` is returned based on the current `ConverseUser` ID.
  void fetchUserLike() async {
    try {
      emit(state.loadingState(LikeStateStatus.fetching));
      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      await _likeSub?.cancel();
      final result = await _repository.fetchLike(user.id!);
      emit(state.successState(
        LikeStateStatus.fetched,
        like: result,
      ));
    } catch (err) {
      emit(state.failureState(LikeStateStatus.failedFetch, error: err));
    }
  }

  /// This fetches the presisted `Like` of the current `ConverseUser` from the
  /// `ConverseRepository` and stores the result inside this bloc's `state`.
  /// The relationship between `Like` and `ConverseUser`, in this scenario, is **One-to-Many**,
  /// which means that a single `Like` could belong to multiple `ConverseUsers`.
  void fetchLikeOfUser() async {
    try {
      emit(state.loadingState(LikeStateStatus.fetching));
      await _likeSub?.cancel();
      var user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      // String? likeId = user.likeId;
      // if (likeId == null ||likeId.isEmpty) throw 'NoEntityId';

      // final like = await _repository.fetchLike(likeId);
      // emit(state.successState(
      //  LikeStateStatus.fetched,
      //  like: like,
      // ));
    } catch (err) {
      emit(state.failureState(LikeStateStatus.failedFetch, error: err));
    }
  }

  Future<void> updateLike() async {
    try {
      emit(state.loadingState(LikeStateStatus.updating));

      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';
      if ((state.like.id ?? '').isEmpty) throw 'NoEntityId';

      final modifiedLike = state.like.copyWith(
        lastModifiedDate: DateTime.now(),
        lastModifierId: user.id,
      );

      await _repository.updateLike(modifiedLike);
      emit(state.successState(
        LikeStateStatus.updated,
        like: modifiedLike,
      ));
    } catch (err) {
      emit(state.failureState(LikeStateStatus.failedUpdate, error: err));
    }
  }

  void deleteLike([String? id]) async {
    try {
      emit(state.loadingState(LikeStateStatus.deleting));
      if ((id ?? state.like.id) == null) throw 'NoEntityId';
      await _repository.deleteLike(id ?? state.like.id!);
      emit(state.successState(LikeStateStatus.deleted));
    } catch (err) {
      emit(state.failureState(LikeStateStatus.failedDelete, error: err));
    }
  }

  @override
  Future<void> close() async {
    await _likeSub?.cancel();
    return super.close();
  }
}
