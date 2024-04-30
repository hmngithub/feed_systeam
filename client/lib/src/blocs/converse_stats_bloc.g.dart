import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/converse_stats.g.dart';
import 'gateways/converse_repository.g.dart';
import 'states/converse_stats_state.g.dart';
import 'dtos/count_request.g.dart';

class ConverseStatsBloc extends Cubit<ConverseStatsState> {
  final ConverseRepository _repository;
  ConverseStatsBloc(ConverseRepository iamRepository)
      : _repository = iamRepository,
        super(const ConverseStatsState.init()) {
    if (state.stats.shouldRecalculate) {
      countAll();
    }
  }

  void setConverseStats(ConverseStats? stats) {
    if (stats == null) return;
    emit(state.copyWith(stats: stats));
  }

  void setStatValue(String key, dynamic value, [bool cache = false]) async {
    var data = Map<String, dynamic>.from(state.stats.stats);
    data[key] = value;
    var newStats = state.stats.copyWith(stats: data);
    emit(state.copyWith(stats: newStats));
    if (cache) return await saveConverseStats();
  }

  void setConverseStatsId(String? id, [bool cache = false]) async {
    if (id == null) return;
    final stats = state.stats.copyWith(id: id);
    emit(state.copyWith(stats: stats));
    if (cache) return await saveConverseStats();
  }

  void setConverseStatsUserId(String? userId, [bool cache = false]) async {
    if (userId == null) return;
    final stats = state.stats.copyWith(userId: userId);
    emit(state.copyWith(stats: stats));
    if (cache) return await saveConverseStats();
  }

  void setConverseStatsBusinessId(String? businessId,
      [bool cache = false]) async {
    if (businessId == null) return;
    final stats = state.stats.copyWith(businessId: businessId);
    emit(state.copyWith(stats: stats));
    if (cache) return await saveConverseStats();
  }

  void setConverseStatsStats(Map<String, dynamic>? statsData,
      [bool cache = false]) async {
    if (statsData == null) return;
    final stats = state.stats.copyWith(stats: statsData);
    emit(state.copyWith(stats: stats));
    if (cache) return await saveConverseStats();
  }

  void setConverseStatsCreationDate(DateTime? creationDate,
      [bool cache = false]) async {
    if (creationDate == null) return;
    final stats = state.stats.copyWith(creationDate: creationDate);
    emit(state.copyWith(stats: stats));
    if (cache) return await saveConverseStats();
  }

  void setConverseStatsCreatorId(String? creatorId,
      [bool cache = false]) async {
    if (creatorId == null) return;
    final stats = state.stats.copyWith(creatorId: creatorId);
    emit(state.copyWith(stats: stats));
    if (cache) return await saveConverseStats();
  }

  void setConverseStatsLastModifiedDate(DateTime? lastModifiedDate,
      [bool cache = false]) async {
    if (lastModifiedDate == null) return;
    final stats = state.stats.copyWith(lastModifiedDate: lastModifiedDate);
    emit(state.copyWith(stats: stats));
    if (cache) return await saveConverseStats();
  }

  void setConverseStatsLastModifierId(String? lastModifierId,
      [bool cache = false]) async {
    if (lastModifierId == null) return;
    final stats = state.stats.copyWith(lastModifierId: lastModifierId);
    emit(state.copyWith(stats: stats));
    if (cache) return await saveConverseStats();
  }

