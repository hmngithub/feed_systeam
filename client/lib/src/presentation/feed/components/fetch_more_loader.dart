import 'package:converse_client/src/blocs/feeds_bloc.g.dart';
import 'package:converse_client/src/blocs/states/feeds_state.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FetchMoreLoader extends StatefulWidget {
  const FetchMoreLoader({
    super.key,
  });

  @override
  State<FetchMoreLoader> createState() => _FetchMoreLoaderState();
}

class _FetchMoreLoaderState extends State<FetchMoreLoader> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final loading = LoadingAnimationWidget.prograssiveDots(
      color: theme.highlightColor,
      size: 30,
    );
    final result = SizedBox(
      height: 70,
      width: double.infinity,
      child: Center(child: loading),
    );
    final builder = BlocBuilder<FeedsBloc, FeedsState>(
      builder: (context, state) {
        if (state.status.isFetchingMore) {
          return result;
        } else if (state.status.isFetchedMore) {
          return Container();
        } else {
          return Container();
        }
      },
    );

    return builder;
  }
}
