import 'package:converse_client/src/blocs/feed_bloc.g.dart';
import 'package:converse_client/src/blocs/states/feed_state.g.dart';
import 'package:converse_client/src/blocs/states/upload_state.dart';
import 'package:converse_client/src/blocs/upload_block.dart';
import 'package:converse_client/src/domain/entities/media.g.dart';
import 'package:converse_client/src/domain/enums/media_type.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feed_uploader.dart';

class FeedUploaderDisplay extends StatefulWidget {
  const FeedUploaderDisplay({
    super.key,
  });

  @override
  State<FeedUploaderDisplay> createState() => _FeedUploaderDisplayState();
}

class _FeedUploaderDisplayState extends State<FeedUploaderDisplay> {
  bool cfu = false;

  void insertMedia(BuildContext context, List<String> mediaUrls) {
    List<Media> medias = [];
    for (int i = 0; i < mediaUrls.length; i++) {
      MediaType extension = context.read<UploadBloc>().state.files[i].type;
      if (extension == MediaType.photo) {
        final media = Media(
            id: '',
            creatorId: '',
            lastModifierId: "",
            url: mediaUrls[i],
            type: MediaType.photo,
            creationDate: DateTime.now(),
            lastModifiedDate: DateTime.now());
        medias.add(media);
      } else {
        final media = Media(
          id: '',
          creatorId: '',
          lastModifierId: "",
          url: mediaUrls[i],
          type: MediaType.video,
          creationDate: DateTime.now(),
          lastModifiedDate: DateTime.now(),
        );
        medias.add(media);
      }
    }
    context.read<FeedBloc>().setFeedMedias(medias);
  }

  @override
  Widget build(BuildContext context) {
    final builder = BlocBuilder<FeedBloc, FeedState>(
      buildWhen: (previous, current) => current.status != FeedStateStatus.idle,
      builder: (context, state) {
        if (state.status.isIdle) {
          return Container();
        } else if (state.status.isIdle) {
          return Container();
        } else if (state.status.isLoading && cfu) {
          return const FeedUploader();
        } else if (state.status.isUpdated && cfu) {
          context.read<UploadBloc>().setIdl();
          cfu = false;
          return const FeedUploader(change: true);
        } else if (state.status.isCreated && cfu) {
          cfu = false;
          context.read<UploadBloc>().setIdl();
          return const FeedUploader(change: true);
        } else if (state.status.isFailedCreate) {
          return const FeedUploader(
            change: true,
            massege: "Fieled Create Feed",
          );
        } else {
          return Container();
        }
      },
    );

    final secondStep = builder;
    final firstStep = BlocBuilder<UploadBloc, UploadState>(
      buildWhen: (previous, current) =>
          current.status != UploadStateStatus.idle,
      builder: (context, state) {
        if (state.status.isIdle) {
          return Container();
        } else if (state.status.isUploading) {
          return const FeedUploader();
        } else if (state.status.isSuccess) {
          List<String> mediaURls = context.read<UploadBloc>().state.urls;

          if (mediaURls.isNotEmpty) {
            insertMedia(context, mediaURls);
          }

          if (state.isUpdate) {
            context.read<FeedBloc>().updateFeed();
          } else if (state.isUpdate == false) {
            context.read<FeedBloc>().createFeed();
          }
          cfu = true;
          return secondStep;
        } else if (state.status.isFailedUpload) {
          return const FeedUploader(
            change: true,
            massege: "Fieled Create Feed",
          );
        } else {
          return Container();
        }
      },
    );

    return firstStep;
  }
}
