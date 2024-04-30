import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

import '../blocs/dtos/get_list_request.g.dart';
import '../blocs/dtos/get_list_response.g.dart';
import '../blocs/dtos/restore_mode.g.dart';
import '../blocs/dtos/count_request.g.dart';
import '../domain/entities/converse_user.g.dart';
import '../domain/entities/converse_settings.g.dart';
import '../domain/entities/converse_stats.g.dart';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:kooza_flutter/kooza_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart';

import '../domain/entities/like.g.dart';
import '../domain/entities/feed_back_round.g.dart';
import '../domain/entities/media.g.dart';
import '../domain/entities/feed.g.dart';
import '../domain/entities/comment.g.dart';
import '../blocs/gateways/converse_repository.g.dart';

class ConverseRepositoryLocal implements ConverseRepository {
  static const String _likesRepo = 'likes';
  static const String _feedBackRoundsRepo = 'feedBackRoundText';
  static const String _mediasRepo = 'media';
  static const String _feedsRepo = 'feeds';
  static const String _commentsRepo = 'comments';

  final Uuid _uuid;
  final Kooza _kooza;
  final Duration? _ttl;

  ConverseRepositoryLocal({
    required Uuid uuid,
    required Kooza kooza,
    Duration? ttl,
  })  : _uuid = uuid,
        _kooza = kooza,
        _ttl = ttl;

  @override
  String generateRandomId() {
    try {
      return _uuid.v4().replaceAll('-', '');
    } catch (e) {
      throw 'FailedGeneratingId';
    }
  }

  @override
  Future<ConverseUser> fetchCurrentUserInfo() {
    throw UnimplementedError();
  }

  @override
  Future<ConverseSettings> fetchSettings(String businessId,
      [String idSuffix = 'iam']) {
    throw UnimplementedError();
  }

  @override
  Future<ConverseStats> fetchStats(String businessId,
      [String idSuffix = 'iam']) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveSettings(
      {required String businessId,
      String idSuffix = 'iam',
      required ConverseSettings settings}) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveStats(
      {required String businessId,
      String idSuffix = 'iam',
      required ConverseStats stats}) {
    throw UnimplementedError();
  }

  @override
  Future<void> setUpConverse(Map<String, dynamic> request) {
    throw UnimplementedError();
  }

  @override
  Stream<ConverseSettings> streamSettings(String id,
      [String idSuffix = 'iam']) {
    throw UnimplementedError();
  }

  @override
  Stream<ConverseStats> streamStats(String id, [String idSuffix = 'iam']) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserInfo(ConverseUser user) {
    throw UnimplementedError();
  }

  @override
  Future<String> createLike(Like like) async {
    try {
      // Add to Kooza
      final cache = _kooza.collection(_likesRepo);
      final id = await cache.add(like.toMap(false), ttl: _ttl);
      if (id == null) throw 'KoozaAddFailed';
      return id;
    } catch (e) {
      if (kDebugMode) {
        print('KOOZA_CREATE_${'Like'.toUpperCase()}: $e');
      }
      throw 'KOOZA_CREATE_${'Like'.toUpperCase()}';
    }
  }

  @override
  Future<void> createLikeWithId(String id, Like like) async {
    try {
      // Add to Kooza
      final cache = _kooza.collection(_likesRepo).doc(id);
      await cache.set(like.toMap(false), ttl: _ttl);
      return;
    } catch (e) {
      if (kDebugMode) {
        print('KOOZA_CREATE_${'Like'.toUpperCase()}: $e');
      }
      throw 'KOOZA_CREATE_${'Like'.toUpperCase()}';
    }
  }

  @override
  Future<void> createLikes(List<Like> likes) async {
    try {
      for (var like in likes) {
        await createLike(like);
      }
    } catch (e) {
      if (kDebugMode) print('FS_MODIFY_Likes: $e');
      throw 'FS_MODIFY_Likes';
    }
  }

  @override
  Stream<Like> streamLike(String likeId) {
    final cache = _kooza.collection(_likesRepo).doc(likeId).snapshots();
    return cache
        .map((doc) => Like.fromMap(doc.data, doc.id, false))
        .handleError((e) {
      if (kDebugMode) {
        print('LOCALDB_STREAM_Like: $e');
      }
      throw 'LOCALDB_STREAM_Like';
    });
  }

