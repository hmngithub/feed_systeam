import '../domain/enums/media_type.g.dart';
import 'dart:async';

import '../domain/entities/media.g.dart';
import 'gateways/converse_repository.g.dart';
import 'states/media_state.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaBloc extends Cubit<MediaState> {
  final ConverseRepository _repository;
  MediaBloc(ConverseRepository converseRepository)
      : _repository = converseRepository,
        super(const MediaState.init());

  void setMedia(Media? media) {
    if (media == null) return;
    emit(state.copyWith(media: media));
  }

  void setMediaId(String? id, [bool cache = false]) async {
    if (id == null) return;
    final media = state.media.copyWith(id: id);
    emit(state.copyWith(media: media));
    if (cache) return await updateMedia();
  }

  void setMediaCreatorId(String? creatorId, [bool cache = false]) async {
    if (creatorId == null) return;
    final media = state.media.copyWith(creatorId: creatorId);
    emit(state.copyWith(media: media));
    if (cache) return await updateMedia();
  }

  void setMediaLastModifierId(String? lastModifierId,
      [bool cache = false]) async {
    if (lastModifierId == null) return;
    final media = state.media.copyWith(lastModifierId: lastModifierId);
    emit(state.copyWith(media: media));
    if (cache) return await updateMedia();
  }

  void setMediaUrl(String? url, [bool cache = false]) async {
    if (url == null) return;
    final media = state.media.copyWith(url: url);
    emit(state.copyWith(media: media));
    if (cache) return await updateMedia();
  }

  void setMediaType(MediaType? type, [bool cache = false]) async {
    if (type == null) return;
    final media = state.media.copyWith(type: type);
    emit(state.copyWith(media: media));
    if (cache) return await updateMedia();
  }

  void setMediaCreationDate(DateTime? creationDate,
      [bool cache = false]) async {
    if (creationDate == null) return;
    final media = state.media.copyWith(creationDate: creationDate);
    emit(state.copyWith(media: media));
    if (cache) return await updateMedia();
  }

  void setMediaLastModifiedDate(DateTime? lastModifiedDate,
      [bool cache = false]) async {
    if (lastModifiedDate == null) return;
    final media = state.media.copyWith(lastModifiedDate: lastModifiedDate);
    emit(state.copyWith(media: media));
    if (cache) return await updateMedia();
  }

  void toInitState() {
    emit(const MediaState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(MediaStateStatus status, dynamic error) {
    emit(state.failureState(status, error: error));
  }

  /// Generates a random ID using uuid
  String generateId() {
    return _repository.generateRandomId();
  }

  /// Persists the `Media` with the provided properties from the current BLoC.
  /// If the `Media` already exists, its modified properties are persisted.
  /// If the `Media` does not exist, a new `Media` with an automatically
  /// generated ID is created and presisted.
  void saveMedia([String? mediaId]) async {
    if (state.media.id != null) {
      await updateMedia();
      return;
    }
    createMedia(mediaId);
  }

  /// Persists the `Media` with the provided properties from the current BLoC,
  /// which has a **One-To-One** relationship with the current `ConverseUser`.
  /// The persisted `Media` ID is equivalent to the current `ConverseUser` ID.
  /// If the `Media` already exists, its modified properties are persisted.
  /// If the `Media` does not exist, a new `Media` with the current
  /// `ConverseUser` ID will be created and presisted.
  void saveUserMedia() async {
    if (state.media.id != null) {
      await updateMedia();
      return;
    }
    createUserMedia();
  }

  /// Persists the `Media` with the provided properties from the current BLoC,
  /// which has a **One-To-Many** relationship with the current `ConverseUser`.
  /// The persisted `Media` ID is assigned to the current `ConverseUser` as `media`Id.
  /// If the `Media` already exists, its modified properties are persisted.
  /// If the `Media` does not exist, a new `Media` with an automatically
  /// generated ID is created and presisted.
  void saveMediaOfUser() async {
    final mediaId = state.media.id;
    if (mediaId == null || mediaId.isEmpty) {
      return createMediaOfUser();
    }
    await updateMedia();
  }

  /// Persists the `Media` with the provided properties from the current BLoC,
  /// and an automatically generated ID.
  void createMedia([String? mediaId]) async {
    try {
      emit(state.loadingState(MediaStateStatus.creating));
      final user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      if ((mediaId ?? '').trim().isNotEmpty) {
        final newMedia = state.media.copyWith(
          id: mediaId,
          creationDate: DateTime.now(),
          creatorId: userId,
        );

        await _repository.createMediaWithId(
          mediaId!,
          newMedia,
        );

        emit(state.successState(
          MediaStateStatus.created,
          media: newMedia,
        ));

        return;
      }

      final newMedia = state.media.copyWith(
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      final newId = await _repository.createMedia(newMedia);
      emit(state.successState(
        MediaStateStatus.created,
        media: newMedia.copyWith(id: newId),
      ));
    } catch (err) {
      emit(state.failureState(MediaStateStatus.failedCreate, error: err));
    }
  }

  /// Persists the `Media` with the provided properties from the current BLoC,
  /// and an automatically generated ID, which has a **One-To-One** relationship with
  /// the current `ConverseUser`.
  /// The persisted `Media` ID is equivalent to the current `ConverseUser` ID.
  void createUserMedia() async {
    try {
      emit(state.loadingState(MediaStateStatus.creating));
      final user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      final newMedia = state.media.copyWith(
        id: userId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      await _repository.createMediaWithId(userId!, newMedia);
      emit(state.successState(
        MediaStateStatus.created,
        media: newMedia,
      ));
    } catch (err) {
      emit(state.failureState(MediaStateStatus.failedCreate, error: err));
    }
  }

  /// Persists the `Media` with the provided properties from the current BLoC,
  /// and an automatically generated ID, which has a **One-To-Many** relationship with
  /// the current `ConverseUser`.
  void createMediaOfUser() async {
    try {
      emit(state.loadingState(MediaStateStatus.creating));
      var user = await _repository.fetchCurrentUserInfo();

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      // if ((user.mediaId ?? '').trim().isEmpty) {
      // final newMedia = state.media.copyWith(
      //    creationDate: DateTime.now(),
      //    creatorId: userId,
      // );

      // final newId = await _repository.createMedia(newMedia);

      // final newUser = user.copyWith(
      //   mediaId: newId,
      //   lastModifiedDate: DateTime.now(),
      //   lastModifierId: userId,
      // );

      // await _repository.updateUserInfo(newUser);
      // emit(state.successState(
      //  MediaStateStatus.created,
      //  media: newMedia.copyWith(id: newId),
      // ));
      // return;
      // }
      emit(state.successState(MediaStateStatus.created));
    } catch (err) {
      emit(state.failureState(MediaStateStatus.failedCreate, error: err));
    }
  }

  /// All business subscriptions are done through
  /// this subscriber.
  StreamSubscription<Media>? _mediaSub;

  /// Streams the presisted `Media` to the current BLoC.
  /// Nothing will be emitted if `id` is null or empty.
  void streamMedia(String? id) async {
    if (id == null) return;
    try {
      emit(state.loadingState(MediaStateStatus.streaming));
      await _mediaSub?.cancel();
      _mediaSub = _repository.streamMedia(id).listen((media) {
        emit(state.successState(MediaStateStatus.streamed, media: media));
      },
          onError: (err) => emit(
              state.failureState(MediaStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(MediaStateStatus.failedStream, error: err));
    }
  }

  /// Streams the presisted `Media`, which has a **One-To-One** relationship
  /// with the current `ConverseUser`, back to the current BLoC.
  /// Nothing will be emitted if the `ConverseUser` is not signed in.
  /// The `Media` is streamed based on the current `ConverseUser` ID.
  void streamUserMedia() async {
    try {
      emit(state.loadingState(MediaStateStatus.streaming));
      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      await _mediaSub?.cancel();
      _mediaSub = _repository.streamMedia(user.id!).listen((media) {
        emit(state.successState(MediaStateStatus.streamed, media: media));
      },
          onError: (err) => emit(
              state.failureState(MediaStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(MediaStateStatus.failedStream, error: err));
    }
  }

  /// This streams the presisted `Media` of the current `ConverseUser` from the
  /// `ConverseRepository` and stores the result inside this bloc's `state`.
  /// The relationship between `Media` and `ConverseUser`, in this scenario, is **One-to-Many**,
  /// which means that a single `Media` could belong to multiple `ConverseUsers`.
  void streamMediaOfUser() async {
    try {
      emit(state.loadingState(MediaStateStatus.streaming));
      await _mediaSub?.cancel();

      var user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      // String? mediaId = user.mediaId;
      // if ((mediaId ?? '').isEmpty) throw 'NoEntityId';

      // _mediaSub = _repository.streamMedia(mediaId!).listen((media) {
      //   emit(state.successState(MediaStateStatus.streamed, media: media));
      // }, onError: (err) => emit(state.failureState(MediaStateStatus.failedStream, error: err)));
    } catch (err) {
      emit(state.failureState(MediaStateStatus.failedStream, error: err));
    }
  }

  /// Fetches the presisted `Media` back to the current BLoC.
  /// Nothing will be returned if `id` is null or empty.
  void fetchMedia(String? mediaId) async {
    if (mediaId == null) return;
    try {
      emit(state.loadingState(MediaStateStatus.fetching));
      await _mediaSub?.cancel();
      final media = await _repository.fetchMedia(mediaId);
      emit(state.successState(
        MediaStateStatus.fetched,
        media: media,
      ));
    } catch (err) {
      emit(state.failureState(MediaStateStatus.failedFetch, error: err));
    }
  }

  /// Fetches the presisted `Media`, which has a **One-To-One** relationship
  /// with the current `ConverseUser`, back to the current BLoC.
  /// Nothing will be returned if the `ConverseUser` is not signed in.
  /// The `Media` is returned based on the current `ConverseUser` ID.
  void fetchUserMedia() async {
    try {
      emit(state.loadingState(MediaStateStatus.fetching));
      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      await _mediaSub?.cancel();
      final result = await _repository.fetchMedia(user.id!);
      emit(state.successState(
        MediaStateStatus.fetched,
        media: result,
      ));
    } catch (err) {
      emit(state.failureState(MediaStateStatus.failedFetch, error: err));
    }
  }

  /// This fetches the presisted `Media` of the current `ConverseUser` from the
  /// `ConverseRepository` and stores the result inside this bloc's `state`.
  /// The relationship between `Media` and `ConverseUser`, in this scenario, is **One-to-Many**,
  /// which means that a single `Media` could belong to multiple `ConverseUsers`.
  void fetchMediaOfUser() async {
    try {
      emit(state.loadingState(MediaStateStatus.fetching));
      await _mediaSub?.cancel();
      var user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';

      // String? mediaId = user.mediaId;
      // if (mediaId == null ||mediaId.isEmpty) throw 'NoEntityId';

      // final media = await _repository.fetchMedia(mediaId);
      // emit(state.successState(
      //  MediaStateStatus.fetched,
      //  media: media,
      // ));
    } catch (err) {
      emit(state.failureState(MediaStateStatus.failedFetch, error: err));
    }
  }

  Future<void> updateMedia() async {
    try {
      emit(state.loadingState(MediaStateStatus.updating));

      final user = await _repository.fetchCurrentUserInfo();
      if ((user.id ?? '').isEmpty) throw 'NoCurrentUserId';
      if ((state.media.id ?? '').isEmpty) throw 'NoEntityId';

      final modifiedMedia = state.media.copyWith(
        lastModifiedDate: DateTime.now(),
        lastModifierId: user.id,
      );

      await _repository.updateMedia(modifiedMedia);
      emit(state.successState(
        MediaStateStatus.updated,
        media: modifiedMedia,
      ));
    } catch (err) {
      emit(state.failureState(MediaStateStatus.failedUpdate, error: err));
    }
  }

  void deleteMedia([String? id]) async {
    try {
      emit(state.loadingState(MediaStateStatus.deleting));
      if ((id ?? state.media.id) == null) throw 'NoEntityId';
      await _repository.deleteMedia(id ?? state.media.id!);
      emit(state.successState(MediaStateStatus.deleted));
    } catch (err) {
      emit(state.failureState(MediaStateStatus.failedDelete, error: err));
    }
  }

  @override
  Future<void> close() async {
    await _mediaSub?.cancel();
    return super.close();
  }
}