  void toInitState() {
    emit(const ConverseStatsState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(ConverseStatsStateStatus status, dynamic error) {
    emit(state.failureState(status, error: error));
  }

  Future<void> saveConverseStats() async {
    try {
      emit(state.loadingState(ConverseStatsStateStatus.creating));
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      final newStats = state.stats.copyWith(
        businessId: businessId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      await _repository.saveStats(
        businessId: businessId!,
        stats: newStats,
      );

      emit(state.successState(
        ConverseStatsStateStatus.created,
        stats: newStats,
      ));
    } catch (err) {
      emit(state.failureState(ConverseStatsStateStatus.failedCreate,
          error: err));
    }
  }

  StreamSubscription<ConverseStats>? _statsSub;
  Future<void> streamConverseStats() async {
    try {
      emit(state.loadingState(ConverseStatsStateStatus.streaming));
      await _statsSub?.cancel();
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      _statsSub = _repository.streamStats(businessId!).listen((stats) {
        emit(state.successState(
          ConverseStatsStateStatus.streamed,
          stats: stats,
        ));
      },
          onError: (err) => emit(state.failureState(
              ConverseStatsStateStatus.failedStream,
              error: err)));
    } catch (err) {
      emit(state.failureState(ConverseStatsStateStatus.failedStream,
          error: err));
    }
  }

  Future<void> fetchConverseStats() async {
    try {
      emit(state.loadingState(ConverseStatsStateStatus.fetching));
      await _statsSub?.cancel();
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final stats = await _repository.fetchStats(businessId!);
      emit(state.successState(
        ConverseStatsStateStatus.fetched,
        stats: stats,
      ));
    } catch (err) {
      emit(
          state.failureState(ConverseStatsStateStatus.failedFetch, error: err));
    }
  }

  Future<void> countAll({
    Map<String, dynamic> isEqualTo = const <String, dynamic>{},
    bool includeUserId = false,
    bool includeBusinessId = true,
  }) async {
    try {
      emit(state.loadingState(ConverseStatsStateStatus.counting));
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

      final request = CountRequest.init(
        isEqualToQueries: isEqualToQueries,
      );

      await countLikes(request);
      await countFeedBackRounds(request);
      await countMedias(request);
      await countFeeds(request);
      await countComments(request);

      await saveConverseStats();
    } catch (err) {
      emit(
          state.failureState(ConverseStatsStateStatus.failedCount, error: err));
    }
  }

  Future<void> countLikes(CountRequest request) async {
    try {
      emit(state.loadingState(ConverseStatsStateStatus.counting));
      final count = await _repository.countLikes(request);

      var statsData = Map<String, dynamic>.from(state.stats.stats);
      statsData['likesCount'] = count;

      emit(state.successState(
        ConverseStatsStateStatus.counted,
        stats: state.stats.copyWith(stats: statsData),
      ));
    } catch (err) {
      emit(
          state.failureState(ConverseStatsStateStatus.failedCount, error: err));
    }
  }

  Future<void> countFeedBackRounds(CountRequest request) async {
    try {
      emit(state.loadingState(ConverseStatsStateStatus.counting));
      final count = await _repository.countFeedBackRounds(request);

      var statsData = Map<String, dynamic>.from(state.stats.stats);
      statsData['feedBackRoundsCount'] = count;

      emit(state.successState(
        ConverseStatsStateStatus.counted,
        stats: state.stats.copyWith(stats: statsData),
      ));
    } catch (err) {
      emit(
          state.failureState(ConverseStatsStateStatus.failedCount, error: err));
    }
  }

  Future<void> countMedias(CountRequest request) async {
    try {
      emit(state.loadingState(ConverseStatsStateStatus.counting));
      final count = await _repository.countMedias(request);

      var statsData = Map<String, dynamic>.from(state.stats.stats);
      statsData['mediasCount'] = count;

      emit(state.successState(
        ConverseStatsStateStatus.counted,
        stats: state.stats.copyWith(stats: statsData),
      ));
    } catch (err) {
      emit(
          state.failureState(ConverseStatsStateStatus.failedCount, error: err));
    }
  }

  Future<void> countFeeds(CountRequest request) async {
    try {
      emit(state.loadingState(ConverseStatsStateStatus.counting));
      final count = await _repository.countFeeds(request);

      var statsData = Map<String, dynamic>.from(state.stats.stats);
      statsData['feedsCount'] = count;

      emit(state.successState(
        ConverseStatsStateStatus.counted,
        stats: state.stats.copyWith(stats: statsData),
      ));
    } catch (err) {
      emit(
          state.failureState(ConverseStatsStateStatus.failedCount, error: err));
    }
  }

  Future<void> countComments(CountRequest request) async {
    try {
      emit(state.loadingState(ConverseStatsStateStatus.counting));
      final count = await _repository.countComments(request);

      var statsData = Map<String, dynamic>.from(state.stats.stats);
      statsData['commentsCount'] = count;

      emit(state.successState(
        ConverseStatsStateStatus.counted,
        stats: state.stats.copyWith(stats: statsData),
      ));
    } catch (err) {
      emit(
          state.failureState(ConverseStatsStateStatus.failedCount, error: err));
    }
  }

  @override
  Future<void> close() async {
    await _statsSub?.cancel();
    return super.close();
  }
}
