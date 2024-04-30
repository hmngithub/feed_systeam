import 'package:converse_client/src/blocs/feeds_bloc.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final inputController = TextEditingController();

  void onChange() {
    if (inputController.text.isEmpty) {
      // context.read<FeedsBloc>().setState(FeedsStateStatus.streamed);
      setState(() {});
    }
    if (inputController.text.length == 1) {
      setState(() {});
    }
  }

  void onSearch(BuildContext context) {
    if (inputController.text.isEmpty) return;
    context.read<FeedsBloc>().searchFeeds(
          inputController.text.toUpperCase(),
          includeBusinessId: true,
        );
  }

  void onClear(BuildContext context) {
    setState(() {
      // context.read<FeedsBloc>().setState(FeedsStateStatus.streamed);
      inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const firstChildIcon = Icon(Icons.search);
    final firstChild = IconButton(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      visualDensity: VisualDensity.compact,
      splashRadius: 0.1,
      onPressed: () => onSearch(context),
      icon: firstChildIcon,
    );

    const searchConstraint = BoxConstraints(
      maxHeight: 35,
      minHeight: 30,
      maxWidth: 300,
      minWidth: 100,
    );
    final secondChild = TextField(
      onSubmitted: (vl) => onSearch(context),
      onChanged: (value) => onChange(),
      controller: inputController,
      style: const TextStyle(fontSize: 13),
      minLines: 1,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        isDense: true,
        constraints: searchConstraint,
        hintStyle: TextStyle(fontSize: 13),
        hintText: "Search",
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );

    final secondFlexable = Flexible(child: secondChild);

    const thirdChildIcon = Icon(Icons.clear);
    final thirdChild = IconButton(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      visualDensity: VisualDensity.compact,
      splashRadius: 0.1,
      onPressed: () => onClear(context),
      icon: thirdChildIcon,
    );

    final thirsChildValid =
        inputController.text.isNotEmpty ? thirdChild : const SizedBox();

    final items = Row(
      children: [firstChild, secondFlexable, thirsChildValid],
    );

    final decoration = BoxDecoration(
      color: theme.highlightColor,
      borderRadius: BorderRadius.circular(4),
    );

    const constraint = BoxConstraints(
      maxHeight: 35,
      minHeight: 30,
      maxWidth: 300,
      minWidth: 100,
    );
    return Container(
      constraints: constraint,
      decoration: decoration,
      child: items,
    );
  }
}
