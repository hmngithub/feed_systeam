import '../../domain/entities/converse_stats.g.dart';

enum ConverseStatsStateStatus {
  idle,
  invalid,

  creating,
  created,
  failedCreate,

  streaming,
  streamed,
  failedStream,

  fetching,
  fetched,
  failedFetch,

  counting,
  counted,
  failedCount,

  updating,
  updated,
  failedUpdate,

  deleting,
  deleted,
  failedDelete,
}

extension ConverseStatsStateStatusExt on ConverseStatsStateStatus {
  bool get isIdle => this == ConverseStatsStateStatus.idle;
  bool get isInvalid => this == ConverseStatsStateStatus.invalid;

  bool get isCreating => this == ConverseStatsStateStatus.creating;
  bool get isCreated => this == ConverseStatsStateStatus.created;
  bool get isFailedCreate => this == ConverseStatsStateStatus.failedCreate;

  bool get isStreaming => this == ConverseStatsStateStatus.streaming;
  bool get isStreamed => this == ConverseStatsStateStatus.streamed;
  bool get isFailedStream => this == ConverseStatsStateStatus.failedStream;

  bool get isFetching => this == ConverseStatsStateStatus.fetching;
  bool get isFetched => this == ConverseStatsStateStatus.fetched;
  bool get isFailedFetch => this == ConverseStatsStateStatus.failedFetch;

  bool get isCounting => this == ConverseStatsStateStatus.counting;
  bool get isCounted => this == ConverseStatsStateStatus.counted;
  bool get isFailedCount => this == ConverseStatsStateStatus.failedCount;

  bool get isUpdating => this == ConverseStatsStateStatus.updating;
  bool get isUpdated => this == ConverseStatsStateStatus.updated;
  bool get isFailedUpdate => this == ConverseStatsStateStatus.failedUpdate;

  bool get isDeleting => this == ConverseStatsStateStatus.deleting;
  bool get isDeleted => this == ConverseStatsStateStatus.deleted;
  bool get isFailedDelete => this == ConverseStatsStateStatus.failedDelete;

  bool get isLoading {
    if (isCreating) return true;
    if (isStreaming) return true;
    if (isFetching) return true;
    if (isCounting) return true;
    if (isUpdating) return true;
    if (isDeleting) return true;
    return false;
  }

  bool get isSuccess {
    if (isCreated) return true;
    if (isStreamed) return true;
    if (isFetched) return true;
    if (isCounted) return true;
    if (isUpdated) return true;
    if (isDeleted) return true;
    return false;
  }

  bool get isFailure {
    if (isFailedCreate) return true;
    if (isFailedStream) return true;
    if (isFailedFetch) return true;
    if (isFailedCount) return true;
    if (isFailedUpdate) return true;
    if (isFailedDelete) return true;
    if (isInvalid) return true;
    return false;
  }

  bool get isCommanding {
    if (isCreating) return true;
    if (isUpdating) return true;
    if (isDeleting) return true;
    return false;
  }

  bool get isQuerying {
    if (isStreaming) return true;
    if (isFetching) return true;
    if (isCounting) return true;
    return false;
  }

  bool get isCommanded {
    if (isCreated) return true;
    if (isUpdated) return true;
    if (isDeleted) return true;
    return false;
  }

  bool get isQueried {
    if (isStreamed) return true;
    if (isFetched) return true;
    if (isCounted) return true;
    return false;
  }

  bool get isFailedCommand {
    if (isFailedCreate) return true;
    if (isFailedUpdate) return true;
    if (isFailedDelete) return true;
    if (isInvalid) return true;
    return false;
  }

  bool get isFailedQuery {
    if (isFailedStream) return true;
    if (isFailedFetch) return true;
    if (isFailedCount) return true;
    return false;
  }

  static ConverseStatsStateStatus fromName(String? name,
      [ConverseStatsStateStatus value = ConverseStatsStateStatus.idle]) {
    if (name == null) return value;
    try {
      return ConverseStatsStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class ConverseStatsState {
  final ConverseStatsStateStatus status;
  final String? error;
  final ConverseStats stats;

  T getValue<T>(String key) {
    if (T is bool || T == bool) {
      return (stats.stats[key] ?? false) as T;
    }

    if (T is int || T == int) {
      return ((stats.stats[key] ?? 0) as num).toInt() as T;
    }

    if (T is double || T == double) {
      return ((stats.stats[key] ?? 0.0) as num).toDouble() as T;
    }

    if (T is String || T == String) {
      return (stats.stats[key] ?? '').toString() as T;
    }

    if (T is Map<String, dynamic> || T == Map<String, dynamic>) {
      return Map<String, dynamic>.from(stats.stats[key] ?? {}) as T;
    }

    if (T is List<bool> || T == List<bool>) {
      return List<bool>.from(stats.stats[key] ?? []) as T;
    }

    if (T is List<int> || T == List<int>) {
      return List<int>.from(stats.stats[key] ?? []) as T;
    }

    if (T is List<double> || T == List<double>) {
      return List<double>.from(stats.stats[key] ?? []) as T;
    }

    if (T is List<String> || T == List<String>) {
      return List<String>.from(stats.stats[key] ?? []) as T;
    }

    if (T is List<Map<String, dynamic>> || T == List<Map<String, dynamic>>) {
      return List<Map<String, dynamic>>.from(stats.stats[key] ?? []) as T;
    }

    return stats.stats[key] as T;
  }

  const ConverseStatsState({
    required this.status,
    required this.error,
    required this.stats,
  });

  const ConverseStatsState.init({
    this.status = ConverseStatsStateStatus.idle,
    this.error,
    this.stats = const ConverseStats.init(),
  });

  ConverseStatsState copyWith({
    ConverseStatsStateStatus? status,
    String? error,
    ConverseStats? stats,
  }) {
    return ConverseStatsState(
      status: status ?? this.status,
      error: error ?? this.error,
      stats: stats ?? this.stats,
    );
  }

  ConverseStatsState idleState() {
    return ConverseStatsState(
      status: ConverseStatsStateStatus.idle,
      error: null,
      stats: stats,
    );
  }

  ConverseStatsState loadingState(ConverseStatsStateStatus status) {
    return ConverseStatsState(
      status: status,
      error: null,
      stats: stats,
    );
  }

  ConverseStatsState successState(
    ConverseStatsStateStatus status, {
    ConverseStats? stats,
  }) {
    return ConverseStatsState(
      status: status,
      error: null,
      stats: stats ?? this.stats,
    );
  }

  ConverseStatsState failureState(ConverseStatsStateStatus status,
      {dynamic error}) {
    return ConverseStatsState(
      status: status,
      error: (error ?? '').toString(),
      stats: stats,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'stats': stats.toMap(isFirestore),
    };
  }

  factory ConverseStatsState.fromMap(Map<String, dynamic> map) {
    return ConverseStatsState(
      status: ConverseStatsStateStatusExt.fromName(map['status']),
      error: map['error'].toString(),
      stats: ConverseStats.fromMap(map['stats'], null, false),
    );
  }
}
