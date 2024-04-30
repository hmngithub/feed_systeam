import '../../domain/entities/converse_settings.g.dart';

enum ConverseSettingsStateStatus {
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

  updating,
  updated,
  failedUpdate,

  deleting,
  deleted,
  failedDelete,
}

extension ConverseSettingsStateStatusExt on ConverseSettingsStateStatus {
  bool get isIdle => this == ConverseSettingsStateStatus.idle;
  bool get isInvalid => this == ConverseSettingsStateStatus.invalid;

  bool get isCreating => this == ConverseSettingsStateStatus.creating;
  bool get isCreated => this == ConverseSettingsStateStatus.created;
  bool get isFailedCreate => this == ConverseSettingsStateStatus.failedCreate;

  bool get isStreaming => this == ConverseSettingsStateStatus.streaming;
  bool get isStreamed => this == ConverseSettingsStateStatus.streamed;
  bool get isFailedStream => this == ConverseSettingsStateStatus.failedStream;

  bool get isFetching => this == ConverseSettingsStateStatus.fetching;
  bool get isFetched => this == ConverseSettingsStateStatus.fetched;
  bool get isFailedFetch => this == ConverseSettingsStateStatus.failedFetch;

  bool get isUpdating => this == ConverseSettingsStateStatus.updating;
  bool get isUpdated => this == ConverseSettingsStateStatus.updated;
  bool get isFailedUpdate => this == ConverseSettingsStateStatus.failedUpdate;

  bool get isDeleting => this == ConverseSettingsStateStatus.deleting;
  bool get isDeleted => this == ConverseSettingsStateStatus.deleted;
  bool get isFailedDelete => this == ConverseSettingsStateStatus.failedDelete;

  bool get isLoading {
    if (isCreating) return true;
    if (isStreaming) return true;
    if (isFetching) return true;
    if (isUpdating) return true;
    if (isDeleting) return true;
    return false;
  }

  bool get isSuccess {
    if (isCreated) return true;
    if (isStreamed) return true;
    if (isFetched) return true;
    if (isUpdated) return true;
    if (isDeleted) return true;
    return false;
  }

  bool get isFailure {
    if (isFailedCreate) return true;
    if (isFailedStream) return true;
    if (isFailedFetch) return true;
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
    return false;
  }

  static ConverseSettingsStateStatus fromName(String? name,
      [ConverseSettingsStateStatus value = ConverseSettingsStateStatus.idle]) {
    if (name == null) return value;
    try {
      return ConverseSettingsStateStatus.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}

class ConverseSettingsState {
  final ConverseSettingsStateStatus status;
  final String? error;
  final ConverseSettings settings;

  T getValue<T>(String key) {
    if (T is bool || T == bool) {
      return (settings.settings[key] ?? false) as T;
    }

    if (T is int || T == int) {
      return ((settings.settings[key] ?? 0) as num).toInt() as T;
    }

    if (T is double || T == double) {
      return ((settings.settings[key] ?? 0.0) as num).toDouble() as T;
    }

    if (T is String || T == String) {
      return (settings.settings[key] ?? '').toString() as T;
    }

    if (T is Map<String, dynamic> || T == Map<String, dynamic>) {
      return Map<String, dynamic>.from(settings.settings[key] ?? {}) as T;
    }

    if (T is List<bool> || T == List<bool>) {
      return List<bool>.from(settings.settings[key] ?? []) as T;
    }

    if (T is List<int> || T == List<int>) {
      return List<int>.from(settings.settings[key] ?? []) as T;
    }

    if (T is List<double> || T == List<double>) {
      return List<double>.from(settings.settings[key] ?? []) as T;
    }

    if (T is List<String> || T == List<String>) {
      return List<String>.from(settings.settings[key] ?? []) as T;
    }

    if (T is List<Map<String, dynamic>> || T == List<Map<String, dynamic>>) {
      return List<Map<String, dynamic>>.from(settings.settings[key] ?? []) as T;
    }

    return settings.settings[key] as T;
  }

  const ConverseSettingsState({
    required this.status,
    required this.error,
    required this.settings,
  });

  const ConverseSettingsState.init({
    this.status = ConverseSettingsStateStatus.idle,
    this.error,
    this.settings = const ConverseSettings.init(),
  });

  ConverseSettingsState copyWith({
    ConverseSettingsStateStatus? status,
    String? error,
    ConverseSettings? settings,
  }) {
    return ConverseSettingsState(
      status: status ?? this.status,
      error: error ?? this.error,
      settings: settings ?? this.settings,
    );
  }

  ConverseSettingsState idleState() {
    return ConverseSettingsState(
      status: ConverseSettingsStateStatus.idle,
      error: null,
      settings: settings,
    );
  }

  ConverseSettingsState loadingState(ConverseSettingsStateStatus status) {
    return ConverseSettingsState(
      status: status,
      error: null,
      settings: settings,
    );
  }

  ConverseSettingsState successState(
    ConverseSettingsStateStatus status, {
    ConverseSettings? settings,
  }) {
    return ConverseSettingsState(
      status: status,
      error: null,
      settings: settings ?? this.settings,
    );
  }

  ConverseSettingsState failureState(ConverseSettingsStateStatus status,
      {dynamic error}) {
    return ConverseSettingsState(
      status: status,
      error: (error ?? '').toString(),
      settings: settings,
    );
  }

  Map<String, dynamic> toMap(bool isFirestore) {
    return <String, dynamic>{
      'status': status.name,
      'error': error,
      'settings': settings.toMap(isFirestore),
    };
  }

  factory ConverseSettingsState.fromMap(Map<String, dynamic> map) {
    return ConverseSettingsState(
      status: ConverseSettingsStateStatusExt.fromName(map['status']),
      error: map['error'].toString(),
      settings: ConverseSettings.fromMap(map['settings'], null, false),
    );
  }
}
