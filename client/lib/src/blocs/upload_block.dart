import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/media.g.dart';
import 'states/upload_state.dart';

class UploadBloc extends Cubit<UploadState> {
  final Reference _ref;
  UploadBloc(Reference ref)
      : _ref = ref,
        super(const UploadState.init());

  void setInit() {
    emit(state.copyWith(
      isUpdate: false,
      status: UploadStateStatus.idle,
      files: [],
      urls: [],
    ));
  }

  void setUrlsInit() {
    emit(state.copyWith(urls: []));
  }

  bool setFiles(List<AppFile> files) {
    emit(state.copyWith(files: files));
    return true;
  }

  void setSucceded() {
    emit(state.successState(UploadStateStatus.uploaded));
  }

  void setUrls(List<String> urls) {
    emit(state.copyWith(urls: urls));
  }

  void setMediasUrl(List<Media> medias) {
    for (var element in medias) {
      addToUrls(element.url ?? '');
    }
  }

  void setIsUpdate(bool isUpdate) {
    emit(state.copyWith(isUpdate: isUpdate));
  }

  void setIdl() {
    emit(state.copyWith(status: UploadStateStatus.idle));
  }

  void uploadVoice(Uint8List voice) async {
    final imageRef = _ref.child("${DateTime.now()}.wav");
    await imageRef.putData(voice);
    final url = await imageRef.getDownloadURL();
    var voiceUrl = <String>[];
    voiceUrl.add(url);
    emit(state.copyWith(urls: voiceUrl));
  }

  void addToUrls(String url) {
    var newUrls = List<String>.from(state.urls);
    newUrls.add(url);
    emit(state.copyWith(urls: newUrls));
  }

  void uploadFile() async {
    setUrlsInit();
    try {
      emit(state.loadingState(UploadStateStatus.uploading));
      for (int i = 0; i < state.files.length; i++) {
        final imageRef = _ref.child(
            "${state.files[i].name}${DateTime.now()}.${state.files[i].extension}");
        await imageRef.putData(state.files[i].data);
        final url = await imageRef.getDownloadURL();
        addToUrls(url);
      }
      emit(state.successState(UploadStateStatus.uploaded));
    } catch (e) {
      emit(state.failureState(UploadStateStatus.failedUploading));
    }
  }
}
