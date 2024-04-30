import '../domain/entities/media.g.dart';
import '../domain/entities/feed_back_round.g.dart';
import 'dart:async';

import '../domain/entities/feed.g.dart';
import 'gateways/converse_repository.g.dart';
import 'states/feed_state.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedBloc extends Cubit<FeedState> {
  final ConverseRepository _repository;
  FeedBloc(ConverseRepository converseRepository)
      : _repository = converseRepository,
        super(const FeedState.init());

  void setFeed(Feed? feed) {
    if (feed == null) return;
    emit(state.copyWith(feed: feed));
  }

  void setFeedId(String? id, [bool cache = false]) async {
    if (id == null) return;
    final feed = state.feed.copyWith(id: id);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedContent(String? content, [bool cache = false]) async {
    if (content == null) return;
    final feed = state.feed.copyWith(content: content);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedLikes(int? likes, [bool cache = false]) async {
    if (likes == null) return;
    final feed = state.feed.copyWith(likes: likes);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedCreatorFirstName(String? creatorFirstName,
      [bool cache = false]) async {
    if (creatorFirstName == null) return;
    final feed = state.feed.copyWith(creatorFirstName: creatorFirstName);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedCreatorLastName(String? creatorLastName,
      [bool cache = false]) async {
    if (creatorLastName == null) return;
    final feed = state.feed.copyWith(creatorLastName: creatorLastName);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedLiked(bool? liked, [bool cache = false]) async {
    if (liked == null) return;
    final feed = state.feed.copyWith(liked: liked);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedHasbackRound(bool? hasbackRound, [bool cache = false]) async {
    if (hasbackRound == null) return;
    final feed = state.feed.copyWith(hasbackRound: hasbackRound);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedBackRound(FeedBackRound? backRound, [bool cache = false]) async {
    if (backRound == null) return;
    final feed = state.feed.copyWith(backRound: backRound);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedMedias(List<Media>? medias, [bool cache = false]) async {
    if (medias == null) return;
    final feed = state.feed.copyWith(medias: medias);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void addMediaToFeed(
    Media media, [
    bool cache = false,
  ]) async {
    var list = List<Media>.from(state.feed.medias ?? []);
    list.add(media);
    final feed = state.feed.copyWith(medias: list);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void replaceMediaInFeed(
    int index,
    Media media, [
    bool cache = false,
  ]) async {
    var list = List<Media>.from(state.feed.medias ?? []);
    list[index] = media;
    final feed = state.feed.copyWith(medias: list);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void removeMediaFromFeed(
    int index, [
    bool cache = false,
  ]) async {
    var list = List<Media>.from(state.feed.medias ?? []);
    list.removeAt(index);
    final feed = state.feed.copyWith(medias: list);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedBusinessId(String? businessId, [bool cache = false]) async {
    if (businessId == null) return;
    final feed = state.feed.copyWith(businessId: businessId);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedBranchId(String? branchId, [bool cache = false]) async {
    if (branchId == null) return;
    final feed = state.feed.copyWith(branchId: branchId);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedFacultyId(String? facultyId, [bool cache = false]) async {
    if (facultyId == null) return;
    final feed = state.feed.copyWith(facultyId: facultyId);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedDepartmentId(String? departmentId, [bool cache = false]) async {
    if (departmentId == null) return;
    final feed = state.feed.copyWith(departmentId: departmentId);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedDivisionId(String? divisionId, [bool cache = false]) async {
    if (divisionId == null) return;
    final feed = state.feed.copyWith(divisionId: divisionId);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedUserId(String? userId, [bool cache = false]) async {
    if (userId == null) return;
    final feed = state.feed.copyWith(userId: userId);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedStakeholderId(String? stakeholderId, [bool cache = false]) async {
    if (stakeholderId == null) return;
    final feed = state.feed.copyWith(stakeholderId: stakeholderId);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedCreationDate(DateTime? creationDate, [bool cache = false]) async {
    if (creationDate == null) return;
    final feed = state.feed.copyWith(creationDate: creationDate);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedCreatorId(String? creatorId, [bool cache = false]) async {
    if (creatorId == null) return;
    final feed = state.feed.copyWith(creatorId: creatorId);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedCreatorImageUrl(String? creatorImageUrl,
      [bool cache = false]) async {
    if (creatorImageUrl == null) return;
    final feed = state.feed.copyWith(creatorImageUrl: creatorImageUrl);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedLastModifiedDate(DateTime? lastModifiedDate,
      [bool cache = false]) async {
    if (lastModifiedDate == null) return;
    final feed = state.feed.copyWith(lastModifiedDate: lastModifiedDate);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void setFeedLastModifierId(String? lastModifierId,
      [bool cache = false]) async {
    if (lastModifierId == null) return;
    final feed = state.feed.copyWith(lastModifierId: lastModifierId);
    emit(state.copyWith(feed: feed));
    if (cache) return await updateFeed();
  }

  void toInitState() {
    emit(const FeedState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(FeedStateStatus status, dynamic error) {
    emit(state.failureState(status, error: error));
  }

  /// Generates a random ID using uuid
  String generateId() {
    return _repository.generateRandomId();
  }

  /// Persists the `Feed` with the provided properties from the current BLoC.
  /// If the `Feed` already exists, its modified properties are persisted.
  /// If the `Feed` does not exist, a new `Feed` with an automatically
  /// generated ID is created and presisted.
  void saveFeed([String? feedId]) async {
    if (state.feed.id != null) {
      await updateFeed();
      return;
    }
    createFeed(feedId);
  }

  /// Persists the `Feed` with the provided properties from the current BLoC,
  /// which has a **One-To-One** relationship with the current `ConverseUser`.
  /// The persisted `Feed` ID is equivalent to the current `ConverseUser` ID.
  /// If the `Feed` already exists, its modified properties are persisted.
  /// If the `Feed` does not exist, a new `Feed` with the current
  /// `ConverseUser` ID will be created and presisted.
  void saveUserFeed() async {
    if (state.feed.id != null) {
      await updateFeed();
      return;
    }
    createUserFeed();
  }

  /// Persists the `Feed` with the provided properties from the current BLoC,
  /// which has a **One-To-Many** relationship with the current `ConverseUser`.
  /// The persisted `Feed` ID is assigned to the current `ConverseUser` as `feed`Id.
  /// If the `Feed` already exists, its modified properties are persisted.
  /// If the `Feed` does not exist, a new `Feed` with an automatically
  /// generated ID is created and presisted.
  void saveFeedOfUser() async {
    final feedId = state.feed.id;
    if (feedId == null || feedId.isEmpty) {
      return createFeedOfUser();
    }
    await updateFeed();
  }

  void saveFeedForUser() async {
    final feedId = state.feed.id;
    if (feedId == null || feedId.isEmpty) {
      return createFeedForUser();
    }
    await updateFeed();
  }

  /// Persists the `Feed` with the provided properties from the current BLoC,
  /// and an automatically generated ID.
  void createFeed([String? feedId]) async {
    try {
      emit(state.loadingState(FeedStateStatus.creating));
      final user = await _repository.fetchCurrentUserInfo();
      String? businessId = user.role.business;
      businessId = "0001";
      //if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';
      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';
      if ((feedId ?? '').trim().isNotEmpty) {
        final newFeed = state.feed.copyWith(
          id: feedId?.trim(),
          businessId: businessId,
          creationDate: DateTime.now(),
          creatorId: userId,
        );
        await _repository.createFeedWithId(
          feedId!.trim(),
          newFeed,
        );
        emit(state.successState(
          FeedStateStatus.created,
          feed: newFeed,
        ));
        return;
      }
      final newFeed = state.feed.copyWith(
        businessId: businessId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );
      final newId = await _repository.createFeed(newFeed);
      emit(state.successState(
        FeedStateStatus.created,
        feed: newFeed.copyWith(id: newId),
      ));
    } catch (err) {
      emit(state.failureState(FeedStateStatus.failedCreate, error: err));
    }
  }

  /// Persists the `Feed` with the provided properties from the current BLoC,
  /// and an automatically generated ID, which has a **One-To-One** relationship with
  /// the current `ConverseUser`.
  /// The persisted `Feed` ID is equivalent to the current `ConverseUser` ID.
  void createUserFeed() async {
    try {
      emit(state.loadingState(FeedStateStatus.creating));
      final user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final newFeed = state.feed.copyWith(
        id: userId,
        businessId: businessId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      await _repository.createFeedWithId(userId!, newFeed);
      emit(state.successState(
        FeedStateStatus.created,
        feed: newFeed,
      ));
    } catch (err) {
      emit(state.failureState(FeedStateStatus.failedCreate, error: err));
    }
  }

  /// Persists the `Feed` with the provided properties from the current BLoC,
  /// and an automatically generated ID, which has a **One-To-Many** relationship with
  /// the current `ConverseUser`.
  void createFeedOfUser() async {
    try {
      emit(state.loadingState(FeedStateStatus.creating));
      var user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      // if ((user.feedId ?? '').trim().isEmpty) {
      // final newFeed = state.feed.copyWith(
      //    businessId: businessId,
      //    creationDate: DateTime.now(),
      //    creatorId: userId,
      // );

      // final newId = await _repository.createFeed(newFeed);

      // final newUser = user.copyWith(
      //   feedId: newId,
      //   lastModifiedDate: DateTime.now(),
      //   lastModifierId: userId,
      // );

      // await _repository.updateUserInfo(newUser);
      // emit(state.successState(
      //  FeedStateStatus.created,
      //  feed: newFeed.copyWith(id: newId),
      // ));
      // return;
      // }
      emit(state.successState(FeedStateStatus.created));
    } catch (err) {
      emit(state.failureState(FeedStateStatus.failedCreate, error: err));
    }
  }

// Create a Feed which has the user ID as its attribute
// One User can have multiple {entityCamelPlural}
  void createFeedForUser() async {
    try {
      emit(state.loadingState(FeedStateStatus.creating));
      var user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final newFeed = state.feed.copyWith(
        userId: userId,
        businessId: businessId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      final newId = await _repository.createFeed(newFeed);
      emit(state.successState(
        FeedStateStatus.created,
        feed: newFeed.copyWith(id: newId),
      ));
      return;
    } catch (err) {
      emit(state.failureState(FeedStateStatus.failedCreate, error: err));
    }
  }

  /// All business subscriptions are done through
  /// this subscriber.
  StreamSubscription<Feed>? _feedSub;

  /// Streams the presisted `Feed` to the current BLoC.
  /// Nothing will be emitted if `id` is null or empty.
  void streamFeed(String? id) async {
    if (id == null) return;
    try {
      emit(state.loadingState(FeedStateStatus.streaming));
      await _feedSub?.cancel();
      _feedSub = _repository.streamFeed(id).listen((feed) {
        emit(state.successState(FeedStateStatus.streamed, feed: feed));
      },
          onError: (err) => emit(
              state.failureState(FeedStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(FeedStateStatus.failedStream, error: err));
    }
  }

  /// Streams the presisted `Feed`, which has a **One-To-One** relationship
  /// with the current `ConverseUser`, back to the current BLoC.
  /// Nothing will be emitted if the `ConverseUser` is not signed in.
  /// The `Feed` is streamed based on the current `ConverseUser` ID.
  void streamUserFeed() async {
    try {
      emit(state.loadingState(FeedStateStatus.streaming));
      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      await _feedSub?.cancel();
      _feedSub = _repository.streamFeed(user.id!).listen((feed) {
        emit(state.successState(FeedStateStatus.streamed, feed: feed));
      },
          onError: (err) => emit(
              state.failureState(FeedStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(FeedStateStatus.failedStream, error: err));
    }
  }

  /// This streams the presisted `Feed` of the current `ConverseUser` from the
  /// `ConverseRepository` and stores the result inside this bloc's `state`.
  /// The relationship between `Feed` and `ConverseUser`, in this scenario, is **One-to-Many**,
  /// which means that a single `Feed` could belong to multiple `ConverseUsers`.
  void streamFeedOfUser() async {
    try {
      emit(state.loadingState(FeedStateStatus.streaming));
      await _feedSub?.cancel();

      var user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      // String? feedId = user.feedId;
      // if ((feedId ?? '').isEmpty) throw 'NoEntityId';

      // _feedSub = _repository.streamFeed(feedId!).listen((feed) {
      //   emit(state.successState(FeedStateStatus.streamed, feed: feed));
      // }, onError: (err) => emit(state.failureState(FeedStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(FeedStateStatus.failedStream, error: err));
    }
  }

  /// Fetches the presisted `Feed` back to the current BLoC.
  /// Nothing will be returned if `id` is null or empty.
  void fetchFeed(String? feedId) async {
    if (feedId == null) return;
    try {
      emit(state.loadingState(FeedStateStatus.fetching));
      await _feedSub?.cancel();
      final feed = await _repository.fetchFeed(feedId);
      emit(state.successState(
        FeedStateStatus.fetched,
        feed: feed,
      ));
    } catch (err) {
      emit(state.failureState(FeedStateStatus.failedFetch, error: err));
    }
  }

  /// Fetches the presisted `Feed`, which has a **One-To-One** relationship
  /// with the current `ConverseUser`, back to the current BLoC.
  /// Nothing will be returned if the `ConverseUser` is not signed in.
  /// The `Feed` is returned based on the current `ConverseUser` ID.
  void fetchUserFeed() async {
    try {
      emit(state.loadingState(FeedStateStatus.fetching));
      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      await _feedSub?.cancel();
      final result = await _repository.fetchFeed(user.id!);
      emit(state.successState(
        FeedStateStatus.fetched,
        feed: result,
      ));
    } catch (err) {
      emit(state.failureState(FeedStateStatus.failedFetch, error: err));
    }
  }

  /// This fetches the presisted `Feed` of the current `ConverseUser` from the
  /// `ConverseRepository` and stores the result inside this bloc's `state`.
  /// The relationship between `Feed` and `ConverseUser`, in this scenario, is **One-to-Many**,
  /// which means that a single `Feed` could belong to multiple `ConverseUsers`.
  void fetchFeedOfUser() async {
    try {
      emit(state.loadingState(FeedStateStatus.fetching));
      await _feedSub?.cancel();
      var user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      // String? feedId = user.feedId;
      // if (feedId == null ||feedId.isEmpty) throw 'NoEntityId';

      // final feed = await _repository.fetchFeed(feedId);
      // emit(state.successState(
      //  FeedStateStatus.fetched,
      //  feed: feed,
      // ));
    } catch (err) {
      emit(state.failureState(FeedStateStatus.failedFetch, error: err));
    }
  }

  Future<void> updateFeed() async {
    try {
      emit(state.loadingState(FeedStateStatus.updating));

      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';
      if ((state.feed.id ?? '').isEmpty) throw 'NoEntityId';

      final modifiedFeed = state.feed.copyWith(
        lastModifiedDate: DateTime.now(),
        lastModifierId: user.id,
      );

      await _repository.updateFeed(modifiedFeed);
      emit(state.successState(
        FeedStateStatus.updated,
        feed: modifiedFeed,
      ));
    } catch (err) {
      emit(state.failureState(FeedStateStatus.failedUpdate, error: err));
    }
  }

  void deleteFeed([String? id]) async {
    try {
      emit(state.loadingState(FeedStateStatus.deleting));
      if ((id ?? state.feed.id) == null) throw 'NoEntityId';
      await _repository.deleteFeed(id ?? state.feed.id!);
      emit(state.successState(FeedStateStatus.deleted));
    } catch (err) {
      emit(state.failureState(FeedStateStatus.failedDelete, error: err));
    }
  }

  @override
  Future<void> close() async {
    await _feedSub?.cancel();
    return super.close();
  }
}
