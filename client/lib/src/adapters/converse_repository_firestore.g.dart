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
import '../domain/entities/current_role.g.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class ConverseRepositoryFirestore implements ConverseRepository {
  static const String _usersRepo = 'users';
  static const String _settingsRepo = 'services_settings';
  static const String _statsRepo = 'services_stats';
  static const String _likesRepo = 'likes';
  static const String _feedBackRoundsRepo = 'feedBackRoundText';
  static const String _mediasRepo = 'media';
  static const String _feedsRepo = 'feeds';
  static const String _commentsRepo = 'comments';

  final Uuid _uuid;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  final Kooza _kooza;
  final Duration _ttl;

  ConverseRepositoryFirestore({
    required Uuid uuid,
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required Kooza kooza,
    required Duration ttl,
  })  : _uuid = uuid,
        _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _kooza = kooza,
        _ttl = ttl;

  @override
  Future<void> setUpConverse(Map<String, dynamic> request) {
    throw UnimplementedError();
  }

  @override
  String generateRandomId() {
    try {
      return _uuid.v4().replaceAll('-', '');
    } catch (e) {
      throw 'FailedGeneratingId';
    }
  }

  @override
  Future<ConverseUser> fetchCurrentUserInfo() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw 'NoCurrentUser';
      if (user.uid.isEmpty) throw 'NoCurrentUserId';

      final token = await user.getIdTokenResult();
      CurrentRole? role;
      if (token.claims != null) {
        role = CurrentRole.fromMap(token.claims, user.uid, false);
      }

      final koozaRef = _kooza.collection('${_usersRepo}1').doc(user.uid);
      final koozDoc = await koozaRef.get();
      if (koozDoc.exists) {
        final newUser = ConverseUser.fromMap(koozDoc.data, koozDoc.id, false);
        return newUser.copyWith(id: user.uid, role: role);
      }

      final doc = await _firestore.collection(_usersRepo).doc(user.uid).get();
      if (!doc.exists) throw 'NoCurrentUserInfo';

      final newUser = ConverseUser.fromMap(doc.data(), doc.id, true);
      await koozaRef.set(newUser.toMap(false), ttl: _ttl);

      return newUser.copyWith(id: user.uid, role: role);
    } catch (e) {
      if (e == 'NoCurrentUser') rethrow;
      if (e == 'NoCurrentUserId') rethrow;
      if (e == 'NoCurrentUserInfo') rethrow;
      throw 'FailedFetchingUserInfo';
    }
  }

  @override
  Future<void> updateUserInfo(ConverseUser info) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw 'NoCurrentUser';
      if (user.uid.isEmpty) throw 'NoCurrentUserId';

      final koozaRef = _kooza.collection('${_usersRepo}1').doc(user.uid);
      await koozaRef.set(info.toMap(false), ttl: _ttl);

      final fsRef = _firestore.collection(_usersRepo).doc(user.uid);
      await fsRef.update(info.toMap(true));

      return;
    } catch (e) {
      if (e == 'NoCurrentUser') rethrow;
      if (e == 'NoCurrentUserId') rethrow;
      throw 'FailedUpdatingUserInfo';
    }
  }

  @override
  Future<void> saveSettings({
    required String businessId,
    String idSuffix = 'iam',
    required ConverseSettings settings,
  }) async {
    try {
      final docId = '${businessId}__$idSuffix';
      final repoRef = _firestore.collection(_settingsRepo).doc(docId);
      await repoRef.set(settings.toMap(true));
    } catch (e) {
      if (kDebugMode) {
        print('FailedSavingConverseSettings: $e');
      }
      throw 'FailedSavingConverseSettings';
    }
  }

  @override
  Stream<ConverseSettings> streamSettings(
    String businessId, [
    String idSuffix = 'converse',
  ]) {
    final docId = '${businessId}__$idSuffix';
    final repoRef = _firestore.collection(_settingsRepo).doc(docId);
    return repoRef.snapshots().map((e) {
      return ConverseSettings.fromMap(e.data(), e.id, true);
    }).handleError((e) {
      throw 'FailedStreamingConverseSettings';
    });
  }

  @override
  Future<ConverseSettings> fetchSettings(
    String businessId, [
    String idSuffix = 'converse',
  ]) async {
    try {
      final docId = '${businessId}__$idSuffix';
      final repoRef = _firestore.collection(_settingsRepo).doc(docId);
      final doc = await repoRef.get();
      return ConverseSettings.fromMap(doc.data(), doc.id, true);
    } catch (e) {
      if (kDebugMode) {
        print('FailedFetchingConverseSettings: $e');
      }
      throw 'FailedFetchingConverseSettings';
    }
  }

  @override
  Future<void> saveStats({
    required String businessId,
    String idSuffix = 'iam',
    required ConverseStats stats,
  }) async {
    try {
      final docId = '${businessId}__$idSuffix';
      final repoRef = _firestore.collection(_statsRepo).doc(docId);
      await repoRef.set(stats.toMap(true));
    } catch (e) {
      if (kDebugMode) {
        print('FailedSavingConverseStats: $e');
      }
      throw 'FailedSavingConverseStats';
    }
  }

  @override
  Stream<ConverseStats> streamStats(
    String businessId, [
    String idSuffix = 'converse',
  ]) {
    final docId = '${businessId}__$idSuffix';
    final repoRef = _firestore.collection(_statsRepo).doc(docId);
    return repoRef.snapshots().map((e) {
      return ConverseStats.fromMap(e.data(), e.id, true);
    }).handleError((e) {
      throw 'FailedStreamingConverseStats';
    });
  }

  @override
  Future<ConverseStats> fetchStats(
    String businessId, [
    String idSuffix = 'converse',
  ]) async {
    try {
      final docId = '${businessId}__$idSuffix';
      final repoRef = _firestore.collection(_statsRepo).doc(docId);
      final doc = await repoRef.get();
      return ConverseStats.fromMap(doc.data(), doc.id, true);
    } catch (e) {
      if (kDebugMode) {
        print('FailedFetchingConverseStats: $e');
      }
      throw 'FailedFetchingConverseStats';
    }
  }

  @override
  Future<String> createLike(Like like) async {
    try {
      // Add to firestore
      final ref = _firestore.collection(_likesRepo).doc();
      await ref.set(like.copyWith(id: ref.id).toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_likesRepo).doc(ref.id);
      // await cache.set(like.copyWith(id:ref.id).toMap(false), ttl: _ttl);

      return ref.id;
    } catch (e) {
      if (kDebugMode) print('FsCreateLike: $e');
      throw 'FsCreateLike';
    }
  }

  @override
  Future<void> createLikeWithId(String id, Like like) async {
    try {
      // Add to firestore
      final ref = _firestore.collection(_likesRepo).doc(id);
      await ref.set(like.copyWith(id: ref.id).toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_likesRepo).doc(ref.id);
      // await cache.set(like.copyWith(id: ref.id).toMap(false), ttl: _ttl);

      return;
    } catch (e) {
      if (kDebugMode) print('FsCreateLikeWithId: $e');
      throw 'FsCreateLikeWithId';
    }
  }

  @override
  Future<void> createLikes(List<Like> likes) async {
    try {
      if (likes.isEmpty) {
        throw 'NoLikesToCreate';
      }

      final creationsCount = likes.length;
      if (creationsCount <= 500) {
        final batch = _firestore.batch();
        for (var like in likes) {
          final doc = _firestore.collection(_likesRepo).doc();
          batch.set(doc, like.copyWith(id: doc.id).toMap(true));
        }
        await batch.commit();
        return;
      }

      final batchCount = (creationsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var like in likes) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_likesRepo).doc();
        batches[batchIndex].set(doc, like.copyWith(id: doc.id).toMap(true));
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (kDebugMode) {
        print('FailedCreatingLikes: $e');
      }
      if (e == 'NoLikesToCreate') rethrow;
      throw 'FailedCreatingLikes';
    }
  }

  @override
  Stream<Like> streamLike(String likeId) /* async* */ {
    // try {
    // final cache = _kooza.collection(_likesRepo).doc(likeId);
    // if (!(await cache.exists())) {
    //   if (kDebugMode) print('Streaming Like from FS');
    //   final ref = _firestore.collection(_likesRepo).doc(likeId);

    //   yield* ref.snapshots().asyncMap((doc) async {
    //     final like = Like.fromMap(doc.data(), doc.id, true);

    //     // Add to cache
    //     final newId = like.id;
    //     if (newId == null) return like;

    //     final cache = _kooza.collection(_likesRepo).doc(newId);
    //     await cache.set(like.toMap(false), ttl: _ttl);

    //     return like;
    //   }).handleError((e) {
    //     if (kDebugMode) print('FsStreamLike: $e');
    //     throw 'FsStreamLike';
    //   });
    // }

    //   if (await cache.exists()) {
    //     if (kDebugMode) print('Streaming Like from Kooza');
    //     yield* cache.snapshots().map((doc) => Like.fromMap(doc.data, doc.id, false)).handleError((e) {
    //       if (kDebugMode) {print('KOOZA_STREAM_Like: $e');}
    //       throw 'KoozaStreamLike';
    //     });
    //   }
// } catch (e) {
//   if (kDebugMode) print('FsStreamLike: $e');
//   throw 'FsStreamLike';
// }

    final ref = _firestore.collection(_likesRepo).doc(likeId);
    return ref
        .snapshots()
        .map((doc) => Like.fromMap(doc.data(), doc.id, true))
        .handleError((e) {
      if (kDebugMode) print('FsStreamLike: $e');
      throw 'FsStreamLike';
    });
  }

  @override
  Stream<GetListResponse<Like>> streamLikes(GetListRequest req) async* {
    try {
      final repo = _firestore.collection(_likesRepo);
      Query<Map<String, dynamic>>? query;
      DocumentSnapshot? lastDoc;
      int? totalDocsCount;

      if (req.lastQueriedId != null) {
        lastDoc = await repo.doc(req.lastQueriedId).get();
      }

      req.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      req.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      req.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      req.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      req.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      req.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      req.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });

      if (req.searchTag != null && query == null) {
        query = repo.where('searchTags', arrayContains: req.searchTag);
      } else if (req.searchTag != null && query != null) {
        query = query!.where('searchTags', arrayContains: req.searchTag);
      }

      // Count the queried documents
      if (!req.isTotalCounted) {
        if (query == null) {
          final aggregations = await repo.count().get();
          totalDocsCount = aggregations.count;
        } else {
          final aggregations = await query!.count().get();
          totalDocsCount = aggregations.count;
        }
      }

      req.orderBy.forEach((key, isDescending) {
        if (query == null) {
          query = repo.orderBy(key, descending: isDescending);
        } else {
          query = query!.orderBy(key, descending: isDescending);
        }
      });

      if (req.lastQueriedId != null && lastDoc != null) {
        if (query == null) {
          query = repo.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        } else {
          query = query!.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      } else {
        if (query == null) {
          if (req.limit != null) query = repo.limit(req.limit!);
        } else {
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      }

      yield* query!
          .snapshots()
          .map((q) =>
              q.docs.map((e) => Like.fromMap(e.data(), e.id, true)).toList())
          .map((e) =>
              GetListResponse<Like>(entities: e, totalCount: totalDocsCount))
          .handleError((e) {
        if (kDebugMode) print('FS_STREAM_Likes: $e');
        throw 'FS_STREAM_Likes';
      });
    } catch (e) {
      if (kDebugMode) print('FS_STREAM_Likes: $e');
      throw 'FS_STREAM_Likes';
    }
  }

  @override
  Future<Like> fetchLike(String likeId) async {
    try {
      // final cache = _kooza.collection(_likesRepo).doc(likeId);
      // if (await cache.exists()) {
      //   if (kDebugMode) print('FETCHING_Like_FROM_KOOZA');
      //   final doc = await cache.get();
      //   return Like.fromMap(doc.data, doc.id, false);
      // }

      // if (kDebugMode) print('FETCHING_Like_FROM_REPO');
      final doc = await _firestore.collection(_likesRepo).doc(likeId).get();
      final like = Like.fromMap(doc.data(), doc.id, true);

      // final newLikeId = like.id;
      // if (newLikeId == null) return like;
      // final newCache = _kooza.collection(_likesRepo).doc(newLikeId);
      // await newCache.set(like.toMap(false), ttl: _ttl);

      return like;
    } catch (e) {
      if (kDebugMode) print('FS_FETCH_Like: $e');
      throw 'FS_FETCH_Like';
    }
  }

  @override
  Future<GetListResponse<Like>> fetchLikes(GetListRequest req) async {
    try {
      final repo = _firestore.collection(_likesRepo);
      Query<Map<String, dynamic>>? query;
      DocumentSnapshot? lastDoc;
      int? totalDocsCount;

      if (req.lastQueriedId != null) {
        lastDoc = await repo.doc(req.lastQueriedId).get();
      }

      req.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      req.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      req.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      req.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      req.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      req.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      req.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });

      if (req.searchTag != null && query == null) {
        query = repo.where('searchTags', arrayContains: req.searchTag);
      } else if (req.searchTag != null && query != null) {
        query = query!.where('searchTags', arrayContains: req.searchTag);
      }

      // Count the queried documents
      if (!req.isTotalCounted) {
        if (query == null) {
          final aggregations = await repo.count().get();
          totalDocsCount = aggregations.count;
        } else {
          final aggregations = await query!.count().get();
          totalDocsCount = aggregations.count;
        }
      }

      req.orderBy.forEach((key, isDescending) {
        if (query == null) {
          query = repo.orderBy(key, descending: isDescending);
        } else {
          query = query!.orderBy(key, descending: isDescending);
        }
      });

      if (req.lastQueriedId != null && lastDoc != null) {
        if (query == null) {
          query = repo.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        } else {
          query = query!.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      } else {
        if (query == null) {
          if (req.limit != null) query = repo.limit(req.limit!);
        } else {
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      }

      final result = await query!.get();
      return GetListResponse(
        totalCount: totalDocsCount,
        entities:
            result.docs.map((e) => Like.fromMap(e.data(), e.id, true)).toList(),
      );
    } catch (e) {
      if (kDebugMode) print('FS_FETCH_Likes: $e');
      throw 'FS_FETCH_Likes';
    }
  }

  @override
  Future<void> updateLike(Like like) async {
    try {
      final likeId = like.id;
      if (likeId == null) {
        throw 'FS_MODIFY_Like_EMPTY_ID';
      }

      // Add to Repo:
      final ref = _firestore.collection(_likesRepo).doc(likeId);
      await ref.update(like.toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_likesRepo).doc(likeId);
      // await cache.set(like.toMap(false), ttl: _ttl);
    } catch (e) {
      if (kDebugMode) print('FS_MODIFY_Like: $e');
      if (e == 'FS_MODIFY_Like_EMPTY_ID') rethrow;
      throw 'FS_MODIFY_Like';
    }
  }

  @override
  Future<void> updateLikes(List<Like> likes) async {
    try {
      if (likes.isEmpty) {
        throw 'NoLikesToCreate';
      }

      final creationsCount = likes.length;
      if (creationsCount <= 500) {
        final batch = _firestore.batch();
        for (var like in likes) {
          final doc = _firestore.collection(_likesRepo).doc(like.id);
          batch.update(doc, like.toMap(true));
        }
        await batch.commit();
        return;
      }

      final batchCount = (creationsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var like in likes) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_likesRepo).doc(like.id);
        batches[batchIndex].update(doc, like.toMap(true));
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (kDebugMode) {
        print('FailedCreatingLikes: $e');
      }
      if (e == 'NoLikesToCreate') rethrow;
      throw 'FailedCreatingLikes';
    }
  }

  @override
  Future<void> deleteLike(String likeId) async {
    try {
      // Delete from Repo
      await _firestore.collection(_likesRepo).doc(likeId).delete();

      // Delete from cache
      await _kooza.collection(_likesRepo).doc(likeId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('FailedDeletingLike: $e');
      }
      throw 'FailedDeletingLike';
    }
  }

  @override
  Future<void> deleteLikes(List<String> ids) async {
    try {
      if (ids.isEmpty) throw 'NoneSelectedForDeletion';

      final deletionsCount = ids.length;
      if (deletionsCount <= 500) {
        final batch = _firestore.batch();
        for (var id in ids) {
          final ref = _firestore.collection(_likesRepo).doc(id);
          batch.delete(ref);
        }
        await batch.commit();
        return;
      }

      final batchCount = (deletionsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var id in ids) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_likesRepo).doc(id);
        batches[batchIndex].delete(doc);
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (e == 'NoneSelectedForDeletion') rethrow;
      if (kDebugMode) {
        print('FailedDeletingLikes: $e');
      }
      throw 'FailedDeletingLikes';
    }
  }

  @override
  Future<void> deleteAllLikes(Map<String, dynamic> isEqualToQueries) async {
    try {
      final int deletionsCount;
      QuerySnapshot<Map<String, dynamic>> toBeDeleted;
      final repoRef = _firestore.collection(_likesRepo);
      Query<Map<String, dynamic>>? query;

      if (isEqualToQueries.isNotEmpty) {
        isEqualToQueries.forEach((key, value) {
          if (query == null) {
            query = repoRef.where(key, isEqualTo: value);
          } else {
            query = query?.where(key, isEqualTo: value);
          }
        });
      }

      if (isEqualToQueries.isNotEmpty && query != null) {
        final aggregations = await query?.count().get();
        deletionsCount = aggregations?.count ?? 0;
      } else {
        final aggregations = await repoRef.count().get();
        deletionsCount = aggregations.count ?? 0;
      }

      if (isEqualToQueries.isNotEmpty && query != null) {
        toBeDeleted = await query!.get();
      } else {
        toBeDeleted = await repoRef.get();
      }

      if (deletionsCount <= 500) {
        final batch = _firestore.batch();
        for (var doc in toBeDeleted.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        return;
      }

      final batchCount = (deletionsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var doc in toBeDeleted.docs) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        batches[batchIndex].delete(doc.reference);
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }

      // await _kooza.collection(_likesRepo).delete();
    } catch (e) {
      if (kDebugMode) {
        print('FailedDeletingUserRoles: $e');
      }
      throw 'FailedDeletingUserRoles';
    }
  }

  @override
  Future<int> countLikes(CountRequest request) async {
    try {
      int totalDocsCount = 0;
      Query<Map<String, dynamic>>? query;
      final repo = _firestore.collection(_likesRepo);

      request.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      request.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      request.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      request.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      request.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      request.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      request.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });
      if (query == null) {
        final aggregations = await repo.count().get();
        totalDocsCount = aggregations.count ?? 0;
      } else {
        final aggregations = await query!.count().get();
        totalDocsCount = aggregations.count ?? 0;
      }

      return totalDocsCount;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> backUpLikes(List<Like> selected) async {
    try {
      if (selected.isEmpty) throw 'NoneSelectedForBackup';
      final date = DateTime.now();
      final dateStr = '${date.year}_${date.month}_${date.day}';
      final timeStr = '${date.hour}_${date.minute}_${date.second}';
      final fileName = 'Likes_${dateStr}_$timeStr';

      final jsonList = selected.map((e) => e.toMap(false)).toList();
      await _backUpEntities(fileName, jsonList);
      return;
    } catch (e) {
      if (e == 'NoneSelectedForBackup') rethrow;
      if (kDebugMode) {
        print('FailedBackUpLikes: $e');
      }
      throw 'FailedBackUpLikes';
    }
  }

  @override
  Future<void> backUpAllLikes(Map<String, dynamic> isEqualToQueries) async {
    try {
      final date = DateTime.now();
      final dateStr = '${date.year}_${date.month}_${date.day}';
      final timeStr = '${date.hour}_${date.minute}_${date.second}';
      final fileName = 'Likes_${dateStr}_$timeStr';
      final repoRef = _firestore.collection(_likesRepo);

      if (isEqualToQueries.isEmpty) {
        final docs = (await repoRef.get()).docs;
        final data =
            docs.map((e) => Like.fromMap(e.data(), e.id, true)).toList();
        await _backUpEntities(
            fileName, data.map((e) => e.toMap(false)).toList());
        return;
      }

      Query<Map<String, dynamic>>? query;
      isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repoRef.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      if (query != null) {
        final docs = (await query?.get())?.docs;
        final data =
            docs?.map((e) => Like.fromMap(e.data(), e.id, true)).toList();
        await _backUpEntities(
            fileName, data?.map((e) => e.toMap(false)).toList() ?? []);
      }
    } catch (e) {
      if (kDebugMode) {
        print('FS => Error Backing Up Likes: $e');
      }
      throw 'error-backing-up-Likes';
    }
  }

  @override
  Future<void> restoreLikes(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  ) async {
    try {
      final retrieved = await _restoreEntities();
      if (retrieved.isEmpty) throw 'NoneToRestore';

      final ref = _firestore.collection(_likesRepo);
      final upgraded = retrieved.map((e) => {...e, ...replacements});
      final entities =
          upgraded.map((e) => Like.fromMap(e, null, false)).toList();

      final changeUserId = replacements.containsKey('userId');
      final changeBusinessId = replacements.containsKey('businessId');
      if (changeUserId || changeBusinessId) {
        for (var entity in entities) {
          await ref.add(entity.toMap(true));
        }
        return;
      }

      if (mode == RestoreMode.keepBoth) {
        for (var entity in entities) {
          await ref.add(entity.toMap(true));
        }
        return;
      }

      if (mode == RestoreMode.merge) {
        for (var entity in entities) {
          if ((await ref.doc(entity.id).get()).exists) {
            await ref.doc(entity.id).update(entity.toMap(true));
          } else {
            await ref.add(entity.toMap(true));
          }
        }
        return;
      }

      if (mode == RestoreMode.replace) {
        for (var entity in entities) {
          await ref.doc(entity.id).set(entity.toMap(true));
        }
        return;
      }
    } catch (e) {
      if (e == 'NoneToRestore') rethrow;
      if (kDebugMode) print('FS_RESTORE_Likes: $e');
      throw 'FS_RESTORE_Likes';
    }
  }

  @override
  Future<String> createFeedBackRound(FeedBackRound feedBackRound) async {
    try {
      // Add to firestore
      final ref = _firestore.collection(_feedBackRoundsRepo).doc();
      await ref.set(feedBackRound.copyWith(id: ref.id).toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_feedBackRoundsRepo).doc(ref.id);
      // await cache.set(feedBackRound.copyWith(id:ref.id).toMap(false), ttl: _ttl);

      return ref.id;
    } catch (e) {
      if (kDebugMode) print('FsCreateFeedBackRound: $e');
      throw 'FsCreateFeedBackRound';
    }
  }

  @override
  Future<void> createFeedBackRoundWithId(
      String id, FeedBackRound feedBackRound) async {
    try {
      // Add to firestore
      final ref = _firestore.collection(_feedBackRoundsRepo).doc(id);
      await ref.set(feedBackRound.copyWith(id: ref.id).toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_feedBackRoundsRepo).doc(ref.id);
      // await cache.set(feedBackRound.copyWith(id: ref.id).toMap(false), ttl: _ttl);

      return;
    } catch (e) {
      if (kDebugMode) print('FsCreateFeedBackRoundWithId: $e');
      throw 'FsCreateFeedBackRoundWithId';
    }
  }

  @override
  Future<void> createFeedBackRounds(List<FeedBackRound> feedBackRounds) async {
    try {
      if (feedBackRounds.isEmpty) {
        throw 'NoFeedBackRoundsToCreate';
      }

      final creationsCount = feedBackRounds.length;
      if (creationsCount <= 500) {
        final batch = _firestore.batch();
        for (var feedBackRound in feedBackRounds) {
          final doc = _firestore.collection(_feedBackRoundsRepo).doc();
          batch.set(doc, feedBackRound.copyWith(id: doc.id).toMap(true));
        }
        await batch.commit();
        return;
      }

      final batchCount = (creationsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var feedBackRound in feedBackRounds) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_feedBackRoundsRepo).doc();
        batches[batchIndex]
            .set(doc, feedBackRound.copyWith(id: doc.id).toMap(true));
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (kDebugMode) {
        print('FailedCreatingFeedBackRounds: $e');
      }
      if (e == 'NoFeedBackRoundsToCreate') rethrow;
      throw 'FailedCreatingFeedBackRounds';
    }
  }

  @override
  Stream<FeedBackRound> streamFeedBackRound(
      String feedBackRoundId) /* async* */ {
    // try {
    // final cache = _kooza.collection(_feedBackRoundsRepo).doc(feedBackRoundId);
    // if (!(await cache.exists())) {
    //   if (kDebugMode) print('Streaming FeedBackRound from FS');
    //   final ref = _firestore.collection(_feedBackRoundsRepo).doc(feedBackRoundId);

    //   yield* ref.snapshots().asyncMap((doc) async {
    //     final feedBackRound = FeedBackRound.fromMap(doc.data(), doc.id, true);

    //     // Add to cache
    //     final newId = feedBackRound.id;
    //     if (newId == null) return feedBackRound;

    //     final cache = _kooza.collection(_feedBackRoundsRepo).doc(newId);
    //     await cache.set(feedBackRound.toMap(false), ttl: _ttl);

    //     return feedBackRound;
    //   }).handleError((e) {
    //     if (kDebugMode) print('FsStreamFeedBackRound: $e');
    //     throw 'FsStreamFeedBackRound';
    //   });
    // }

    //   if (await cache.exists()) {
    //     if (kDebugMode) print('Streaming FeedBackRound from Kooza');
    //     yield* cache.snapshots().map((doc) => FeedBackRound.fromMap(doc.data, doc.id, false)).handleError((e) {
    //       if (kDebugMode) {print('KOOZA_STREAM_FeedBackRound: $e');}
    //       throw 'KoozaStreamFeedBackRound';
    //     });
    //   }
// } catch (e) {
//   if (kDebugMode) print('FsStreamFeedBackRound: $e');
//   throw 'FsStreamFeedBackRound';
// }

    final ref = _firestore.collection(_feedBackRoundsRepo).doc(feedBackRoundId);
    return ref
        .snapshots()
        .map((doc) => FeedBackRound.fromMap(doc.data(), doc.id, true))
        .handleError((e) {
      if (kDebugMode) print('FsStreamFeedBackRound: $e');
      throw 'FsStreamFeedBackRound';
    });
  }

  @override
  Stream<GetListResponse<FeedBackRound>> streamFeedBackRounds(
      GetListRequest req) async* {
    try {
      final repo = _firestore.collection(_feedBackRoundsRepo);
      Query<Map<String, dynamic>>? query;
      DocumentSnapshot? lastDoc;
      int? totalDocsCount;

      if (req.lastQueriedId != null) {
        lastDoc = await repo.doc(req.lastQueriedId).get();
      }

      req.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      req.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      req.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      req.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      req.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      req.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      req.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });

      if (req.searchTag != null && query == null) {
        query = repo.where('searchTags', arrayContains: req.searchTag);
      } else if (req.searchTag != null && query != null) {
        query = query!.where('searchTags', arrayContains: req.searchTag);
      }

      // Count the queried documents
      if (!req.isTotalCounted) {
        if (query == null) {
          final aggregations = await repo.count().get();
          totalDocsCount = aggregations.count;
        } else {
          final aggregations = await query!.count().get();
          totalDocsCount = aggregations.count;
        }
      }

      req.orderBy.forEach((key, isDescending) {
        if (query == null) {
          query = repo.orderBy(key, descending: isDescending);
        } else {
          query = query!.orderBy(key, descending: isDescending);
        }
      });

      if (req.lastQueriedId != null && lastDoc != null) {
        if (query == null) {
          query = repo.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        } else {
          query = query!.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      } else {
        if (query == null) {
          if (req.limit != null) query = repo.limit(req.limit!);
        } else {
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      }

      yield* query!
          .snapshots()
          .map((q) => q.docs
              .map((e) => FeedBackRound.fromMap(e.data(), e.id, true))
              .toList())
          .map((e) => GetListResponse<FeedBackRound>(
              entities: e, totalCount: totalDocsCount))
          .handleError((e) {
        if (kDebugMode) print('FS_STREAM_FeedBackRounds: $e');
        throw 'FS_STREAM_FeedBackRounds';
      });
    } catch (e) {
      if (kDebugMode) print('FS_STREAM_FeedBackRounds: $e');
      throw 'FS_STREAM_FeedBackRounds';
    }
  }

  @override
  Future<FeedBackRound> fetchFeedBackRound(String feedBackRoundId) async {
    try {
      // final cache = _kooza.collection(_feedBackRoundsRepo).doc(feedBackRoundId);
      // if (await cache.exists()) {
      //   if (kDebugMode) print('FETCHING_FeedBackRound_FROM_KOOZA');
      //   final doc = await cache.get();
      //   return FeedBackRound.fromMap(doc.data, doc.id, false);
      // }

      // if (kDebugMode) print('FETCHING_FeedBackRound_FROM_REPO');
      final doc = await _firestore
          .collection(_feedBackRoundsRepo)
          .doc(feedBackRoundId)
          .get();
      final feedBackRound = FeedBackRound.fromMap(doc.data(), doc.id, true);

      // final newFeedBackRoundId = feedBackRound.id;
      // if (newFeedBackRoundId == null) return feedBackRound;
      // final newCache = _kooza.collection(_feedBackRoundsRepo).doc(newFeedBackRoundId);
      // await newCache.set(feedBackRound.toMap(false), ttl: _ttl);

      return feedBackRound;
    } catch (e) {
      if (kDebugMode) print('FS_FETCH_FeedBackRound: $e');
      throw 'FS_FETCH_FeedBackRound';
    }
  }

  @override
  Future<GetListResponse<FeedBackRound>> fetchFeedBackRounds(
      GetListRequest req) async {
    try {
      final repo = _firestore.collection(_feedBackRoundsRepo);
      Query<Map<String, dynamic>>? query;
      DocumentSnapshot? lastDoc;
      int? totalDocsCount;

      if (req.lastQueriedId != null) {
        lastDoc = await repo.doc(req.lastQueriedId).get();
      }

      req.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      req.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      req.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      req.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      req.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      req.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      req.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });

      if (req.searchTag != null && query == null) {
        query = repo.where('searchTags', arrayContains: req.searchTag);
      } else if (req.searchTag != null && query != null) {
        query = query!.where('searchTags', arrayContains: req.searchTag);
      }

      // Count the queried documents
      if (!req.isTotalCounted) {
        if (query == null) {
          final aggregations = await repo.count().get();
          totalDocsCount = aggregations.count;
        } else {
          final aggregations = await query!.count().get();
          totalDocsCount = aggregations.count;
        }
      }

      req.orderBy.forEach((key, isDescending) {
        if (query == null) {
          query = repo.orderBy(key, descending: isDescending);
        } else {
          query = query!.orderBy(key, descending: isDescending);
        }
      });

      if (req.lastQueriedId != null && lastDoc != null) {
        if (query == null) {
          query = repo.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        } else {
          query = query!.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      } else {
        if (query == null) {
          if (req.limit != null) query = repo.limit(req.limit!);
        } else {
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      }

      final result = await query!.get();
      return GetListResponse(
        totalCount: totalDocsCount,
        entities: result.docs
            .map((e) => FeedBackRound.fromMap(e.data(), e.id, true))
            .toList(),
      );
    } catch (e) {
      if (kDebugMode) print('FS_FETCH_FeedBackRounds: $e');
      throw 'FS_FETCH_FeedBackRounds';
    }
  }

  @override
  Future<void> updateFeedBackRound(FeedBackRound feedBackRound) async {
    try {
      final feedBackRoundId = feedBackRound.id;
      if (feedBackRoundId == null) {
        throw 'FS_MODIFY_FeedBackRound_EMPTY_ID';
      }

      // Add to Repo:
      final ref =
          _firestore.collection(_feedBackRoundsRepo).doc(feedBackRoundId);
      await ref.update(feedBackRound.toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_feedBackRoundsRepo).doc(feedBackRoundId);
      // await cache.set(feedBackRound.toMap(false), ttl: _ttl);
    } catch (e) {
      if (kDebugMode) print('FS_MODIFY_FeedBackRound: $e');
      if (e == 'FS_MODIFY_FeedBackRound_EMPTY_ID') rethrow;
      throw 'FS_MODIFY_FeedBackRound';
    }
  }

  @override
  Future<void> updateFeedBackRounds(List<FeedBackRound> feedBackRounds) async {
    try {
      if (feedBackRounds.isEmpty) {
        throw 'NoFeedBackRoundsToCreate';
      }

      final creationsCount = feedBackRounds.length;
      if (creationsCount <= 500) {
        final batch = _firestore.batch();
        for (var feedBackRound in feedBackRounds) {
          final doc =
              _firestore.collection(_feedBackRoundsRepo).doc(feedBackRound.id);
          batch.update(doc, feedBackRound.toMap(true));
        }
        await batch.commit();
        return;
      }

      final batchCount = (creationsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var feedBackRound in feedBackRounds) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc =
            _firestore.collection(_feedBackRoundsRepo).doc(feedBackRound.id);
        batches[batchIndex].update(doc, feedBackRound.toMap(true));
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (kDebugMode) {
        print('FailedCreatingFeedBackRounds: $e');
      }
      if (e == 'NoFeedBackRoundsToCreate') rethrow;
      throw 'FailedCreatingFeedBackRounds';
    }
  }

  @override
  Future<void> deleteFeedBackRound(String feedBackRoundId) async {
    try {
      // Delete from Repo
      await _firestore
          .collection(_feedBackRoundsRepo)
          .doc(feedBackRoundId)
          .delete();

      // Delete from cache
      await _kooza
          .collection(_feedBackRoundsRepo)
          .doc(feedBackRoundId)
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print('FailedDeletingFeedBackRound: $e');
      }
      throw 'FailedDeletingFeedBackRound';
    }
  }

  @override
  Future<void> deleteFeedBackRounds(List<String> ids) async {
    try {
      if (ids.isEmpty) throw 'NoneSelectedForDeletion';

      final deletionsCount = ids.length;
      if (deletionsCount <= 500) {
        final batch = _firestore.batch();
        for (var id in ids) {
          final ref = _firestore.collection(_feedBackRoundsRepo).doc(id);
          batch.delete(ref);
        }
        await batch.commit();
        return;
      }

      final batchCount = (deletionsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var id in ids) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_feedBackRoundsRepo).doc(id);
        batches[batchIndex].delete(doc);
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (e == 'NoneSelectedForDeletion') rethrow;
      if (kDebugMode) {
        print('FailedDeletingFeedBackRounds: $e');
      }
      throw 'FailedDeletingFeedBackRounds';
    }
  }

  @override
  Future<void> deleteAllFeedBackRounds(
      Map<String, dynamic> isEqualToQueries) async {
    try {
      final int deletionsCount;
      QuerySnapshot<Map<String, dynamic>> toBeDeleted;
      final repoRef = _firestore.collection(_feedBackRoundsRepo);
      Query<Map<String, dynamic>>? query;

      if (isEqualToQueries.isNotEmpty) {
        isEqualToQueries.forEach((key, value) {
          if (query == null) {
            query = repoRef.where(key, isEqualTo: value);
          } else {
            query = query?.where(key, isEqualTo: value);
          }
        });
      }

      if (isEqualToQueries.isNotEmpty && query != null) {
        final aggregations = await query?.count().get();
        deletionsCount = aggregations?.count ?? 0;
      } else {
        final aggregations = await repoRef.count().get();
        deletionsCount = aggregations.count ?? 0;
      }

      if (isEqualToQueries.isNotEmpty && query != null) {
        toBeDeleted = await query!.get();
      } else {
        toBeDeleted = await repoRef.get();
      }

      if (deletionsCount <= 500) {
        final batch = _firestore.batch();
        for (var doc in toBeDeleted.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        return;
      }

      final batchCount = (deletionsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var doc in toBeDeleted.docs) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        batches[batchIndex].delete(doc.reference);
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }

      // await _kooza.collection(_feedBackRoundsRepo).delete();
    } catch (e) {
      if (kDebugMode) {
        print('FailedDeletingUserRoles: $e');
      }
      throw 'FailedDeletingUserRoles';
    }
  }

  @override
  Future<int> countFeedBackRounds(CountRequest request) async {
    try {
      int totalDocsCount = 0;
      Query<Map<String, dynamic>>? query;
      final repo = _firestore.collection(_feedBackRoundsRepo);

      request.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      request.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      request.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      request.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      request.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      request.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      request.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });
      if (query == null) {
        final aggregations = await repo.count().get();
        totalDocsCount = aggregations.count ?? 0;
      } else {
        final aggregations = await query!.count().get();
        totalDocsCount = aggregations.count ?? 0;
      }

      return totalDocsCount;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> backUpFeedBackRounds(List<FeedBackRound> selected) async {
    try {
      if (selected.isEmpty) throw 'NoneSelectedForBackup';
      final date = DateTime.now();
      final dateStr = '${date.year}_${date.month}_${date.day}';
      final timeStr = '${date.hour}_${date.minute}_${date.second}';
      final fileName = 'FeedBackRounds_${dateStr}_$timeStr';

      final jsonList = selected.map((e) => e.toMap(false)).toList();
      await _backUpEntities(fileName, jsonList);
      return;
    } catch (e) {
      if (e == 'NoneSelectedForBackup') rethrow;
      if (kDebugMode) {
        print('FailedBackUpFeedBackRounds: $e');
      }
      throw 'FailedBackUpFeedBackRounds';
    }
  }

  @override
  Future<void> backUpAllFeedBackRounds(
      Map<String, dynamic> isEqualToQueries) async {
    try {
      final date = DateTime.now();
      final dateStr = '${date.year}_${date.month}_${date.day}';
      final timeStr = '${date.hour}_${date.minute}_${date.second}';
      final fileName = 'FeedBackRounds_${dateStr}_$timeStr';
      final repoRef = _firestore.collection(_feedBackRoundsRepo);

      if (isEqualToQueries.isEmpty) {
        final docs = (await repoRef.get()).docs;
        final data = docs
            .map((e) => FeedBackRound.fromMap(e.data(), e.id, true))
            .toList();
        await _backUpEntities(
            fileName, data.map((e) => e.toMap(false)).toList());
        return;
      }

      Query<Map<String, dynamic>>? query;
      isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repoRef.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      if (query != null) {
        final docs = (await query?.get())?.docs;
        final data = docs
            ?.map((e) => FeedBackRound.fromMap(e.data(), e.id, true))
            .toList();
        await _backUpEntities(
            fileName, data?.map((e) => e.toMap(false)).toList() ?? []);
      }
    } catch (e) {
      if (kDebugMode) {
        print('FS => Error Backing Up FeedBackRounds: $e');
      }
      throw 'error-backing-up-FeedBackRounds';
    }
  }

  @override
  Future<void> restoreFeedBackRounds(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  ) async {
    try {
      final retrieved = await _restoreEntities();
      if (retrieved.isEmpty) throw 'NoneToRestore';

      final ref = _firestore.collection(_feedBackRoundsRepo);
      final upgraded = retrieved.map((e) => {...e, ...replacements});
      final entities =
          upgraded.map((e) => FeedBackRound.fromMap(e, null, false)).toList();

      final changeUserId = replacements.containsKey('userId');
      final changeBusinessId = replacements.containsKey('businessId');
      if (changeUserId || changeBusinessId) {
        for (var entity in entities) {
          await ref.add(entity.toMap(true));
        }
        return;
      }

      if (mode == RestoreMode.keepBoth) {
        for (var entity in entities) {
          await ref.add(entity.toMap(true));
        }
        return;
      }

      if (mode == RestoreMode.merge) {
        for (var entity in entities) {
          if ((await ref.doc(entity.id).get()).exists) {
            await ref.doc(entity.id).update(entity.toMap(true));
          } else {
            await ref.add(entity.toMap(true));
          }
        }
        return;
      }

      if (mode == RestoreMode.replace) {
        for (var entity in entities) {
          await ref.doc(entity.id).set(entity.toMap(true));
        }
        return;
      }
    } catch (e) {
      if (e == 'NoneToRestore') rethrow;
      if (kDebugMode) print('FS_RESTORE_FeedBackRounds: $e');
      throw 'FS_RESTORE_FeedBackRounds';
    }
  }

  @override
  Future<String> createMedia(Media media) async {
    try {
      // Add to firestore
      final ref = _firestore.collection(_mediasRepo).doc();
      await ref.set(media.copyWith(id: ref.id).toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_mediasRepo).doc(ref.id);
      // await cache.set(media.copyWith(id:ref.id).toMap(false), ttl: _ttl);

      return ref.id;
    } catch (e) {
      if (kDebugMode) print('FsCreateMedia: $e');
      throw 'FsCreateMedia';
    }
  }

  @override
  Future<void> createMediaWithId(String id, Media media) async {
    try {
      // Add to firestore
      final ref = _firestore.collection(_mediasRepo).doc(id);
      await ref.set(media.copyWith(id: ref.id).toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_mediasRepo).doc(ref.id);
      // await cache.set(media.copyWith(id: ref.id).toMap(false), ttl: _ttl);

      return;
    } catch (e) {
      if (kDebugMode) print('FsCreateMediaWithId: $e');
      throw 'FsCreateMediaWithId';
    }
  }

  @override
  Future<void> createMedias(List<Media> medias) async {
    try {
      if (medias.isEmpty) {
        throw 'NoMediasToCreate';
      }

      final creationsCount = medias.length;
      if (creationsCount <= 500) {
        final batch = _firestore.batch();
        for (var media in medias) {
          final doc = _firestore.collection(_mediasRepo).doc();
          batch.set(doc, media.copyWith(id: doc.id).toMap(true));
        }
        await batch.commit();
        return;
      }

      final batchCount = (creationsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var media in medias) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_mediasRepo).doc();
        batches[batchIndex].set(doc, media.copyWith(id: doc.id).toMap(true));
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (kDebugMode) {
        print('FailedCreatingMedias: $e');
      }
      if (e == 'NoMediasToCreate') rethrow;
      throw 'FailedCreatingMedias';
    }
  }

  @override
  Stream<Media> streamMedia(String mediaId) /* async* */ {
    // try {
    // final cache = _kooza.collection(_mediasRepo).doc(mediaId);
    // if (!(await cache.exists())) {
    //   if (kDebugMode) print('Streaming Media from FS');
    //   final ref = _firestore.collection(_mediasRepo).doc(mediaId);

    //   yield* ref.snapshots().asyncMap((doc) async {
    //     final media = Media.fromMap(doc.data(), doc.id, true);

    //     // Add to cache
    //     final newId = media.id;
    //     if (newId == null) return media;

    //     final cache = _kooza.collection(_mediasRepo).doc(newId);
    //     await cache.set(media.toMap(false), ttl: _ttl);

    //     return media;
    //   }).handleError((e) {
    //     if (kDebugMode) print('FsStreamMedia: $e');
    //     throw 'FsStreamMedia';
    //   });
    // }

    //   if (await cache.exists()) {
    //     if (kDebugMode) print('Streaming Media from Kooza');
    //     yield* cache.snapshots().map((doc) => Media.fromMap(doc.data, doc.id, false)).handleError((e) {
    //       if (kDebugMode) {print('KOOZA_STREAM_Media: $e');}
    //       throw 'KoozaStreamMedia';
    //     });
    //   }
// } catch (e) {
//   if (kDebugMode) print('FsStreamMedia: $e');
//   throw 'FsStreamMedia';
// }

    final ref = _firestore.collection(_mediasRepo).doc(mediaId);
    return ref
        .snapshots()
        .map((doc) => Media.fromMap(doc.data(), doc.id, true))
        .handleError((e) {
      if (kDebugMode) print('FsStreamMedia: $e');
      throw 'FsStreamMedia';
    });
  }

  @override
  Stream<GetListResponse<Media>> streamMedias(GetListRequest req) async* {
    try {
      final repo = _firestore.collection(_mediasRepo);
      Query<Map<String, dynamic>>? query;
      DocumentSnapshot? lastDoc;
      int? totalDocsCount;

      if (req.lastQueriedId != null) {
        lastDoc = await repo.doc(req.lastQueriedId).get();
      }

      req.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      req.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      req.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      req.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      req.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      req.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      req.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });

      if (req.searchTag != null && query == null) {
        query = repo.where('searchTags', arrayContains: req.searchTag);
      } else if (req.searchTag != null && query != null) {
        query = query!.where('searchTags', arrayContains: req.searchTag);
      }

      // Count the queried documents
      if (!req.isTotalCounted) {
        if (query == null) {
          final aggregations = await repo.count().get();
          totalDocsCount = aggregations.count;
        } else {
          final aggregations = await query!.count().get();
          totalDocsCount = aggregations.count;
        }
      }

      req.orderBy.forEach((key, isDescending) {
        if (query == null) {
          query = repo.orderBy(key, descending: isDescending);
        } else {
          query = query!.orderBy(key, descending: isDescending);
        }
      });

      if (req.lastQueriedId != null && lastDoc != null) {
        if (query == null) {
          query = repo.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        } else {
          query = query!.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      } else {
        if (query == null) {
          if (req.limit != null) query = repo.limit(req.limit!);
        } else {
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      }

      yield* query!
          .snapshots()
          .map((q) =>
              q.docs.map((e) => Media.fromMap(e.data(), e.id, true)).toList())
          .map((e) =>
              GetListResponse<Media>(entities: e, totalCount: totalDocsCount))
          .handleError((e) {
        if (kDebugMode) print('FS_STREAM_Medias: $e');
        throw 'FS_STREAM_Medias';
      });
    } catch (e) {
      if (kDebugMode) print('FS_STREAM_Medias: $e');
      throw 'FS_STREAM_Medias';
    }
  }

  @override
  Future<Media> fetchMedia(String mediaId) async {
    try {
      // final cache = _kooza.collection(_mediasRepo).doc(mediaId);
      // if (await cache.exists()) {
      //   if (kDebugMode) print('FETCHING_Media_FROM_KOOZA');
      //   final doc = await cache.get();
      //   return Media.fromMap(doc.data, doc.id, false);
      // }

      // if (kDebugMode) print('FETCHING_Media_FROM_REPO');
      final doc = await _firestore.collection(_mediasRepo).doc(mediaId).get();
      final media = Media.fromMap(doc.data(), doc.id, true);

      // final newMediaId = media.id;
      // if (newMediaId == null) return media;
      // final newCache = _kooza.collection(_mediasRepo).doc(newMediaId);
      // await newCache.set(media.toMap(false), ttl: _ttl);

      return media;
    } catch (e) {
      if (kDebugMode) print('FS_FETCH_Media: $e');
      throw 'FS_FETCH_Media';
    }
  }

  @override
  Future<GetListResponse<Media>> fetchMedias(GetListRequest req) async {
    try {
      final repo = _firestore.collection(_mediasRepo);
      Query<Map<String, dynamic>>? query;
      DocumentSnapshot? lastDoc;
      int? totalDocsCount;

      if (req.lastQueriedId != null) {
        lastDoc = await repo.doc(req.lastQueriedId).get();
      }

      req.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      req.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      req.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      req.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      req.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      req.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      req.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });

      if (req.searchTag != null && query == null) {
        query = repo.where('searchTags', arrayContains: req.searchTag);
      } else if (req.searchTag != null && query != null) {
        query = query!.where('searchTags', arrayContains: req.searchTag);
      }

      // Count the queried documents
      if (!req.isTotalCounted) {
        if (query == null) {
          final aggregations = await repo.count().get();
          totalDocsCount = aggregations.count;
        } else {
          final aggregations = await query!.count().get();
          totalDocsCount = aggregations.count;
        }
      }

      req.orderBy.forEach((key, isDescending) {
        if (query == null) {
          query = repo.orderBy(key, descending: isDescending);
        } else {
          query = query!.orderBy(key, descending: isDescending);
        }
      });

      if (req.lastQueriedId != null && lastDoc != null) {
        if (query == null) {
          query = repo.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        } else {
          query = query!.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      } else {
        if (query == null) {
          if (req.limit != null) query = repo.limit(req.limit!);
        } else {
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      }

      final result = await query!.get();
      return GetListResponse(
        totalCount: totalDocsCount,
        entities: result.docs
            .map((e) => Media.fromMap(e.data(), e.id, true))
            .toList(),
      );
    } catch (e) {
      if (kDebugMode) print('FS_FETCH_Medias: $e');
      throw 'FS_FETCH_Medias';
    }
  }

  @override
  Future<void> updateMedia(Media media) async {
    try {
      final mediaId = media.id;
      if (mediaId == null) {
        throw 'FS_MODIFY_Media_EMPTY_ID';
      }

      // Add to Repo:
      final ref = _firestore.collection(_mediasRepo).doc(mediaId);
      await ref.update(media.toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_mediasRepo).doc(mediaId);
      // await cache.set(media.toMap(false), ttl: _ttl);
    } catch (e) {
      if (kDebugMode) print('FS_MODIFY_Media: $e');
      if (e == 'FS_MODIFY_Media_EMPTY_ID') rethrow;
      throw 'FS_MODIFY_Media';
    }
  }

  @override
  Future<void> updateMedias(List<Media> medias) async {
    try {
      if (medias.isEmpty) {
        throw 'NoMediasToCreate';
      }

      final creationsCount = medias.length;
      if (creationsCount <= 500) {
        final batch = _firestore.batch();
        for (var media in medias) {
          final doc = _firestore.collection(_mediasRepo).doc(media.id);
          batch.update(doc, media.toMap(true));
        }
        await batch.commit();
        return;
      }

      final batchCount = (creationsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var media in medias) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_mediasRepo).doc(media.id);
        batches[batchIndex].update(doc, media.toMap(true));
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (kDebugMode) {
        print('FailedCreatingMedias: $e');
      }
      if (e == 'NoMediasToCreate') rethrow;
      throw 'FailedCreatingMedias';
    }
  }

  @override
  Future<void> deleteMedia(String mediaId) async {
    try {
      // Delete from Repo
      await _firestore.collection(_mediasRepo).doc(mediaId).delete();

      // Delete from cache
      await _kooza.collection(_mediasRepo).doc(mediaId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('FailedDeletingMedia: $e');
      }
      throw 'FailedDeletingMedia';
    }
  }

  @override
  Future<void> deleteMedias(List<String> ids) async {
    try {
      if (ids.isEmpty) throw 'NoneSelectedForDeletion';

      final deletionsCount = ids.length;
      if (deletionsCount <= 500) {
        final batch = _firestore.batch();
        for (var id in ids) {
          final ref = _firestore.collection(_mediasRepo).doc(id);
          batch.delete(ref);
        }
        await batch.commit();
        return;
      }

      final batchCount = (deletionsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var id in ids) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_mediasRepo).doc(id);
        batches[batchIndex].delete(doc);
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (e == 'NoneSelectedForDeletion') rethrow;
      if (kDebugMode) {
        print('FailedDeletingMedias: $e');
      }
      throw 'FailedDeletingMedias';
    }
  }

  @override
  Future<void> deleteAllMedias(Map<String, dynamic> isEqualToQueries) async {
    try {
      final int deletionsCount;
      QuerySnapshot<Map<String, dynamic>> toBeDeleted;
      final repoRef = _firestore.collection(_mediasRepo);
      Query<Map<String, dynamic>>? query;

      if (isEqualToQueries.isNotEmpty) {
        isEqualToQueries.forEach((key, value) {
          if (query == null) {
            query = repoRef.where(key, isEqualTo: value);
          } else {
            query = query?.where(key, isEqualTo: value);
          }
        });
      }

      if (isEqualToQueries.isNotEmpty && query != null) {
        final aggregations = await query?.count().get();
        deletionsCount = aggregations?.count ?? 0;
      } else {
        final aggregations = await repoRef.count().get();
        deletionsCount = aggregations.count ?? 0;
      }

      if (isEqualToQueries.isNotEmpty && query != null) {
        toBeDeleted = await query!.get();
      } else {
        toBeDeleted = await repoRef.get();
      }

      if (deletionsCount <= 500) {
        final batch = _firestore.batch();
        for (var doc in toBeDeleted.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        return;
      }

      final batchCount = (deletionsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var doc in toBeDeleted.docs) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        batches[batchIndex].delete(doc.reference);
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }

      // await _kooza.collection(_mediasRepo).delete();
    } catch (e) {
      if (kDebugMode) {
        print('FailedDeletingUserRoles: $e');
      }
      throw 'FailedDeletingUserRoles';
    }
  }

  @override
  Future<int> countMedias(CountRequest request) async {
    try {
      int totalDocsCount = 0;
      Query<Map<String, dynamic>>? query;
      final repo = _firestore.collection(_mediasRepo);

      request.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      request.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      request.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      request.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      request.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      request.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      request.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });
      if (query == null) {
        final aggregations = await repo.count().get();
        totalDocsCount = aggregations.count ?? 0;
      } else {
        final aggregations = await query!.count().get();
        totalDocsCount = aggregations.count ?? 0;
      }

      return totalDocsCount;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> backUpMedias(List<Media> selected) async {
    try {
      if (selected.isEmpty) throw 'NoneSelectedForBackup';
      final date = DateTime.now();
      final dateStr = '${date.year}_${date.month}_${date.day}';
      final timeStr = '${date.hour}_${date.minute}_${date.second}';
      final fileName = 'Medias_${dateStr}_$timeStr';

      final jsonList = selected.map((e) => e.toMap(false)).toList();
      await _backUpEntities(fileName, jsonList);
      return;
    } catch (e) {
      if (e == 'NoneSelectedForBackup') rethrow;
      if (kDebugMode) {
        print('FailedBackUpMedias: $e');
      }
      throw 'FailedBackUpMedias';
    }
  }

  @override
  Future<void> backUpAllMedias(Map<String, dynamic> isEqualToQueries) async {
    try {
      final date = DateTime.now();
      final dateStr = '${date.year}_${date.month}_${date.day}';
      final timeStr = '${date.hour}_${date.minute}_${date.second}';
      final fileName = 'Medias_${dateStr}_$timeStr';
      final repoRef = _firestore.collection(_mediasRepo);

      if (isEqualToQueries.isEmpty) {
        final docs = (await repoRef.get()).docs;
        final data =
            docs.map((e) => Media.fromMap(e.data(), e.id, true)).toList();
        await _backUpEntities(
            fileName, data.map((e) => e.toMap(false)).toList());
        return;
      }

      Query<Map<String, dynamic>>? query;
      isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repoRef.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      if (query != null) {
        final docs = (await query?.get())?.docs;
        final data =
            docs?.map((e) => Media.fromMap(e.data(), e.id, true)).toList();
        await _backUpEntities(
            fileName, data?.map((e) => e.toMap(false)).toList() ?? []);
      }
    } catch (e) {
      if (kDebugMode) {
        print('FS => Error Backing Up Medias: $e');
      }
      throw 'error-backing-up-Medias';
    }
  }

  @override
  Future<void> restoreMedias(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  ) async {
    try {
      final retrieved = await _restoreEntities();
      if (retrieved.isEmpty) throw 'NoneToRestore';

      final ref = _firestore.collection(_mediasRepo);
      final upgraded = retrieved.map((e) => {...e, ...replacements});
      final entities =
          upgraded.map((e) => Media.fromMap(e, null, false)).toList();

      final changeUserId = replacements.containsKey('userId');
      final changeBusinessId = replacements.containsKey('businessId');
      if (changeUserId || changeBusinessId) {
        for (var entity in entities) {
          await ref.add(entity.toMap(true));
        }
        return;
      }

      if (mode == RestoreMode.keepBoth) {
        for (var entity in entities) {
          await ref.add(entity.toMap(true));
        }
        return;
      }

      if (mode == RestoreMode.merge) {
        for (var entity in entities) {
          if ((await ref.doc(entity.id).get()).exists) {
            await ref.doc(entity.id).update(entity.toMap(true));
          } else {
            await ref.add(entity.toMap(true));
          }
        }
        return;
      }

      if (mode == RestoreMode.replace) {
        for (var entity in entities) {
          await ref.doc(entity.id).set(entity.toMap(true));
        }
        return;
      }
    } catch (e) {
      if (e == 'NoneToRestore') rethrow;
      if (kDebugMode) print('FS_RESTORE_Medias: $e');
      throw 'FS_RESTORE_Medias';
    }
  }

  @override
  Future<String> createFeed(Feed feed) async {
    try {
      // Add to firestore
      final ref = _firestore.collection(_feedsRepo).doc();
      await ref.set(feed.copyWith(id: ref.id).toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_feedsRepo).doc(ref.id);
      // await cache.set(feed.copyWith(id:ref.id).toMap(false), ttl: _ttl);

      return ref.id;
    } catch (e) {
      if (kDebugMode) print('FsCreateFeed: $e');
      throw 'FsCreateFeed';
    }
  }

  @override
  Future<void> createFeedWithId(String id, Feed feed) async {
    try {
      // Add to firestore
      final ref = _firestore.collection(_feedsRepo).doc(id);
      await ref.set(feed.copyWith(id: ref.id).toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_feedsRepo).doc(ref.id);
      // await cache.set(feed.copyWith(id: ref.id).toMap(false), ttl: _ttl);

      return;
    } catch (e) {
      if (kDebugMode) print('FsCreateFeedWithId: $e');
      throw 'FsCreateFeedWithId';
    }
  }

  @override
  Future<void> createFeeds(List<Feed> feeds) async {
    try {
      if (feeds.isEmpty) {
        throw 'NoFeedsToCreate';
      }

      final creationsCount = feeds.length;
      if (creationsCount <= 500) {
        final batch = _firestore.batch();
        for (var feed in feeds) {
          final doc = _firestore.collection(_feedsRepo).doc();
          batch.set(doc, feed.copyWith(id: doc.id).toMap(true));
        }
        await batch.commit();
        return;
      }

      final batchCount = (creationsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var feed in feeds) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_feedsRepo).doc();
        batches[batchIndex].set(doc, feed.copyWith(id: doc.id).toMap(true));
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (kDebugMode) {
        print('FailedCreatingFeeds: $e');
      }
      if (e == 'NoFeedsToCreate') rethrow;
      throw 'FailedCreatingFeeds';
    }
  }

  @override
  Stream<Feed> streamFeed(String feedId) /* async* */ {
    // try {
    // final cache = _kooza.collection(_feedsRepo).doc(feedId);
    // if (!(await cache.exists())) {
    //   if (kDebugMode) print('Streaming Feed from FS');
    //   final ref = _firestore.collection(_feedsRepo).doc(feedId);

    //   yield* ref.snapshots().asyncMap((doc) async {
    //     final feed = Feed.fromMap(doc.data(), doc.id, true);

    //     // Add to cache
    //     final newId = feed.id;
    //     if (newId == null) return feed;

    //     final cache = _kooza.collection(_feedsRepo).doc(newId);
    //     await cache.set(feed.toMap(false), ttl: _ttl);

    //     return feed;
    //   }).handleError((e) {
    //     if (kDebugMode) print('FsStreamFeed: $e');
    //     throw 'FsStreamFeed';
    //   });
    // }

    //   if (await cache.exists()) {
    //     if (kDebugMode) print('Streaming Feed from Kooza');
    //     yield* cache.snapshots().map((doc) => Feed.fromMap(doc.data, doc.id, false)).handleError((e) {
    //       if (kDebugMode) {print('KOOZA_STREAM_Feed: $e');}
    //       throw 'KoozaStreamFeed';
    //     });
    //   }
// } catch (e) {
//   if (kDebugMode) print('FsStreamFeed: $e');
//   throw 'FsStreamFeed';
// }

    final ref = _firestore.collection(_feedsRepo).doc(feedId);
    return ref
        .snapshots()
        .map((doc) => Feed.fromMap(doc.data(), doc.id, true))
        .handleError((e) {
      if (kDebugMode) print('FsStreamFeed: $e');
      throw 'FsStreamFeed';
    });
  }

  @override
  Stream<GetListResponse<Feed>> streamFeeds(GetListRequest req) async* {
    try {
      final repo = _firestore.collection(_feedsRepo);
      Query<Map<String, dynamic>>? query;
      DocumentSnapshot? lastDoc;
      int? totalDocsCount;

      if (req.lastQueriedId != null) {
        lastDoc = await repo.doc(req.lastQueriedId).get();
      }

      req.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      req.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      req.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      req.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      req.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      req.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      req.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });

      if (req.searchTag != null && query == null) {
        query = repo.where('searchTags', arrayContains: req.searchTag);
      } else if (req.searchTag != null && query != null) {
        query = query!.where('searchTags', arrayContains: req.searchTag);
      }

      // Count the queried documents
      if (!req.isTotalCounted) {
        if (query == null) {
          final aggregations = await repo.count().get();
          totalDocsCount = aggregations.count;
        } else {
          final aggregations = await query!.count().get();
          totalDocsCount = aggregations.count;
        }
      }

      req.orderBy.forEach((key, isDescending) {
        if (query == null) {
          query = repo.orderBy(key, descending: isDescending);
        } else {
          query = query!.orderBy(key, descending: isDescending);
        }
      });

      if (req.lastQueriedId != null && lastDoc != null) {
        if (query == null) {
          query = repo.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        } else {
          query = query!.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      } else {
        if (query == null) {
          if (req.limit != null) query = repo.limit(req.limit!);
        } else {
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      }

      yield* query!
          .snapshots()
          .map((q) =>
              q.docs.map((e) => Feed.fromMap(e.data(), e.id, true)).toList())
          .map((e) =>
              GetListResponse<Feed>(entities: e, totalCount: totalDocsCount))
          .handleError((e) {
        if (kDebugMode) print('FS_STREAM_Feeds: $e');
        throw 'FS_STREAM_Feeds';
      });
    } catch (e) {
      if (kDebugMode) print('FS_STREAM_Feeds: $e');
      throw 'FS_STREAM_Feeds';
    }
  }

  @override
  Future<Feed> fetchFeed(String feedId) async {
    try {
      // final cache = _kooza.collection(_feedsRepo).doc(feedId);
      // if (await cache.exists()) {
      //   if (kDebugMode) print('FETCHING_Feed_FROM_KOOZA');
      //   final doc = await cache.get();
      //   return Feed.fromMap(doc.data, doc.id, false);
      // }

      // if (kDebugMode) print('FETCHING_Feed_FROM_REPO');
      final doc = await _firestore.collection(_feedsRepo).doc(feedId).get();
      final feed = Feed.fromMap(doc.data(), doc.id, true);

      // final newFeedId = feed.id;
      // if (newFeedId == null) return feed;
      // final newCache = _kooza.collection(_feedsRepo).doc(newFeedId);
      // await newCache.set(feed.toMap(false), ttl: _ttl);

      return feed;
    } catch (e) {
      if (kDebugMode) print('FS_FETCH_Feed: $e');
      throw 'FS_FETCH_Feed';
    }
  }

  @override
  Future<GetListResponse<Feed>> fetchFeeds(GetListRequest req) async {
    try {
      final repo = _firestore.collection(_feedsRepo);
      Query<Map<String, dynamic>>? query;
      DocumentSnapshot? lastDoc;
      int? totalDocsCount;

      if (req.lastQueriedId != null) {
        lastDoc = await repo.doc(req.lastQueriedId).get();
      }

      req.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      req.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      req.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      req.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      req.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      req.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      req.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });

      if (req.searchTag != null && query == null) {
        query = repo.where('searchTags', arrayContains: req.searchTag);
      } else if (req.searchTag != null && query != null) {
        query = query!.where('searchTags', arrayContains: req.searchTag);
      }

      // Count the queried documents
      if (!req.isTotalCounted) {
        if (query == null) {
          final aggregations = await repo.count().get();
          totalDocsCount = aggregations.count;
        } else {
          final aggregations = await query!.count().get();
          totalDocsCount = aggregations.count;
        }
      }

      req.orderBy.forEach((key, isDescending) {
        if (query == null) {
          query = repo.orderBy(key, descending: isDescending);
        } else {
          query = query!.orderBy(key, descending: isDescending);
        }
      });

      if (req.lastQueriedId != null && lastDoc != null) {
        if (query == null) {
          query = repo.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        } else {
          query = query!.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      } else {
        if (query == null) {
          if (req.limit != null) query = repo.limit(req.limit!);
        } else {
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      }

      final result = await query!.get();
      return GetListResponse(
        totalCount: totalDocsCount,
        entities:
            result.docs.map((e) => Feed.fromMap(e.data(), e.id, true)).toList(),
      );
    } catch (e) {
      if (kDebugMode) print('FS_FETCH_Feeds: $e');
      throw 'FS_FETCH_Feeds';
    }
  }

  @override
  Future<void> updateFeed(Feed feed) async {
    try {
      final feedId = feed.id;
      if (feedId == null) {
        throw 'FS_MODIFY_Feed_EMPTY_ID';
      }

      // Add to Repo:
      final ref = _firestore.collection(_feedsRepo).doc(feedId);
      await ref.update(feed.toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_feedsRepo).doc(feedId);
      // await cache.set(feed.toMap(false), ttl: _ttl);
    } catch (e) {
      if (kDebugMode) print('FS_MODIFY_Feed: $e');
      if (e == 'FS_MODIFY_Feed_EMPTY_ID') rethrow;
      throw 'FS_MODIFY_Feed';
    }
  }

  @override
  Future<void> updateFeeds(List<Feed> feeds) async {
    try {
      if (feeds.isEmpty) {
        throw 'NoFeedsToCreate';
      }

      final creationsCount = feeds.length;
      if (creationsCount <= 500) {
        final batch = _firestore.batch();
        for (var feed in feeds) {
          final doc = _firestore.collection(_feedsRepo).doc(feed.id);
          batch.update(doc, feed.toMap(true));
        }
        await batch.commit();
        return;
      }

      final batchCount = (creationsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var feed in feeds) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_feedsRepo).doc(feed.id);
        batches[batchIndex].update(doc, feed.toMap(true));
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (kDebugMode) {
        print('FailedCreatingFeeds: $e');
      }
      if (e == 'NoFeedsToCreate') rethrow;
      throw 'FailedCreatingFeeds';
    }
  }

  @override
  Future<void> deleteFeed(String feedId) async {
    try {
      // Delete from Repo
      await _firestore.collection(_feedsRepo).doc(feedId).delete();

      // Delete from cache
      await _kooza.collection(_feedsRepo).doc(feedId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('FailedDeletingFeed: $e');
      }
      throw 'FailedDeletingFeed';
    }
  }

  @override
  Future<void> deleteFeeds(List<String> ids) async {
    try {
      if (ids.isEmpty) throw 'NoneSelectedForDeletion';

      final deletionsCount = ids.length;
      if (deletionsCount <= 500) {
        final batch = _firestore.batch();
        for (var id in ids) {
          final ref = _firestore.collection(_feedsRepo).doc(id);
          batch.delete(ref);
        }
        await batch.commit();
        return;
      }

      final batchCount = (deletionsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var id in ids) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_feedsRepo).doc(id);
        batches[batchIndex].delete(doc);
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (e == 'NoneSelectedForDeletion') rethrow;
      if (kDebugMode) {
        print('FailedDeletingFeeds: $e');
      }
      throw 'FailedDeletingFeeds';
    }
  }

  @override
  Future<void> deleteAllFeeds(Map<String, dynamic> isEqualToQueries) async {
    try {
      final int deletionsCount;
      QuerySnapshot<Map<String, dynamic>> toBeDeleted;
      final repoRef = _firestore.collection(_feedsRepo);
      Query<Map<String, dynamic>>? query;

      if (isEqualToQueries.isNotEmpty) {
        isEqualToQueries.forEach((key, value) {
          if (query == null) {
            query = repoRef.where(key, isEqualTo: value);
          } else {
            query = query?.where(key, isEqualTo: value);
          }
        });
      }

      if (isEqualToQueries.isNotEmpty && query != null) {
        final aggregations = await query?.count().get();
        deletionsCount = aggregations?.count ?? 0;
      } else {
        final aggregations = await repoRef.count().get();
        deletionsCount = aggregations.count ?? 0;
      }

      if (isEqualToQueries.isNotEmpty && query != null) {
        toBeDeleted = await query!.get();
      } else {
        toBeDeleted = await repoRef.get();
      }

      if (deletionsCount <= 500) {
        final batch = _firestore.batch();
        for (var doc in toBeDeleted.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        return;
      }

      final batchCount = (deletionsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var doc in toBeDeleted.docs) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        batches[batchIndex].delete(doc.reference);
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }

      // await _kooza.collection(_feedsRepo).delete();
    } catch (e) {
      if (kDebugMode) {
        print('FailedDeletingUserRoles: $e');
      }
      throw 'FailedDeletingUserRoles';
    }
  }

  @override
  Future<int> countFeeds(CountRequest request) async {
    try {
      int totalDocsCount = 0;
      Query<Map<String, dynamic>>? query;
      final repo = _firestore.collection(_feedsRepo);

      request.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      request.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      request.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      request.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      request.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      request.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      request.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });
      if (query == null) {
        final aggregations = await repo.count().get();
        totalDocsCount = aggregations.count ?? 0;
      } else {
        final aggregations = await query!.count().get();
        totalDocsCount = aggregations.count ?? 0;
      }

      return totalDocsCount;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> backUpFeeds(List<Feed> selected) async {
    try {
      if (selected.isEmpty) throw 'NoneSelectedForBackup';
      final date = DateTime.now();
      final dateStr = '${date.year}_${date.month}_${date.day}';
      final timeStr = '${date.hour}_${date.minute}_${date.second}';
      final fileName = 'Feeds_${dateStr}_$timeStr';

      final jsonList = selected.map((e) => e.toMap(false)).toList();
      await _backUpEntities(fileName, jsonList);
      return;
    } catch (e) {
      if (e == 'NoneSelectedForBackup') rethrow;
      if (kDebugMode) {
        print('FailedBackUpFeeds: $e');
      }
      throw 'FailedBackUpFeeds';
    }
  }

  @override
  Future<void> backUpAllFeeds(Map<String, dynamic> isEqualToQueries) async {
    try {
      final date = DateTime.now();
      final dateStr = '${date.year}_${date.month}_${date.day}';
      final timeStr = '${date.hour}_${date.minute}_${date.second}';
      final fileName = 'Feeds_${dateStr}_$timeStr';
      final repoRef = _firestore.collection(_feedsRepo);

      if (isEqualToQueries.isEmpty) {
        final docs = (await repoRef.get()).docs;
        final data =
            docs.map((e) => Feed.fromMap(e.data(), e.id, true)).toList();
        await _backUpEntities(
            fileName, data.map((e) => e.toMap(false)).toList());
        return;
      }

      Query<Map<String, dynamic>>? query;
      isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repoRef.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      if (query != null) {
        final docs = (await query?.get())?.docs;
        final data =
            docs?.map((e) => Feed.fromMap(e.data(), e.id, true)).toList();
        await _backUpEntities(
            fileName, data?.map((e) => e.toMap(false)).toList() ?? []);
      }
    } catch (e) {
      if (kDebugMode) {
        print('FS => Error Backing Up Feeds: $e');
      }
      throw 'error-backing-up-Feeds';
    }
  }

  @override
  Future<void> restoreFeeds(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  ) async {
    try {
      final retrieved = await _restoreEntities();
      if (retrieved.isEmpty) throw 'NoneToRestore';

      final ref = _firestore.collection(_feedsRepo);
      final upgraded = retrieved.map((e) => {...e, ...replacements});
      final entities =
          upgraded.map((e) => Feed.fromMap(e, null, false)).toList();

      final changeUserId = replacements.containsKey('userId');
      final changeBusinessId = replacements.containsKey('businessId');
      if (changeUserId || changeBusinessId) {
        for (var entity in entities) {
          await ref.add(entity.toMap(true));
        }
        return;
      }

      if (mode == RestoreMode.keepBoth) {
        for (var entity in entities) {
          await ref.add(entity.toMap(true));
        }
        return;
      }

      if (mode == RestoreMode.merge) {
        for (var entity in entities) {
          if ((await ref.doc(entity.id).get()).exists) {
            await ref.doc(entity.id).update(entity.toMap(true));
          } else {
            await ref.add(entity.toMap(true));
          }
        }
        return;
      }

      if (mode == RestoreMode.replace) {
        for (var entity in entities) {
          await ref.doc(entity.id).set(entity.toMap(true));
        }
        return;
      }
    } catch (e) {
      if (e == 'NoneToRestore') rethrow;
      if (kDebugMode) print('FS_RESTORE_Feeds: $e');
      throw 'FS_RESTORE_Feeds';
    }
  }

  @override
  Future<String> createComment(Comment comment) async {
    try {
      // Add to firestore
      final ref = _firestore.collection(_commentsRepo).doc();
      await ref.set(comment.copyWith(id: ref.id).toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_commentsRepo).doc(ref.id);
      // await cache.set(comment.copyWith(id:ref.id).toMap(false), ttl: _ttl);

      return ref.id;
    } catch (e) {
      if (kDebugMode) print('FsCreateComment: $e');
      throw 'FsCreateComment';
    }
  }

  @override
  Future<void> createCommentWithId(String id, Comment comment) async {
    try {
      // Add to firestore
      final ref = _firestore.collection(_commentsRepo).doc(id);
      await ref.set(comment.copyWith(id: ref.id).toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_commentsRepo).doc(ref.id);
      // await cache.set(comment.copyWith(id: ref.id).toMap(false), ttl: _ttl);

      return;
    } catch (e) {
      if (kDebugMode) print('FsCreateCommentWithId: $e');
      throw 'FsCreateCommentWithId';
    }
  }

  @override
  Future<void> createComments(List<Comment> comments) async {
    try {
      if (comments.isEmpty) {
        throw 'NoCommentsToCreate';
      }

      final creationsCount = comments.length;
      if (creationsCount <= 500) {
        final batch = _firestore.batch();
        for (var comment in comments) {
          final doc = _firestore.collection(_commentsRepo).doc();
          batch.set(doc, comment.copyWith(id: doc.id).toMap(true));
        }
        await batch.commit();
        return;
      }

      final batchCount = (creationsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var comment in comments) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_commentsRepo).doc();
        batches[batchIndex].set(doc, comment.copyWith(id: doc.id).toMap(true));
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (kDebugMode) {
        print('FailedCreatingComments: $e');
      }
      if (e == 'NoCommentsToCreate') rethrow;
      throw 'FailedCreatingComments';
    }
  }

  @override
  Stream<Comment> streamComment(String commentId) /* async* */ {
    // try {
    // final cache = _kooza.collection(_commentsRepo).doc(commentId);
    // if (!(await cache.exists())) {
    //   if (kDebugMode) print('Streaming Comment from FS');
    //   final ref = _firestore.collection(_commentsRepo).doc(commentId);

    //   yield* ref.snapshots().asyncMap((doc) async {
    //     final comment = Comment.fromMap(doc.data(), doc.id, true);

    //     // Add to cache
    //     final newId = comment.id;
    //     if (newId == null) return comment;

    //     final cache = _kooza.collection(_commentsRepo).doc(newId);
    //     await cache.set(comment.toMap(false), ttl: _ttl);

    //     return comment;
    //   }).handleError((e) {
    //     if (kDebugMode) print('FsStreamComment: $e');
    //     throw 'FsStreamComment';
    //   });
    // }

    //   if (await cache.exists()) {
    //     if (kDebugMode) print('Streaming Comment from Kooza');
    //     yield* cache.snapshots().map((doc) => Comment.fromMap(doc.data, doc.id, false)).handleError((e) {
    //       if (kDebugMode) {print('KOOZA_STREAM_Comment: $e');}
    //       throw 'KoozaStreamComment';
    //     });
    //   }
// } catch (e) {
//   if (kDebugMode) print('FsStreamComment: $e');
//   throw 'FsStreamComment';
// }

    final ref = _firestore.collection(_commentsRepo).doc(commentId);
    return ref
        .snapshots()
        .map((doc) => Comment.fromMap(doc.data(), doc.id, true))
        .handleError((e) {
      if (kDebugMode) print('FsStreamComment: $e');
      throw 'FsStreamComment';
    });
  }

  @override
  Stream<GetListResponse<Comment>> streamComments(GetListRequest req) async* {
    try {
      final repo = _firestore.collection(_commentsRepo);
      Query<Map<String, dynamic>>? query;
      DocumentSnapshot? lastDoc;
      int? totalDocsCount;

      if (req.lastQueriedId != null) {
        lastDoc = await repo.doc(req.lastQueriedId).get();
      }

      req.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      req.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      req.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      req.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      req.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      req.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      req.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });

      if (req.searchTag != null && query == null) {
        query = repo.where('searchTags', arrayContains: req.searchTag);
      } else if (req.searchTag != null && query != null) {
        query = query!.where('searchTags', arrayContains: req.searchTag);
      }

      // Count the queried documents
      if (!req.isTotalCounted) {
        if (query == null) {
          final aggregations = await repo.count().get();
          totalDocsCount = aggregations.count;
        } else {
          final aggregations = await query!.count().get();
          totalDocsCount = aggregations.count;
        }
      }

      req.orderBy.forEach((key, isDescending) {
        if (query == null) {
          query = repo.orderBy(key, descending: isDescending);
        } else {
          query = query!.orderBy(key, descending: isDescending);
        }
      });

      if (req.lastQueriedId != null && lastDoc != null) {
        if (query == null) {
          query = repo.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        } else {
          query = query!.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      } else {
        if (query == null) {
          if (req.limit != null) query = repo.limit(req.limit!);
        } else {
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      }

      yield* query!
          .snapshots()
          .map((q) =>
              q.docs.map((e) => Comment.fromMap(e.data(), e.id, true)).toList())
          .map((e) =>
              GetListResponse<Comment>(entities: e, totalCount: totalDocsCount))
          .handleError((e) {
        if (kDebugMode) print('FS_STREAM_Comments: $e');
        throw 'FS_STREAM_Comments';
      });
    } catch (e) {
      if (kDebugMode) print('FS_STREAM_Comments: $e');
      throw 'FS_STREAM_Comments';
    }
  }

  @override
  Future<Comment> fetchComment(String commentId) async {
    try {
      // final cache = _kooza.collection(_commentsRepo).doc(commentId);
      // if (await cache.exists()) {
      //   if (kDebugMode) print('FETCHING_Comment_FROM_KOOZA');
      //   final doc = await cache.get();
      //   return Comment.fromMap(doc.data, doc.id, false);
      // }

      // if (kDebugMode) print('FETCHING_Comment_FROM_REPO');
      final doc =
          await _firestore.collection(_commentsRepo).doc(commentId).get();
      final comment = Comment.fromMap(doc.data(), doc.id, true);

      // final newCommentId = comment.id;
      // if (newCommentId == null) return comment;
      // final newCache = _kooza.collection(_commentsRepo).doc(newCommentId);
      // await newCache.set(comment.toMap(false), ttl: _ttl);

      return comment;
    } catch (e) {
      if (kDebugMode) print('FS_FETCH_Comment: $e');
      throw 'FS_FETCH_Comment';
    }
  }

  @override
  Future<GetListResponse<Comment>> fetchComments(GetListRequest req) async {
    try {
      final repo = _firestore.collection(_commentsRepo);
      Query<Map<String, dynamic>>? query;
      DocumentSnapshot? lastDoc;
      int? totalDocsCount;

      if (req.lastQueriedId != null) {
        lastDoc = await repo.doc(req.lastQueriedId).get();
      }

      req.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      req.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      req.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      req.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      req.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      req.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      req.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });

      if (req.searchTag != null && query == null) {
        query = repo.where('searchTags', arrayContains: req.searchTag);
      } else if (req.searchTag != null && query != null) {
        query = query!.where('searchTags', arrayContains: req.searchTag);
      }

      // Count the queried documents
      if (!req.isTotalCounted) {
        if (query == null) {
          final aggregations = await repo.count().get();
          totalDocsCount = aggregations.count;
        } else {
          final aggregations = await query!.count().get();
          totalDocsCount = aggregations.count;
        }
      }

      req.orderBy.forEach((key, isDescending) {
        if (query == null) {
          query = repo.orderBy(key, descending: isDescending);
        } else {
          query = query!.orderBy(key, descending: isDescending);
        }
      });

      if (req.lastQueriedId != null && lastDoc != null) {
        if (query == null) {
          query = repo.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        } else {
          query = query!.startAfterDocument(lastDoc);
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      } else {
        if (query == null) {
          if (req.limit != null) query = repo.limit(req.limit!);
        } else {
          if (req.limit != null) query = query!.limit(req.limit!);
        }
      }

      final result = await query!.get();
      return GetListResponse(
        totalCount: totalDocsCount,
        entities: result.docs
            .map((e) => Comment.fromMap(e.data(), e.id, true))
            .toList(),
      );
    } catch (e) {
      if (kDebugMode) print('FS_FETCH_Comments: $e');
      throw 'FS_FETCH_Comments';
    }
  }

  @override
  Future<void> updateComment(Comment comment) async {
    try {
      final commentId = comment.id;
      if (commentId == null) {
        throw 'FS_MODIFY_Comment_EMPTY_ID';
      }

      // Add to Repo:
      final ref = _firestore.collection(_commentsRepo).doc(commentId);
      await ref.update(comment.toMap(true));

      // // Add to cache
      // final cache = _kooza.collection(_commentsRepo).doc(commentId);
      // await cache.set(comment.toMap(false), ttl: _ttl);
    } catch (e) {
      if (kDebugMode) print('FS_MODIFY_Comment: $e');
      if (e == 'FS_MODIFY_Comment_EMPTY_ID') rethrow;
      throw 'FS_MODIFY_Comment';
    }
  }

  @override
  Future<void> updateComments(List<Comment> comments) async {
    try {
      if (comments.isEmpty) {
        throw 'NoCommentsToCreate';
      }

      final creationsCount = comments.length;
      if (creationsCount <= 500) {
        final batch = _firestore.batch();
        for (var comment in comments) {
          final doc = _firestore.collection(_commentsRepo).doc(comment.id);
          batch.update(doc, comment.toMap(true));
        }
        await batch.commit();
        return;
      }

      final batchCount = (creationsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var comment in comments) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_commentsRepo).doc(comment.id);
        batches[batchIndex].update(doc, comment.toMap(true));
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (kDebugMode) {
        print('FailedCreatingComments: $e');
      }
      if (e == 'NoCommentsToCreate') rethrow;
      throw 'FailedCreatingComments';
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      // Delete from Repo
      await _firestore.collection(_commentsRepo).doc(commentId).delete();

      // Delete from cache
      await _kooza.collection(_commentsRepo).doc(commentId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('FailedDeletingComment: $e');
      }
      throw 'FailedDeletingComment';
    }
  }

  @override
  Future<void> deleteComments(List<String> ids) async {
    try {
      if (ids.isEmpty) throw 'NoneSelectedForDeletion';

      final deletionsCount = ids.length;
      if (deletionsCount <= 500) {
        final batch = _firestore.batch();
        for (var id in ids) {
          final ref = _firestore.collection(_commentsRepo).doc(id);
          batch.delete(ref);
        }
        await batch.commit();
        return;
      }

      final batchCount = (deletionsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var id in ids) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        final doc = _firestore.collection(_commentsRepo).doc(id);
        batches[batchIndex].delete(doc);
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }
    } catch (e) {
      if (e == 'NoneSelectedForDeletion') rethrow;
      if (kDebugMode) {
        print('FailedDeletingComments: $e');
      }
      throw 'FailedDeletingComments';
    }
  }

  @override
  Future<void> deleteAllComments(Map<String, dynamic> isEqualToQueries) async {
    try {
      final int deletionsCount;
      QuerySnapshot<Map<String, dynamic>> toBeDeleted;
      final repoRef = _firestore.collection(_commentsRepo);
      Query<Map<String, dynamic>>? query;

      if (isEqualToQueries.isNotEmpty) {
        isEqualToQueries.forEach((key, value) {
          if (query == null) {
            query = repoRef.where(key, isEqualTo: value);
          } else {
            query = query?.where(key, isEqualTo: value);
          }
        });
      }

      if (isEqualToQueries.isNotEmpty && query != null) {
        final aggregations = await query?.count().get();
        deletionsCount = aggregations?.count ?? 0;
      } else {
        final aggregations = await repoRef.count().get();
        deletionsCount = aggregations.count ?? 0;
      }

      if (isEqualToQueries.isNotEmpty && query != null) {
        toBeDeleted = await query!.get();
      } else {
        toBeDeleted = await repoRef.get();
      }

      if (deletionsCount <= 500) {
        final batch = _firestore.batch();
        for (var doc in toBeDeleted.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        return;
      }

      final batchCount = (deletionsCount / 500).ceil();
      List<WriteBatch> batches = [];
      for (int i = 0; i < batchCount; i++) {
        batches.add(_firestore.batch());
      }

      int documentCounter = 0;
      int batchIndex = 0;
      for (var doc in toBeDeleted.docs) {
        if (documentCounter == 500) {
          documentCounter = 0;
          batchIndex += 1;
        }
        batches[batchIndex].delete(doc.reference);
        documentCounter += 1;
      }

      for (var batch in batches) {
        await batch.commit();
      }

      // await _kooza.collection(_commentsRepo).delete();
    } catch (e) {
      if (kDebugMode) {
        print('FailedDeletingUserRoles: $e');
      }
      throw 'FailedDeletingUserRoles';
    }
  }

  @override
  Future<int> countComments(CountRequest request) async {
    try {
      int totalDocsCount = 0;
      Query<Map<String, dynamic>>? query;
      final repo = _firestore.collection(_commentsRepo);

      request.isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      request.isNotEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isNotEqualTo: value);
        } else {
          query = query!.where(key, isNotEqualTo: value);
        }
      });

      request.isLessThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThan: value);
        } else {
          query = query!.where(key, isLessThan: value);
        }
      });

      request.isLessOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isLessThanOrEqualTo: value);
        } else {
          query = query!.where(key, isLessThanOrEqualTo: value);
        }
      });

      request.isGreaterThanQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThan: value);
        } else {
          query = query!.where(key, isGreaterThan: value);
        }
      });

      request.isGreaterOrEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, isGreaterThanOrEqualTo: value);
        } else {
          query = query!.where(key, isGreaterThanOrEqualTo: value);
        }
      });

      request.orQueries.forEach((key, value) {
        if (query == null) {
          query = repo.where(key, whereIn: value);
        } else {
          query = query!.where(key, whereIn: value);
        }
      });
      if (query == null) {
        final aggregations = await repo.count().get();
        totalDocsCount = aggregations.count ?? 0;
      } else {
        final aggregations = await query!.count().get();
        totalDocsCount = aggregations.count ?? 0;
      }

      return totalDocsCount;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> backUpComments(List<Comment> selected) async {
    try {
      if (selected.isEmpty) throw 'NoneSelectedForBackup';
      final date = DateTime.now();
      final dateStr = '${date.year}_${date.month}_${date.day}';
      final timeStr = '${date.hour}_${date.minute}_${date.second}';
      final fileName = 'Comments_${dateStr}_$timeStr';

      final jsonList = selected.map((e) => e.toMap(false)).toList();
      await _backUpEntities(fileName, jsonList);
      return;
    } catch (e) {
      if (e == 'NoneSelectedForBackup') rethrow;
      if (kDebugMode) {
        print('FailedBackUpComments: $e');
      }
      throw 'FailedBackUpComments';
    }
  }

  @override
  Future<void> backUpAllComments(Map<String, dynamic> isEqualToQueries) async {
    try {
      final date = DateTime.now();
      final dateStr = '${date.year}_${date.month}_${date.day}';
      final timeStr = '${date.hour}_${date.minute}_${date.second}';
      final fileName = 'Comments_${dateStr}_$timeStr';
      final repoRef = _firestore.collection(_commentsRepo);

      if (isEqualToQueries.isEmpty) {
        final docs = (await repoRef.get()).docs;
        final data =
            docs.map((e) => Comment.fromMap(e.data(), e.id, true)).toList();
        await _backUpEntities(
            fileName, data.map((e) => e.toMap(false)).toList());
        return;
      }

      Query<Map<String, dynamic>>? query;
      isEqualToQueries.forEach((key, value) {
        if (query == null) {
          query = repoRef.where(key, isEqualTo: value);
        } else {
          query = query!.where(key, isEqualTo: value);
        }
      });

      if (query != null) {
        final docs = (await query?.get())?.docs;
        final data =
            docs?.map((e) => Comment.fromMap(e.data(), e.id, true)).toList();
        await _backUpEntities(
            fileName, data?.map((e) => e.toMap(false)).toList() ?? []);
      }
    } catch (e) {
      if (kDebugMode) {
        print('FS => Error Backing Up Comments: $e');
      }
      throw 'error-backing-up-Comments';
    }
  }

  @override
  Future<void> restoreComments(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  ) async {
    try {
      final retrieved = await _restoreEntities();
      if (retrieved.isEmpty) throw 'NoneToRestore';

      final ref = _firestore.collection(_commentsRepo);
      final upgraded = retrieved.map((e) => {...e, ...replacements});
      final entities =
          upgraded.map((e) => Comment.fromMap(e, null, false)).toList();

      final changeUserId = replacements.containsKey('userId');
      final changeBusinessId = replacements.containsKey('businessId');
      if (changeUserId || changeBusinessId) {
        for (var entity in entities) {
          await ref.add(entity.toMap(true));
        }
        return;
      }

      if (mode == RestoreMode.keepBoth) {
        for (var entity in entities) {
          await ref.add(entity.toMap(true));
        }
        return;
      }

      if (mode == RestoreMode.merge) {
        for (var entity in entities) {
          if ((await ref.doc(entity.id).get()).exists) {
            await ref.doc(entity.id).update(entity.toMap(true));
          } else {
            await ref.add(entity.toMap(true));
          }
        }
        return;
      }

      if (mode == RestoreMode.replace) {
        for (var entity in entities) {
          await ref.doc(entity.id).set(entity.toMap(true));
        }
        return;
      }
    } catch (e) {
      if (e == 'NoneToRestore') rethrow;
      if (kDebugMode) print('FS_RESTORE_Comments: $e');
      throw 'FS_RESTORE_Comments';
    }
  }

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
      final key = Key.fromUtf8('AnaarGulDanaDanaAnaarGulDanaDana');
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
      final key = Key.fromUtf8('AnaarGulDanaDanaAnaarGulDanaDana');
      final b64key = Key.fromUtf8(base64Url.encode(key.bytes).substring(0, 32));
      final fernet = Fernet(b64key);
      final encrypter = Encrypter(fernet);
      return encrypter.decrypt(Encrypted.fromBase64(data));
    } catch (e) {
      throw 'FailedDecrypting';
    }
  }
}
