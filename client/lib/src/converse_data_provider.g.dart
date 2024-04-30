import 'package:converse_client/src/blocs/upload_block.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'blocs/like_bloc.g.dart';
import 'blocs/feed_back_round_bloc.g.dart';
import 'blocs/media_bloc.g.dart';
import 'blocs/feed_bloc.g.dart';
import 'blocs/comment_bloc.g.dart';
import 'blocs/likes_bloc.g.dart';

import 'blocs/feed_back_rounds_bloc.g.dart';

import 'blocs/medias_bloc.g.dart';

import 'blocs/feeds_bloc.g.dart';

import 'blocs/comments_bloc.g.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/gateways/iam_service.g.dart';
import 'blocs/gateways/converse_repository.g.dart';
import 'blocs/auth_bloc.g.dart';
import 'blocs/converse_settings_bloc.g.dart';
import 'blocs/converse_stats_bloc.g.dart';

class ConverseRepositoryProvider extends StatelessWidget {
  final IamService iamService;
  final ConverseRepository converseRepository;
  final Widget child;
  const ConverseRepositoryProvider({
    super.key,
    required this.iamService,
    required this.converseRepository,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IamService>.value(value: iamService),
        RepositoryProvider<ConverseRepository>.value(value: converseRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (c) => AuthBloc(c.read<IamService>()),
          ),
          BlocProvider(
              create: (c) => ConverseStatsBloc(c.read<ConverseRepository>())),
          BlocProvider(
              create: (c) =>
                  ConverseSettingsBloc(c.read<ConverseRepository>())),
          BlocProvider(
            create: (c) => LikeBloc(c.read<ConverseRepository>()),
          ),
          BlocProvider(
            create: (c) => FeedBackRoundBloc(c.read<ConverseRepository>()),
          ),
          BlocProvider(
            create: (c) => MediaBloc(c.read<ConverseRepository>()),
          ),
          BlocProvider(
            create: (c) => FeedBloc(c.read<ConverseRepository>()),
          ),
          BlocProvider(
            create: (c) => CommentBloc(c.read<ConverseRepository>()),
          ),
          BlocProvider(
            create: (c) =>
                LikesBloc(c.read<ConverseRepository>())..streamLikes(),
          ),
          BlocProvider(
            create: (c) => FeedBackRoundsBloc(c.read<ConverseRepository>())
              ..streamFeedBackRounds(),
          ),
          BlocProvider(
            create: (c) =>
                MediasBloc(c.read<ConverseRepository>())..streamMedias(),
          ),
          BlocProvider(
            create: (c) =>
                FeedsBloc(c.read<ConverseRepository>())..streamFeeds(),
          ),
          BlocProvider(
            create: (c) =>
                CommentsBloc(c.read<ConverseRepository>())..streamComments(),
          ),
        ],
        child: child,
      ),
    );
  }
}

class ConverseDataProvider extends StatelessWidget {
  final Reference ref;
  final IamService iamService;
  final ConverseRepository converseRepository;
  final Widget child;
  const ConverseDataProvider({
    super.key,
    required this.ref,
    required this.iamService,
    required this.converseRepository,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IamService>.value(value: iamService),
        RepositoryProvider<ConverseRepository>.value(value: converseRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (c) => AuthBloc(c.read<IamService>()),
          ),
          BlocProvider(
            create: (c) => LikeBloc(c.read<ConverseRepository>()),
          ),
          BlocProvider(
            create: (c) => FeedBackRoundBloc(c.read<ConverseRepository>()),
          ),
          BlocProvider(
            create: (c) => MediaBloc(c.read<ConverseRepository>()),
          ),
          BlocProvider(
            create: (c) => FeedBloc(c.read<ConverseRepository>()),
          ),
          BlocProvider(
            create: (c) => CommentBloc(c.read<ConverseRepository>()),
          ),
          BlocProvider(
            create: (c) =>
                LikesBloc(c.read<ConverseRepository>())..streamLikes(),
          ),
          BlocProvider(
            create: (c) => FeedBackRoundsBloc(c.read<ConverseRepository>())
              ..streamFeedBackRounds(),
          ),
          BlocProvider(
            create: (c) =>
                MediasBloc(c.read<ConverseRepository>())..streamMedias(),
          ),
          BlocProvider(
            create: (c) => FeedsBloc(c.read<ConverseRepository>())
              ..streamFeeds(includeBusinessId: false),
          ),
          BlocProvider(
            create: (c) =>
                CommentsBloc(c.read<ConverseRepository>())..streamComments(),
          ),
          BlocProvider(
            create: (c) => UploadBloc(ref),
          ),
        ],
        child: child,
      ),
    );
  }
}