  @override
  Stream<GetListResponse<Like>> streamLikes(GetListRequest req) {
    final cache = _kooza.collection(_likesRepo).snapshots();
    return cache
        .map((col) =>
            col.docs.map((e) => Like.fromMap(e.data, e.id, false)).toList())
        .map((e) => GetListResponse<Like>(entities: e))
        .handleError((e) {
      if (kDebugMode) {
        print('LOCAL_DB_STREAM_ALL_Likes: $e');
      }
      throw 'LOCAL_DB_STREAM_ALL_Likes';
    });
  }

  @override
  Future<Like> fetchLike(String likeId) async {
    try {
      final cache = await _kooza.collection(_likesRepo).doc(likeId).get();
      return Like.fromMap(cache.data, cache.id, false);
    } catch (e) {
      if (kDebugMode) print('LOCALDB_FETCH_Like: $e');
      throw 'LOCALDB_FETCH_Like';
    }
  }

  @override
  Future<GetListResponse<Like>> fetchLikes(GetListRequest req) async {
    try {
      final cache = await _kooza.collection(_likesRepo).get();
      return GetListResponse(
        entities:
            cache.docs.map((e) => Like.fromMap(e.data, e.id, true)).toList(),
      );
    } catch (e) {
      if (kDebugMode) print('LOCALDB_FETCH_Likes: $e');
      throw 'LOCALDB_FETCH_Likes';
    }
  }

