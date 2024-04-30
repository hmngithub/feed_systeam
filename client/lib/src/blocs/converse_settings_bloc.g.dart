import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/converse_settings.g.dart';
import 'gateways/converse_repository.g.dart';
import 'states/converse_settings_state.g.dart';

class ConverseSettingsBloc extends Cubit<ConverseSettingsState> {
  final ConverseRepository _repository;
  ConverseSettingsBloc(ConverseRepository iamRepository)
      : _repository = iamRepository,
        super(const ConverseSettingsState.init());

  void setConverseSettings(ConverseSettings? settings) {
    if (settings == null) return;
    emit(state.copyWith(settings: settings));
  }

  void setSettingValue(String key, dynamic value, [bool cache = false]) async {
    var data = Map<String, dynamic>.from(state.settings.settings);
    data[key] = value;
    var newSettings = state.settings.copyWith(settings: data);
    emit(state.copyWith(settings: newSettings));
    if (cache) return await saveConverseSettings();
  }

  void setConverseSettingsId(String? id, [bool cache = false]) async {
    if (id == null) return;
    final settings = state.settings.copyWith(id: id);
    emit(state.copyWith(settings: settings));
    if (cache) return await saveConverseSettings();
  }

  void setConverseSettingsUserId(String? userId, [bool cache = false]) async {
    if (userId == null) return;
    final settings = state.settings.copyWith(userId: userId);
    emit(state.copyWith(settings: settings));
    if (cache) return await saveConverseSettings();
  }

  void setConverseSettingsBusinessId(String? businessId,
      [bool cache = false]) async {
    if (businessId == null) return;
    final settings = state.settings.copyWith(businessId: businessId);
    emit(state.copyWith(settings: settings));
    if (cache) return await saveConverseSettings();
  }

  void setConverseSettingsSettings(Map<String, dynamic>? settingsData,
      [bool cache = false]) async {
    if (settingsData == null) return;
    final settings = state.settings.copyWith(settings: settingsData);
    emit(state.copyWith(settings: settings));
    if (cache) return await saveConverseSettings();
  }

  void setConverseSettingsCreationDate(DateTime? creationDate,
      [bool cache = false]) async {
    if (creationDate == null) return;
    final settings = state.settings.copyWith(creationDate: creationDate);
    emit(state.copyWith(settings: settings));
    if (cache) return await saveConverseSettings();
  }

  void setConverseSettingsCreatorId(String? creatorId,
      [bool cache = false]) async {
    if (creatorId == null) return;
    final settings = state.settings.copyWith(creatorId: creatorId);
    emit(state.copyWith(settings: settings));
    if (cache) return await saveConverseSettings();
  }

  void setConverseSettingsLastModifiedDate(DateTime? lastModifiedDate,
      [bool cache = false]) async {
    if (lastModifiedDate == null) return;
    final settings =
        state.settings.copyWith(lastModifiedDate: lastModifiedDate);
    emit(state.copyWith(settings: settings));
    if (cache) return await saveConverseSettings();
  }

  void setConverseSettingsLastModifierId(String? lastModifierId,
      [bool cache = false]) async {
    if (lastModifierId == null) return;
    final settings = state.settings.copyWith(lastModifierId: lastModifierId);
    emit(state.copyWith(settings: settings));
    if (cache) return await saveConverseSettings();
  }

  void toInitState() {
    emit(const ConverseSettingsState.init());
  }

  void toIdleState() {
    emit(state.idleState());
  }

  void toFailureState(ConverseSettingsStateStatus status, dynamic error) {
    emit(state.failureState(status, error: error));
  }

  Future<void> saveConverseSettings() async {
    try {
      emit(state.loadingState(ConverseSettingsStateStatus.creating));
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final userId = user.id;
      if ((userId ?? '').trim().isEmpty) throw 'NoCurrentUserId';

      final newSettings = state.settings.copyWith(
        businessId: businessId,
        creationDate: DateTime.now(),
        creatorId: userId,
      );

      await _repository.saveSettings(
        businessId: businessId!,
        settings: newSettings,
      );

      emit(state.successState(
        ConverseSettingsStateStatus.created,
        settings: newSettings,
      ));
    } catch (err) {
      emit(state.failureState(ConverseSettingsStateStatus.failedCreate,
          error: err));
    }
  }

  StreamSubscription<ConverseSettings>? _settingsSub;
  Future<void> streamConverseSettings() async {
    try {
      emit(state.loadingState(ConverseSettingsStateStatus.streaming));
      await _settingsSub?.cancel();
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      _settingsSub = _repository.streamSettings(businessId!).listen((settings) {
        emit(state.successState(
          ConverseSettingsStateStatus.streamed,
          settings: settings,
        ));
      },
          onError: (err) => emit(state.failureState(
              ConverseSettingsStateStatus.failedStream,
              error: err)));
    } catch (err) {
      emit(state.failureState(ConverseSettingsStateStatus.failedStream,
          error: err));
    }
  }

  Future<void> fetchConverseSettings() async {
    try {
      emit(state.loadingState(ConverseSettingsStateStatus.fetching));
      await _settingsSub?.cancel();
      final user = await _repository.fetchCurrentUserInfo();

      final businessId = user.role.business;
      if ((businessId ?? '').trim().isEmpty) throw ' NoCurrentBusinessId';

      final settings = await _repository.fetchSettings(businessId!);
      emit(state.successState(
        ConverseSettingsStateStatus.fetched,
        settings: settings,
      ));
    } catch (err) {
      emit(state.failureState(ConverseSettingsStateStatus.failedFetch,
          error: err));
    }
  }

  @override
  Future<void> close() async {
    await _settingsSub?.cancel();
    return super.close();
  }
}
