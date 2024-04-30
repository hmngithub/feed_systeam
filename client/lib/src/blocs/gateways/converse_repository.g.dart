import '../dtos/restore_mode.g.dart';
import '../dtos/get_list_request.g.dart';
import '../dtos/get_list_response.g.dart';
import '../dtos/count_request.g.dart';
import '../../domain/entities/like.g.dart';
import '../../domain/entities/feed_back_round.g.dart';
import '../../domain/entities/media.g.dart';
import '../../domain/entities/feed.g.dart';
import '../../domain/entities/comment.g.dart';
import '../../domain/entities/converse_user.g.dart';
import '../../domain/entities/converse_settings.g.dart';
import '../../domain/entities/converse_stats.g.dart';

abstract class ConverseRepository {
  Future<void> setUpConverse(Map<String, dynamic> request);
  String generateRandomId();
  Future<ConverseUser> fetchCurrentUserInfo();
  Future<void> updateUserInfo(ConverseUser user);

  Future<void> saveSettings({
    required String businessId,
    String idSuffix = 'converse',
    required ConverseSettings settings,
  });
  Stream<ConverseSettings> streamSettings(
    String businessId, [
    String idSuffix = 'converse',
  ]);
  Future<ConverseSettings> fetchSettings(
    String businessId, [
    String idSuffix = 'converse',
  ]);

  Future<void> saveStats({
    required String businessId,
    String idSuffix = 'converse',
    required ConverseStats stats,
  });
  Stream<ConverseStats> streamStats(
    String businessId, [
    String idSuffix = 'converse',
  ]);
  Future<ConverseStats> fetchStats(
    String businessId, [
    String idSuffix = 'converse',
  ]);

  /// Creates a new `Like` with automatically generated Id
  Future<String> createLike(Like like);
  Future<void> createLikeWithId(String id, Like like);
  Future<void> createLikes(List<Like> likes);
  Stream<Like> streamLike(String likeId);
  Stream<GetListResponse<Like>> streamLikes(GetListRequest request);
  Future<Like> fetchLike(String likeId);
  Future<GetListResponse<Like>> fetchLikes(GetListRequest request);
  Future<int> countLikes(CountRequest request);
  Future<void> updateLike(Like like);
  Future<void> updateLikes(List<Like> likes);
  Future<void> deleteLike(String likeId);
  Future<void> deleteLikes(List<String> likesIds);
  Future<void> deleteAllLikes(Map<String, dynamic> isEqualToQueries);
  Future<void> backUpLikes(List<Like> selected);
  Future<void> backUpAllLikes(Map<String, dynamic> isEqualToQueries);
  Future<void> restoreLikes(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  );

  /// Creates a new `FeedBackRound` with automatically generated Id
  Future<String> createFeedBackRound(FeedBackRound feedBackRound);
  Future<void> createFeedBackRoundWithId(
      String id, FeedBackRound feedBackRound);
  Future<void> createFeedBackRounds(List<FeedBackRound> feedBackRounds);
  Stream<FeedBackRound> streamFeedBackRound(String feedBackRoundId);
  Stream<GetListResponse<FeedBackRound>> streamFeedBackRounds(
      GetListRequest request);
  Future<FeedBackRound> fetchFeedBackRound(String feedBackRoundId);
  Future<GetListResponse<FeedBackRound>> fetchFeedBackRounds(
      GetListRequest request);
  Future<int> countFeedBackRounds(CountRequest request);
  Future<void> updateFeedBackRound(FeedBackRound feedBackRound);
  Future<void> updateFeedBackRounds(List<FeedBackRound> feedBackRounds);
  Future<void> deleteFeedBackRound(String feedBackRoundId);
  Future<void> deleteFeedBackRounds(List<String> feedBackRoundsIds);
  Future<void> deleteAllFeedBackRounds(Map<String, dynamic> isEqualToQueries);
  Future<void> backUpFeedBackRounds(List<FeedBackRound> selected);
  Future<void> backUpAllFeedBackRounds(Map<String, dynamic> isEqualToQueries);
  Future<void> restoreFeedBackRounds(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  );

  /// Creates a new `Media` with automatically generated Id
  Future<String> createMedia(Media media);
  Future<void> createMediaWithId(String id, Media media);
  Future<void> createMedias(List<Media> medias);
  Stream<Media> streamMedia(String mediaId);
  Stream<GetListResponse<Media>> streamMedias(GetListRequest request);
  Future<Media> fetchMedia(String mediaId);
  Future<GetListResponse<Media>> fetchMedias(GetListRequest request);
  Future<int> countMedias(CountRequest request);
  Future<void> updateMedia(Media media);
  Future<void> updateMedias(List<Media> medias);
  Future<void> deleteMedia(String mediaId);
  Future<void> deleteMedias(List<String> mediasIds);
  Future<void> deleteAllMedias(Map<String, dynamic> isEqualToQueries);
  Future<void> backUpMedias(List<Media> selected);
  Future<void> backUpAllMedias(Map<String, dynamic> isEqualToQueries);
  Future<void> restoreMedias(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  );

  /// Creates a new `Feed` with automatically generated Id
  Future<String> createFeed(Feed feed);
  Future<void> createFeedWithId(String id, Feed feed);
  Future<void> createFeeds(List<Feed> feeds);
  Stream<Feed> streamFeed(String feedId);
  Stream<GetListResponse<Feed>> streamFeeds(GetListRequest request);
  Future<Feed> fetchFeed(String feedId);
  Future<GetListResponse<Feed>> fetchFeeds(GetListRequest request);
  Future<int> countFeeds(CountRequest request);
  Future<void> updateFeed(Feed feed);
  Future<void> updateFeeds(List<Feed> feeds);
  Future<void> deleteFeed(String feedId);
  Future<void> deleteFeeds(List<String> feedsIds);
  Future<void> deleteAllFeeds(Map<String, dynamic> isEqualToQueries);
  Future<void> backUpFeeds(List<Feed> selected);
  Future<void> backUpAllFeeds(Map<String, dynamic> isEqualToQueries);
  Future<void> restoreFeeds(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  );

  /// Creates a new `Comment` with automatically generated Id
  Future<String> createComment(Comment comment);
  Future<void> createCommentWithId(String id, Comment comment);
  Future<void> createComments(List<Comment> comments);
  Stream<Comment> streamComment(String commentId);
  Stream<GetListResponse<Comment>> streamComments(GetListRequest request);
  Future<Comment> fetchComment(String commentId);
  Future<GetListResponse<Comment>> fetchComments(GetListRequest request);
  Future<int> countComments(CountRequest request);
  Future<void> updateComment(Comment comment);
  Future<void> updateComments(List<Comment> comments);
  Future<void> deleteComment(String commentId);
  Future<void> deleteComments(List<String> commentsIds);
  Future<void> deleteAllComments(Map<String, dynamic> isEqualToQueries);
  Future<void> backUpComments(List<Comment> selected);
  Future<void> backUpAllComments(Map<String, dynamic> isEqualToQueries);
  Future<void> restoreComments(
    Map<String, dynamic> replacements,
    RestoreMode mode,
  );
}