  @override
  Future<void> updateLike(Like like) async {
    try {
      if (like.id == null) throw 'id cannot be empty';
      final cache = _kooza.collection(_likesRepo).doc(like.id!);
      await cache.set(like.toMap(false), ttl: _ttl);
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Updating Like: $e');
      }
      throw 'error-modifying-like';
    }
  }

  @override
  Future<void> updateLikes(List<Like> likes) async {
    try {
      for (var like in likes) {
        await updateLike(like);
      }
    } catch (e) {
      if (kDebugMode) print('LOCALDB_MODIFY_Likes: $e');
      throw 'LOCALDB_MODIFY_Likes';
    }
  }

  @override
  Future<void> deleteLike(String likeId) async {
    try {
      final cache = _kooza.collection(_likesRepo).doc(likeId);
      await cache.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting Like: $e');
      }
      throw 'error-deleting-like';
    }
  }

  @override
  Future<void> deleteLikes(List<String> likesIds) async {
    try {
      final cache = _kooza.collection(_likesRepo);
      for (var likeId in likesIds) {
        await cache.doc(likeId).delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting Likes: $e');
      }
      throw 'error-deleting-likes';
    }
  }

  @override
  Future<void> deleteAllLikes(Map<String, dynamic> isEqualToQueries) async {
    try {
      await _kooza.collection(_likesRepo).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting Likes: $e');
      }
      throw 'error-deleting-all-likes';
    }
  }

  @override
  Future<int> countLikes(CountRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<void> backUpLikes(List<Like> selected) async {
    throw UnimplementedError();
  }

  @override
  Future<void> backUpAllLikes(Map<String, dynamic> isEqualToQueries) async {
    throw UnimplementedError();
  }

  @override
  Future<void> restoreLikes(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<String> createFeedBackRound(FeedBackRound feedBackRound) async {
    try {
      // Add to Kooza
      final cache = _kooza.collection(_feedBackRoundsRepo);
      final id = await cache.add(feedBackRound.toMap(false), ttl: _ttl);
      if (id == null) throw 'KoozaAddFailed';
      return id;
    } catch (e) {
      if (kDebugMode) {
        print('KOOZA_CREATE_${'FeedBackRound'.toUpperCase()}: $e');
      }
      throw 'KOOZA_CREATE_${'FeedBackRound'.toUpperCase()}';
    }
  }

  @override
  Future<void> createFeedBackRoundWithId(
      String id, FeedBackRound feedBackRound) async {
    try {
      // Add to Kooza
      final cache = _kooza.collection(_feedBackRoundsRepo).doc(id);
      await cache.set(feedBackRound.toMap(false), ttl: _ttl);
      return;
    } catch (e) {
      if (kDebugMode) {
        print('KOOZA_CREATE_${'FeedBackRound'.toUpperCase()}: $e');
      }
      throw 'KOOZA_CREATE_${'FeedBackRound'.toUpperCase()}';
    }
  }

  @override
  Future<void> createFeedBackRounds(List<FeedBackRound> feedBackRounds) async {
    try {
      for (var feedBackRound in feedBackRounds) {
        await createFeedBackRound(feedBackRound);
      }
    } catch (e) {
      if (kDebugMode) print('FS_MODIFY_FeedBackRounds: $e');
      throw 'FS_MODIFY_FeedBackRounds';
    }
  }

  @override
  Stream<FeedBackRound> streamFeedBackRound(String feedBackRoundId) {
    final cache =
        _kooza.collection(_feedBackRoundsRepo).doc(feedBackRoundId).snapshots();
    return cache
        .map((doc) => FeedBackRound.fromMap(doc.data, doc.id, false))
        .handleError((e) {
      if (kDebugMode) {
        print('LOCALDB_STREAM_FeedBackRound: $e');
      }
      throw 'LOCALDB_STREAM_FeedBackRound';
    });
  }

  @override
  Stream<GetListResponse<FeedBackRound>> streamFeedBackRounds(
      GetListRequest req) {
    final cache = _kooza.collection(_feedBackRoundsRepo).snapshots();
    return cache
        .map((col) => col.docs
            .map((e) => FeedBackRound.fromMap(e.data, e.id, false))
            .toList())
        .map((e) => GetListResponse<FeedBackRound>(entities: e))
        .handleError((e) {
      if (kDebugMode) {
        print('LOCAL_DB_STREAM_ALL_FeedBackRounds: $e');
      }
      throw 'LOCAL_DB_STREAM_ALL_FeedBackRounds';
    });
  }

  @override
  Future<FeedBackRound> fetchFeedBackRound(String feedBackRoundId) async {
    try {
      final cache = await _kooza
          .collection(_feedBackRoundsRepo)
          .doc(feedBackRoundId)
          .get();
      return FeedBackRound.fromMap(cache.data, cache.id, false);
    } catch (e) {
      if (kDebugMode) print('LOCALDB_FETCH_FeedBackRound: $e');
      throw 'LOCALDB_FETCH_FeedBackRound';
    }
  }

  @override
  Future<GetListResponse<FeedBackRound>> fetchFeedBackRounds(
      GetListRequest req) async {
    try {
      final cache = await _kooza.collection(_feedBackRoundsRepo).get();
      return GetListResponse(
        entities: cache.docs
            .map((e) => FeedBackRound.fromMap(e.data, e.id, true))
            .toList(),
      );
    } catch (e) {
      if (kDebugMode) print('LOCALDB_FETCH_FeedBackRounds: $e');
      throw 'LOCALDB_FETCH_FeedBackRounds';
    }
  }

  @override
  Future<void> updateFeedBackRound(FeedBackRound feedBackRound) async {
    try {
      if (feedBackRound.id == null) throw 'id cannot be empty';
      final cache =
          _kooza.collection(_feedBackRoundsRepo).doc(feedBackRound.id!);
      await cache.set(feedBackRound.toMap(false), ttl: _ttl);
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Updating FeedBackRound: $e');
      }
      throw 'error-modifying-feedBackRound';
    }
  }

  @override
  Future<void> updateFeedBackRounds(List<FeedBackRound> feedBackRounds) async {
    try {
      for (var feedBackRound in feedBackRounds) {
        await updateFeedBackRound(feedBackRound);
      }
    } catch (e) {
      if (kDebugMode) print('LOCALDB_MODIFY_FeedBackRounds: $e');
      throw 'LOCALDB_MODIFY_FeedBackRounds';
    }
  }

  @override
  Future<void> deleteFeedBackRound(String feedBackRoundId) async {
    try {
      final cache = _kooza.collection(_feedBackRoundsRepo).doc(feedBackRoundId);
      await cache.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting FeedBackRound: $e');
      }
      throw 'error-deleting-feedBackRound';
    }
  }

  @override
  Future<void> deleteFeedBackRounds(List<String> feedBackRoundsIds) async {
    try {
      final cache = _kooza.collection(_feedBackRoundsRepo);
      for (var feedBackRoundId in feedBackRoundsIds) {
        await cache.doc(feedBackRoundId).delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting FeedBackRounds: $e');
      }
      throw 'error-deleting-feedBackRounds';
    }
  }

  @override
  Future<void> deleteAllFeedBackRounds(
      Map<String, dynamic> isEqualToQueries) async {
    try {
      await _kooza.collection(_feedBackRoundsRepo).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting FeedBackRounds: $e');
      }
      throw 'error-deleting-all-feedBackRounds';
    }
  }

  @override
  Future<int> countFeedBackRounds(CountRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<void> backUpFeedBackRounds(List<FeedBackRound> selected) async {
    throw UnimplementedError();
  }

  @override
  Future<void> backUpAllFeedBackRounds(
      Map<String, dynamic> isEqualToQueries) async {
    throw UnimplementedError();
  }

  @override
  Future<void> restoreFeedBackRounds(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<String> createMedia(Media media) async {
    try {
      // Add to Kooza
      final cache = _kooza.collection(_mediasRepo);
      final id = await cache.add(media.toMap(false), ttl: _ttl);
      if (id == null) throw 'KoozaAddFailed';
      return id;
    } catch (e) {
      if (kDebugMode) {
        print('KOOZA_CREATE_${'Media'.toUpperCase()}: $e');
      }
      throw 'KOOZA_CREATE_${'Media'.toUpperCase()}';
    }
  }

  @override
  Future<void> createMediaWithId(String id, Media media) async {
    try {
      // Add to Kooza
      final cache = _kooza.collection(_mediasRepo).doc(id);
      await cache.set(media.toMap(false), ttl: _ttl);
      return;
    } catch (e) {
      if (kDebugMode) {
        print('KOOZA_CREATE_${'Media'.toUpperCase()}: $e');
      }
      throw 'KOOZA_CREATE_${'Media'.toUpperCase()}';
    }
  }

  @override
  Future<void> createMedias(List<Media> medias) async {
    try {
      for (var media in medias) {
        await createMedia(media);
      }
    } catch (e) {
      if (kDebugMode) print('FS_MODIFY_Medias: $e');
      throw 'FS_MODIFY_Medias';
    }
  }

  @override
  Stream<Media> streamMedia(String mediaId) {
    final cache = _kooza.collection(_mediasRepo).doc(mediaId).snapshots();
    return cache
        .map((doc) => Media.fromMap(doc.data, doc.id, false))
        .handleError((e) {
      if (kDebugMode) {
        print('LOCALDB_STREAM_Media: $e');
      }
      throw 'LOCALDB_STREAM_Media';
    });
  }

  @override
  Stream<GetListResponse<Media>> streamMedias(GetListRequest req) {
    final cache = _kooza.collection(_mediasRepo).snapshots();
    return cache
        .map((col) =>
            col.docs.map((e) => Media.fromMap(e.data, e.id, false)).toList())
        .map((e) => GetListResponse<Media>(entities: e))
        .handleError((e) {
      if (kDebugMode) {
        print('LOCAL_DB_STREAM_ALL_Medias: $e');
      }
      throw 'LOCAL_DB_STREAM_ALL_Medias';
    });
  }

  @override
  Future<Media> fetchMedia(String mediaId) async {
    try {
      final cache = await _kooza.collection(_mediasRepo).doc(mediaId).get();
      return Media.fromMap(cache.data, cache.id, false);
    } catch (e) {
      if (kDebugMode) print('LOCALDB_FETCH_Media: $e');
      throw 'LOCALDB_FETCH_Media';
    }
  }

  @override
  Future<GetListResponse<Media>> fetchMedias(GetListRequest req) async {
    try {
      final cache = await _kooza.collection(_mediasRepo).get();
      return GetListResponse(
        entities:
            cache.docs.map((e) => Media.fromMap(e.data, e.id, true)).toList(),
      );
    } catch (e) {
      if (kDebugMode) print('LOCALDB_FETCH_Medias: $e');
      throw 'LOCALDB_FETCH_Medias';
    }
  }

  @override
  Future<void> updateMedia(Media media) async {
    try {
      if (media.id == null) throw 'id cannot be empty';
      final cache = _kooza.collection(_mediasRepo).doc(media.id!);
      await cache.set(media.toMap(false), ttl: _ttl);
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Updating Media: $e');
      }
      throw 'error-modifying-media';
    }
  }

  @override
  Future<void> updateMedias(List<Media> medias) async {
    try {
      for (var media in medias) {
        await updateMedia(media);
      }
    } catch (e) {
      if (kDebugMode) print('LOCALDB_MODIFY_Medias: $e');
      throw 'LOCALDB_MODIFY_Medias';
    }
  }

  @override
  Future<void> deleteMedia(String mediaId) async {
    try {
      final cache = _kooza.collection(_mediasRepo).doc(mediaId);
      await cache.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting Media: $e');
      }
      throw 'error-deleting-media';
    }
  }

  @override
  Future<void> deleteMedias(List<String> mediasIds) async {
    try {
      final cache = _kooza.collection(_mediasRepo);
      for (var mediaId in mediasIds) {
        await cache.doc(mediaId).delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting Medias: $e');
      }
      throw 'error-deleting-medias';
    }
  }

  @override
  Future<void> deleteAllMedias(Map<String, dynamic> isEqualToQueries) async {
    try {
      await _kooza.collection(_mediasRepo).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting Medias: $e');
      }
      throw 'error-deleting-all-medias';
    }
  }

  @override
  Future<int> countMedias(CountRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<void> backUpMedias(List<Media> selected) async {
    throw UnimplementedError();
  }

  @override
  Future<void> backUpAllMedias(Map<String, dynamic> isEqualToQueries) async {
    throw UnimplementedError();
  }

  @override
  Future<void> restoreMedias(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<String> createFeed(Feed feed) async {
    try {
      // Add to Kooza
      final cache = _kooza.collection(_feedsRepo);
      final id = await cache.add(feed.toMap(false), ttl: _ttl);
      if (id == null) throw 'KoozaAddFailed';
      return id;
    } catch (e) {
      if (kDebugMode) {
        print('KOOZA_CREATE_${'Feed'.toUpperCase()}: $e');
      }
      throw 'KOOZA_CREATE_${'Feed'.toUpperCase()}';
    }
  }

  @override
  Future<void> createFeedWithId(String id, Feed feed) async {
    try {
      // Add to Kooza
      final cache = _kooza.collection(_feedsRepo).doc(id);
      await cache.set(feed.toMap(false), ttl: _ttl);
      return;
    } catch (e) {
      if (kDebugMode) {
        print('KOOZA_CREATE_${'Feed'.toUpperCase()}: $e');
      }
      throw 'KOOZA_CREATE_${'Feed'.toUpperCase()}';
    }
  }

  @override
  Future<void> createFeeds(List<Feed> feeds) async {
    try {
      for (var feed in feeds) {
        await createFeed(feed);
      }
    } catch (e) {
      if (kDebugMode) print('FS_MODIFY_Feeds: $e');
      throw 'FS_MODIFY_Feeds';
    }
  }

  @override
  Stream<Feed> streamFeed(String feedId) {
    final cache = _kooza.collection(_feedsRepo).doc(feedId).snapshots();
    return cache
        .map((doc) => Feed.fromMap(doc.data, doc.id, false))
        .handleError((e) {
      if (kDebugMode) {
        print('LOCALDB_STREAM_Feed: $e');
      }
      throw 'LOCALDB_STREAM_Feed';
    });
  }

  @override
  Stream<GetListResponse<Feed>> streamFeeds(GetListRequest req) {
    final cache = _kooza.collection(_feedsRepo).snapshots();
    return cache
        .map((col) =>
            col.docs.map((e) => Feed.fromMap(e.data, e.id, false)).toList())
        .map((e) => GetListResponse<Feed>(entities: e))
        .handleError((e) {
      if (kDebugMode) {
        print('LOCAL_DB_STREAM_ALL_Feeds: $e');
      }
      throw 'LOCAL_DB_STREAM_ALL_Feeds';
    });
  }

  @override
  Future<Feed> fetchFeed(String feedId) async {
    try {
      final cache = await _kooza.collection(_feedsRepo).doc(feedId).get();
      return Feed.fromMap(cache.data, cache.id, false);
    } catch (e) {
      if (kDebugMode) print('LOCALDB_FETCH_Feed: $e');
      throw 'LOCALDB_FETCH_Feed';
    }
  }

  @override
  Future<GetListResponse<Feed>> fetchFeeds(GetListRequest req) async {
    try {
      final cache = await _kooza.collection(_feedsRepo).get();
      return GetListResponse(
        entities:
            cache.docs.map((e) => Feed.fromMap(e.data, e.id, true)).toList(),
      );
    } catch (e) {
      if (kDebugMode) print('LOCALDB_FETCH_Feeds: $e');
      throw 'LOCALDB_FETCH_Feeds';
    }
  }

  @override
  Future<void> updateFeed(Feed feed) async {
    try {
      if (feed.id == null) throw 'id cannot be empty';
      final cache = _kooza.collection(_feedsRepo).doc(feed.id!);
      await cache.set(feed.toMap(false), ttl: _ttl);
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Updating Feed: $e');
      }
      throw 'error-modifying-feed';
    }
  }

  @override
  Future<void> updateFeeds(List<Feed> feeds) async {
    try {
      for (var feed in feeds) {
        await updateFeed(feed);
      }
    } catch (e) {
      if (kDebugMode) print('LOCALDB_MODIFY_Feeds: $e');
      throw 'LOCALDB_MODIFY_Feeds';
    }
  }

  @override
  Future<void> deleteFeed(String feedId) async {
    try {
      final cache = _kooza.collection(_feedsRepo).doc(feedId);
      await cache.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting Feed: $e');
      }
      throw 'error-deleting-feed';
    }
  }

  @override
  Future<void> deleteFeeds(List<String> feedsIds) async {
    try {
      final cache = _kooza.collection(_feedsRepo);
      for (var feedId in feedsIds) {
        await cache.doc(feedId).delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting Feeds: $e');
      }
      throw 'error-deleting-feeds';
    }
  }

  @override
  Future<void> deleteAllFeeds(Map<String, dynamic> isEqualToQueries) async {
    try {
      await _kooza.collection(_feedsRepo).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting Feeds: $e');
      }
      throw 'error-deleting-all-feeds';
    }
  }

  @override
  Future<int> countFeeds(CountRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<void> backUpFeeds(List<Feed> selected) async {
    throw UnimplementedError();
  }

  @override
  Future<void> backUpAllFeeds(Map<String, dynamic> isEqualToQueries) async {
    throw UnimplementedError();
  }

  @override
  Future<void> restoreFeeds(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<String> createComment(Comment comment) async {
    try {
      // Add to Kooza
      final cache = _kooza.collection(_commentsRepo);
      final id = await cache.add(comment.toMap(false), ttl: _ttl);
      if (id == null) throw 'KoozaAddFailed';
      return id;
    } catch (e) {
      if (kDebugMode) {
        print('KOOZA_CREATE_${'Comment'.toUpperCase()}: $e');
      }
      throw 'KOOZA_CREATE_${'Comment'.toUpperCase()}';
    }
  }

  @override
  Future<void> createCommentWithId(String id, Comment comment) async {
    try {
      // Add to Kooza
      final cache = _kooza.collection(_commentsRepo).doc(id);
      await cache.set(comment.toMap(false), ttl: _ttl);
      return;
    } catch (e) {
      if (kDebugMode) {
        print('KOOZA_CREATE_${'Comment'.toUpperCase()}: $e');
      }
      throw 'KOOZA_CREATE_${'Comment'.toUpperCase()}';
    }
  }

  @override
  Future<void> createComments(List<Comment> comments) async {
    try {
      for (var comment in comments) {
        await createComment(comment);
      }
    } catch (e) {
      if (kDebugMode) print('FS_MODIFY_Comments: $e');
      throw 'FS_MODIFY_Comments';
    }
  }

  @override
  Stream<Comment> streamComment(String commentId) {
    final cache = _kooza.collection(_commentsRepo).doc(commentId).snapshots();
    return cache
        .map((doc) => Comment.fromMap(doc.data, doc.id, false))
        .handleError((e) {
      if (kDebugMode) {
        print('LOCALDB_STREAM_Comment: $e');
      }
      throw 'LOCALDB_STREAM_Comment';
    });
  }

  @override
  Stream<GetListResponse<Comment>> streamComments(GetListRequest req) {
    final cache = _kooza.collection(_commentsRepo).snapshots();
    return cache
        .map((col) =>
            col.docs.map((e) => Comment.fromMap(e.data, e.id, false)).toList())
        .map((e) => GetListResponse<Comment>(entities: e))
        .handleError((e) {
      if (kDebugMode) {
        print('LOCAL_DB_STREAM_ALL_Comments: $e');
      }
      throw 'LOCAL_DB_STREAM_ALL_Comments';
    });
  }

  @override
  Future<Comment> fetchComment(String commentId) async {
    try {
      final cache = await _kooza.collection(_commentsRepo).doc(commentId).get();
      return Comment.fromMap(cache.data, cache.id, false);
    } catch (e) {
      if (kDebugMode) print('LOCALDB_FETCH_Comment: $e');
      throw 'LOCALDB_FETCH_Comment';
    }
  }

  @override
  Future<GetListResponse<Comment>> fetchComments(GetListRequest req) async {
    try {
      final cache = await _kooza.collection(_commentsRepo).get();
      return GetListResponse(
        entities:
            cache.docs.map((e) => Comment.fromMap(e.data, e.id, true)).toList(),
      );
    } catch (e) {
      if (kDebugMode) print('LOCALDB_FETCH_Comments: $e');
      throw 'LOCALDB_FETCH_Comments';
    }
  }

  @override
  Future<void> updateComment(Comment comment) async {
    try {
      if (comment.id == null) throw 'id cannot be empty';
      final cache = _kooza.collection(_commentsRepo).doc(comment.id!);
      await cache.set(comment.toMap(false), ttl: _ttl);
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Updating Comment: $e');
      }
      throw 'error-modifying-comment';
    }
  }

  @override
  Future<void> updateComments(List<Comment> comments) async {
    try {
      for (var comment in comments) {
        await updateComment(comment);
      }
    } catch (e) {
      if (kDebugMode) print('LOCALDB_MODIFY_Comments: $e');
      throw 'LOCALDB_MODIFY_Comments';
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      final cache = _kooza.collection(_commentsRepo).doc(commentId);
      await cache.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting Comment: $e');
      }
      throw 'error-deleting-comment';
    }
  }

  @override
  Future<void> deleteComments(List<String> commentsIds) async {
    try {
      final cache = _kooza.collection(_commentsRepo);
      for (var commentId in commentsIds) {
        await cache.doc(commentId).delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting Comments: $e');
      }
      throw 'error-deleting-comments';
    }
  }

  @override
  Future<void> deleteAllComments(Map<String, dynamic> isEqualToQueries) async {
    try {
      await _kooza.collection(_commentsRepo).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Local Cache => Error Deleting Comments: $e');
      }
      throw 'error-deleting-all-comments';
    }
  }

  @override
  Future<int> countComments(CountRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<void> backUpComments(List<Comment> selected) async {
    throw UnimplementedError();
  }

  @override
  Future<void> backUpAllComments(Map<String, dynamic> isEqualToQueries) async {
    throw UnimplementedError();
  }

  @override
  Future<void> restoreComments(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  ) async {
    throw UnimplementedError();
  }

  // ignore: unused_element
  Future<void> _backUpEntities(
      String name, List<Map<String, dynamic>> entities) async {
    try {
      final encryptedJson = _encryptData(jsonEncode(entities));
      final encryptedBytes = utf8.encode(encryptedJson);

      if (kIsWeb) {
        await FileSaver.instance.saveFile(
          name: name,
          bytes: encryptedBytes,
          ext: 'laams',
          mimeType: MimeType.json,
        );
        return;
      }

      if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
        await FileSaver.instance.saveAs(
          name: name,
          bytes: encryptedBytes,
          ext: 'laams',
          mimeType: MimeType.json,
        );
        return;
      }

      await FileSaver.instance.saveFile(
        name: name,
        bytes: encryptedBytes,
        ext: 'laams',
        mimeType: MimeType.json,
      );
      return;
    } catch (e) {
      rethrow;
    }
  }

  // ignore: unused_element
  Future<List<Map<String, dynamic>>> _restoreEntities() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
        allowCompression: false,
      );
      if (result == null) return const [];

      final encryptedJson = utf8.decode(result.files.single.bytes ?? []);
      final dcryptedJson = _decryptData(encryptedJson);

      final list = List<dynamic>.from(jsonDecode(dcryptedJson));
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  String _encryptData(String data) {
    try {
      final key = Key.fromUtf8('AnaarGulDanaDanaAnaarGulDanaDa#1');
      final b64key = Key.fromUtf8(base64Url.encode(key.bytes).substring(0, 32));
      final fernet = Fernet(b64key);
      final encrypter = Encrypter(fernet);
      return encrypter.encrypt(data).base64;
    } catch (e) {
      throw 'FaildEncrypting';
    }
  }

  String _decryptData(String data) {
    try {
      final key = Key.fromUtf8('AnaarGulDanaDanaAnaarGulDanaDa#1');
      final b64key = Key.fromUtf8(base64Url.encode(key.bytes).substring(0, 32));
      final fernet = Fernet(b64key);
      final encrypter = Encrypter(fernet);
      return encrypter.decrypt(Encrypted.fromBase64(data));
    } catch (e) {
      throw 'FailedDecrypting';
    }
  }
}
