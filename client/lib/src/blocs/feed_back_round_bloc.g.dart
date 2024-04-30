import 'dart:async';

import '../domain/entities/feed_back_round.g.dart';
import 'gateways/converse_repository.g.dart';
import 'states/feed_back_round_state.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedBackRoundBloc extends Cubit<FeedBackRoundState> {
  final ConverseRepository _repository;
  FeedBackRoundBloc(ConverseRepository converseRepository)
      : _repository = converseRepository,
        super(const FeedBackRoundState.init());

  void setFeedBackRound(FeedBackRound? feedBackRound) {
    if (feedBackRound == null) return;
    emit(state.copyWith(feedBackRound: feedBackRound));
  }

  void setFeedBackRoundId(String? id, [bool cache = false]) async {
    if (id == null) return;
    final feedBackRound = state.feedBackRound.copyWith(id: id);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundCreatorId(String? creatorId,
      [bool cache = false]) async {
    if (creatorId == null) return;
    final feedBackRound = state.feedBackRound.copyWith(creatorId: creatorId);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundLastModifierId(String? lastModifierId,
      [bool cache = false]) async {
    if (lastModifierId == null) return;
    final feedBackRound =
        state.feedBackRound.copyWith(lastModifierId: lastModifierId);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundContent(String? content, [bool cache = false]) async {
    if (content == null) return;
    final feedBackRound = state.feedBackRound.copyWith(content: content);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundFontSize(double? fontSize, [bool cache = false]) async {
    if (fontSize == null) return;
    final feedBackRound = state.feedBackRound.copyWith(fontSize: fontSize);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundContentRedValue(int? contentRedValue,
      [bool cache = false]) async {
    if (contentRedValue == null) return;
    final feedBackRound =
        state.feedBackRound.copyWith(contentRedValue: contentRedValue);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundContentgreenValue(int? contentgreenValue,
      [bool cache = false]) async {
    if (contentgreenValue == null) return;
    final feedBackRound =
        state.feedBackRound.copyWith(contentgreenValue: contentgreenValue);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundContentBlueValue(int? contentBlueValue,
      [bool cache = false]) async {
    if (contentBlueValue == null) return;
    final feedBackRound =
        state.feedBackRound.copyWith(contentBlueValue: contentBlueValue);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundContenAccentValue(int? contenAccentValue,
      [bool cache = false]) async {
    if (contenAccentValue == null) return;
    final feedBackRound =
        state.feedBackRound.copyWith(contenAccentValue: contenAccentValue);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundBackroundRedValue(int? backroundRedValue,
      [bool cache = false]) async {
    if (backroundRedValue == null) return;
    final feedBackRound =
        state.feedBackRound.copyWith(backroundRedValue: backroundRedValue);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundBackroundGreenValue(int? backroundGreenValue,
      [bool cache = false]) async {
    if (backroundGreenValue == null) return;
    final feedBackRound =
        state.feedBackRound.copyWith(backroundGreenValue: backroundGreenValue);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundBackroundBlueValue(int? backroundBlueValue,
      [bool cache = false]) async {
    if (backroundBlueValue == null) return;
    final feedBackRound =
        state.feedBackRound.copyWith(backroundBlueValue: backroundBlueValue);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundBackroundAccentValue(int? backroundAccentValue,
      [bool cache = false]) async {
    if (backroundAccentValue == null) return;
    final feedBackRound = state.feedBackRound
        .copyWith(backroundAccentValue: backroundAccentValue);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundStartSpace(double? startSpace,
      [bool cache = false]) async {
    if (startSpace == null) return;
    final feedBackRound = state.feedBackRound.copyWith(startSpace: startSpace);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundTopSpace(double? topSpace, [bool cache = false]) async {
    if (topSpace == null) return;
    final feedBackRound = state.feedBackRound.copyWith(topSpace: topSpace);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundCreationDate(DateTime? creationDate,
      [bool cache = false]) async {
    if (creationDate == null) return;
    final feedBackRound =
        state.feedBackRound.copyWith(creationDate: creationDate);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void setFeedBackRoundLastModifiedDate(DateTime? lastModifiedDate,
      [bool cache = false]) async {
    if (lastModifiedDate == null) return;
    final feedBackRound =
        state.feedBackRound.copyWith(lastModifiedDate: lastModifiedDate);
    emit(state.copyWith(feedBackRound: feedBackRound));
    if (cache) return await updateFeedBackRound();
  }

  void toInitState() {
    emit(const FeedBackRoundState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(FeedBackRoundStateStatus status, dynamic error) {
    emit(state.failureState(status, error: error));
  }

  /// Generates a random ID using uuid
  String generateId() {
    return _repository.generateRandomId();
  }

  /// Persists the `FeedBackRound` with the provided properties from the current BLoC.
  /// If the `FeedBackRound` already exists, its modified properties are persisted.
  /// If the `FeedBackRound` does not exist, a new `FeedBackRound` with an automatically
  /// generated ID is created and presisted.
  void saveFeedBackRound([String? feedBackRoundId]) async {
    if (state.feedBackRound.id != null) {
      await updateFeedBackRound();
      return;
    }
    createFeedBackRound(feedBackRoundId);
  }

  /// Persists the `FeedBackRound` with the provided properties from the current BLoC,
  /// which has a **One-To-One** relationship with the current `ConverseUser`.
  /// The persisted `FeedBackRound` ID is equivalent to the current `ConverseUser` ID.
  /// If the `FeedBackRound` already exists, its modified properties are persisted.
  /// If the `FeedBackRound` does not exist, a new `FeedBackRound` with the current
  /// `ConverseUser` ID will be created and presisted.
  void saveUserFeedBackRound() async {
    if (state.feedBackRound.id != null) {
      await updateFeedBackRound();
      return;
    }
    createUserFeedBackRound();
  }

  /// Persists the `FeedBackRound` with the provided properties from the current BLoC,
  /// which has a **One-To-Many** relationship with the current `ConverseUser`.
  /// The persisted `FeedBackRound` ID is assigned to the current `ConverseUser` as `feedBackRound`Id.
  /// If the `FeedBackRound` already exists, its modified properties are persisted.
  /// If the `FeedBackRound` does not exist, a new `FeedBackRound` with an automatically
  /// generated ID is created and presisted.
  void saveFeedBackRoundOfUser() async {
    final feedBackRoundId = state.feedBackRound.id;
    if (feedBackRoundId == null || feedBackRoundId.isEmpty) {
      return createFeedBackRoundOfUser();
    }
    await updateFeedBackRound();
  }

  /// Persists the `FeedBackRound` with the provided properties from the current BLoC,
  /// and an automatically generated ID.
  void createFeedBackRound([String? feedBackRoundId]) async {
    try {
      emit(state.loadingState(FeedBackRoundStateStatus.creating));
      final user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      if ((feedBackRoundId ?? '').trim().isNotEmpty) {
        final newFeedBackRound = state.feedBackRound.copyWith(
          id: feedBackRoundId,
          creationDate: DateTime.now(),
          creatorId: userId,
        );

        await _repository.createFeedBackRoundWithId(
          feedBackRoundId!,
          newFeedBackRound,
        );

        emit(state.successState(
          FeedBackRoundStateStatus.created,
          feedBackRound: newFeedBackRound,
        ));

        return;
      }

      final newFeedBackRound = state.feedBackRound.copyWith(
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      final newId = await _repository.createFeedBackRound(newFeedBackRound);
      emit(state.successState(
        FeedBackRoundStateStatus.created,
        feedBackRound: newFeedBackRound.copyWith(id: newId),
      ));
    } catch (err) {
      emit(state.failureState(FeedBackRoundStateStatus.failedCreate,
          error: err));
    }
  }

  /// Persists the `FeedBackRound` with the provided properties from the current BLoC,
  /// and an automatically generated ID, which has a **One-To-One** relationship with
  /// the current `ConverseUser`.
  /// The persisted `FeedBackRound` ID is equivalent to the current `ConverseUser` ID.
  void createUserFeedBackRound() async {
    try {
      emit(state.loadingState(FeedBackRoundStateStatus.creating));
      final user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      final newFeedBackRound = state.feedBackRound.copyWith(
        id: userId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      await _repository.createFeedBackRoundWithId(userId!, newFeedBackRound);
      emit(state.successState(
        FeedBackRoundStateStatus.created,
        feedBackRound: newFeedBackRound,
      ));
    } catch (err) {
      emit(state.failureState(FeedBackRoundStateStatus.failedCreate,
          error: err));
    }
  }

  /// Persists the `FeedBackRound` with the provided properties from the current BLoC,
  /// and an automatically generated ID, which has a **One-To-Many** relationship with
  /// the current `ConverseUser`.
  void createFeedBackRoundOfUser() async {
    try {
      emit(state.loadingState(FeedBackRoundStateStatus.creating));
      var user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      // if ((user.feedBackRoundId ?? '').trim().isEmpty) {
      // final newFeedBackRound = state.feedBackRound.copyWith(
      //    creationDate: DateTime.now(),
      //    creatorId: userId,
      // );

      // final newId = await _repository.createFeedBackRound(newFeedBackRound);

      // final newUser = user.copyWith(
      //   feedBackRoundId: newId,
      //   lastModifiedDate: DateTime.now(),
      //   lastModifierId: userId,
      // );

      // await _repository.updateUserInfo(newUser);
      // emit(state.successState(
      //  FeedBackRoundStateStatus.created,
      //  feedBackRound: newFeedBackRound.copyWith(id: newId),
      // ));
      // return;
      // }
      emit(state.successState(FeedBackRoundStateStatus.created));
    } catch (err) {
      emit(state.failureState(FeedBackRoundStateStatus.failedCreate,
          error: err));
    }
  }

  /// All business subscriptions are done through
  /// this subscriber.
  StreamSubscription<FeedBackRound>? _feedBackRoundSub;

  /// Streams the presisted `FeedBackRound` to the current BLoC.
  /// Nothing will be emitted if `id` is null or empty.
  void streamFeedBackRound(String? id) async {
    if (id == null) return;
    try {
      emit(state.loadingState(FeedBackRoundStateStatus.streaming));
      await _feedBackRoundSub?.cancel();
      _feedBackRoundSub = _repository.streamFeedBackRound(id).listen(
          (feedBackRound) {
        emit(state.successState(FeedBackRoundStateStatus.streamed,
            feedBackRound: feedBackRound));
      },
          onError: (err) => emit(state.failureState(
              FeedBackRoundStateStatus.failedStream,
              error: err)));
    } catch (err) {
      emit(state.failureState(FeedBackRoundStateStatus.failedStream,
          error: err));
    }
  }

  /// Streams the presisted `FeedBackRound`, which has a **One-To-One** relationship
  /// with the current `ConverseUser`, back to the current BLoC.
  /// Nothing will be emitted if the `ConverseUser` is not signed in.
  /// The `FeedBackRound` is streamed based on the current `ConverseUser` ID.
  void streamUserFeedBackRound() async {
    try {
      emit(state.loadingState(FeedBackRoundStateStatus.streaming));
      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      await _feedBackRoundSub?.cancel();
      _feedBackRoundSub = _repository.streamFeedBackRound(user.id!).listen(
          (feedBackRound) {
        emit(state.successState(FeedBackRoundStateStatus.streamed,
            feedBackRound: feedBackRound));
      },
          onError: (err) => emit(state.failureState(
              FeedBackRoundStateStatus.failedStream,
              error: err)));
    } catch (err) {
      emit(state.failureState(FeedBackRoundStateStatus.failedStream,
          error: err));
    }
  }

  /// This streams the presisted `FeedBackRound` of the current `ConverseUser` from the
  /// `ConverseRepository` and stores the result inside this bloc's `state`.
  /// The relationship between `FeedBackRound` and `ConverseUser`, in this scenario, is **One-to-Many**,
  /// which means that a single `FeedBackRound` could belong to multiple `ConverseUsers`.
  void streamFeedBackRoundOfUser() async {
    try {
      emit(state.loadingState(FeedBackRoundStateStatus.streaming));
      await _feedBackRoundSub?.cancel();

      var user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      // String? feedBackRoundId = user.feedBackRoundId;
      // if ((feedBackRoundId ?? '').isEmpty) throw 'NoEntityId';

      // _feedBackRoundSub = _repository.streamFeedBackRound(feedBackRoundId!).listen((feedBackRound) {
      //   emit(state.successState(FeedBackRoundStateStatus.streamed, feedBackRound: feedBackRound));
      // }, onError: (err) => emit(state.failureState(FeedBackRoundStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(FeedBackRoundStateStatus.failedStream,
          error: err));
    }
  }

  /// Fetches the presisted `FeedBackRound` back to the current BLoC.
  /// Nothing will be returned if `id` is null or empty.
  void fetchFeedBackRound(String? feedBackRoundId) async {
    if (feedBackRoundId == null) return;
    try {
      emit(state.loadingState(FeedBackRoundStateStatus.fetching));
      await _feedBackRoundSub?.cancel();
      final feedBackRound =
          await _repository.fetchFeedBackRound(feedBackRoundId);
      emit(state.successState(
        FeedBackRoundStateStatus.fetched,
        feedBackRound: feedBackRound,
      ));
    } catch (err) {
      emit(
          state.failureState(FeedBackRoundStateStatus.failedFetch, error: err));
    }
  }

  /// Fetches the presisted `FeedBackRound`, which has a **One-To-One** relationship
  /// with the current `ConverseUser`, back to the current BLoC.
  /// Nothing will be returned if the `ConverseUser` is not signed in.
  /// The `FeedBackRound` is returned based on the current `ConverseUser` ID.
  void fetchUserFeedBackRound() async {
    try {
      emit(state.loadingState(FeedBackRoundStateStatus.fetching));
      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      await _feedBackRoundSub?.cancel();
      final result = await _repository.fetchFeedBackRound(user.id!);
      emit(state.successState(
        FeedBackRoundStateStatus.fetched,
        feedBackRound: result,
      ));
    } catch (err) {
      emit(
          state.failureState(FeedBackRoundStateStatus.failedFetch, error: err));
    }
  }

  /// This fetches the presisted `FeedBackRound` of the current `ConverseUser` from the
  /// `ConverseRepository` and stores the result inside this bloc's `state`.
  /// The relationship between `FeedBackRound` and `ConverseUser`, in this scenario, is **One-to-Many**,
  /// which means that a single `FeedBackRound` could belong to multiple `ConverseUsers`.
  void fetchFeedBackRoundOfUser() async {
    try {
      emit(state.loadingState(FeedBackRoundStateStatus.fetching));
      await _feedBackRoundSub?.cancel();
      var user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      // String? feedBackRoundId = user.feedBackRoundId;
      // if (feedBackRoundId == null ||feedBackRoundId.isEmpty) throw 'NoEntityId';

      // final feedBackRound = await _repository.fetchFeedBackRound(feedBackRoundId);
      // emit(state.successState(
      //  FeedBackRoundStateStatus.fetched,
      //  feedBackRound: feedBackRound,
      // ));
    } catch (err) {
      emit(
          state.failureState(FeedBackRoundStateStatus.failedFetch, error: err));
    }
  }

  Future<void> updateFeedBackRound() async {
    try {
      emit(state.loadingState(FeedBackRoundStateStatus.updating));

      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';
      if ((state.feedBackRound.id ?? '').isEmpty) throw 'NoEntityId';

      final modifiedFeedBackRound = state.feedBackRound.copyWith(
        lastModifiedDate: DateTime.now(),
        lastModifierId: user.id,
      );

      await _repository.updateFeedBackRound(modifiedFeedBackRound);
      emit(state.successState(
        FeedBackRoundStateStatus.updated,
        feedBackRound: modifiedFeedBackRound,
      ));
    } catch (err) {
      emit(state.failureState(FeedBackRoundStateStatus.failedUpdate,
          error: err));
    }
  }

  void deleteFeedBackRound([String? id]) async {
    try {
      emit(state.loadingState(FeedBackRoundStateStatus.deleting));
      if ((id ?? state.feedBackRound.id) == null) throw 'NoEntityId';
      await _repository.deleteFeedBackRound(id ?? state.feedBackRound.id!);
      emit(state.successState(FeedBackRoundStateStatus.deleted));
    } catch (err) {
      emit(state.failureState(FeedBackRoundStateStatus.failedDelete,
          error: err));
    }
  }

  @override
  Future<void> close() async {
    await _feedBackRoundSub?.cancel();
    return super.close();
  }
}
