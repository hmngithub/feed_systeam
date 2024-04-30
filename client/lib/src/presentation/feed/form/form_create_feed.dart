import 'package:converse_client/src/presentation/feed/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../blocs/auth_bloc.g.dart';
import '../../../blocs/auth_bloc.g.dart';
import '../../../blocs/feed_bloc.g.dart';
import '../../../blocs/upload_block.dart';

import '../components/take_image.dart';

class CreateFeed extends StatefulWidget {
  final bool isBottomSheet;
  final bool isUpdate;
  const CreateFeed({
    super.key,
    this.isBottomSheet = false,
    this.isUpdate = false,
  });

  @override
  State<CreateFeed> createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void postOnPressed(ThemeData theme) {
    print('1');
    formKey.currentState!.save();
    print(11);
    final file = context.read<UploadBloc>().state.files;
    print(111);
    print(file.isEmpty);
    bool hasBackround =
        context.read<FeedBloc>().state.feed.hasbackRound ?? false;
    if (hasBackround && widget.isUpdate) {
      print('2');
      context.read<UploadBloc>().setIsUpdate(true);
      context.read<UploadBloc>().setSucceded();
    } else if (file.isEmpty && widget.isUpdate) {
      print(3);
      context.read<UploadBloc>().setIsUpdate(true);
      context.read<UploadBloc>().setSucceded();
    } else if (file.isNotEmpty && widget.isUpdate) {
      print(4);
      context.read<UploadBloc>().setIsUpdate(true);
      context.read<UploadBloc>().uploadFile();
    } else if (file.isNotEmpty == true && widget.isUpdate == false) {
      print(5);
      final name = context.read<AuthBloc>().state.user.lastName;
      final lastName = context.read<AuthBloc>().state.user.firstName;
      final imageUrl = context.read<AuthBloc>().state.user.imageUrl;
      final id = context.read<AuthBloc>().state.user.id;
      context.read<FeedBloc>().setFeedCreatorFirstName(name);
      context.read<FeedBloc>().setFeedCreatorLastName(lastName);
      context.read<FeedBloc>().setFeedCreatorImageUrl(imageUrl);
      context.read<FeedBloc>().setFeedLikes(0);
      context.read<FeedBloc>().setFeedLastModifiedDate(DateTime.now());
      context.read<FeedBloc>().setFeedLastModifierId(id);
      context.read<UploadBloc>().setIsUpdate(false);
      context.read<FeedBloc>().setFeedLiked(false);
      context.read<FeedBloc>().setFeedHasbackRound(false);
      context.read<UploadBloc>().uploadFile();
    } else if (file.isEmpty && widget.isUpdate == false) {
      print(6);
      final name = context.read<AuthBloc>().state.user.lastName;
      final lastName = context.read<AuthBloc>().state.user.firstName;
      final imageUrl = context.read<AuthBloc>().state.user.imageUrl;
      final id = context.read<AuthBloc>().state.user.id;
      context.read<FeedBloc>().setFeedCreatorFirstName(name);
      context.read<FeedBloc>().setFeedCreatorLastName(lastName);
      context.read<FeedBloc>().setFeedCreatorImageUrl(imageUrl);
      context.read<FeedBloc>().setFeedLikes(0);
      context.read<FeedBloc>().setFeedHasbackRound(true);
      context.read<FeedBloc>().setFeedMedias([]);
      context.read<FeedBloc>().setFeedLastModifiedDate(DateTime.now());
      context.read<FeedBloc>().setFeedLastModifierId(id);
      context.read<UploadBloc>().setIsUpdate(false);
      context.read<FeedBloc>().setFeedLiked(false);
      context.read<UploadBloc>().setSucceded();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();
    final size = MediaQuery.of(context).size.height;

    void closeButtonOnPressed() {
      Navigator.pop(context);
    }

    double maxHeight;
    if (widget.isBottomSheet) {
      maxHeight = size;
    } else {
      maxHeight = 550;
    }
    final constraint = BoxConstraints(
      maxHeight: maxHeight,
      maxWidth: 500,
      minHeight: 350,
      minWidth: 200,
    );

    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      color: theme.dialogBackgroundColor,
    );
    const label = Text(
      "Create Feed",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
    final child1 = Expanded(
      child: Container(),
    );
    final child2 = Expanded(
      child: Container(
        alignment: AlignmentDirectional.center,
        child: label,
      ),
    );

    final closeButton = IconButton(
      isSelected: true,
      onPressed: closeButtonOnPressed,
      icon: const Icon(Icons.close),
    );
    final child3 = Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        alignment: AlignmentDirectional.bottomEnd,
        child: closeButton,
      ),
    );
    final step1 = Row(
      children: [child1, child2, child3],
    );

    String feedDetails = context.read<FeedBloc>().state.feed.content ?? '';
    final details = TextBox(
      initialValue: widget.isUpdate ? feedDetails : null,
      hintText: "Description",
      onSave: context.read<FeedBloc>().setFeedContent,
      maxHeight: 80,
      hintSize: 14,
    );

    final buttonStyle = ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    )));
    final String post = widget.isUpdate ? "Update" : "Post";
    final submitButton = FilledButton(
      onPressed: () => postOnPressed(theme),
      style: buttonStyle,
      child: Text(post),
    );
    final submit = Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      constraints: const BoxConstraints(maxWidth: 700, minWidth: 600),
      child: submitButton,
    );

    final listChild = SliverChildListDelegate([
      step1,
      details,
      TakeImage(isUpdate: widget.isUpdate),
    ]);
    final list = SliverList(delegate: listChild);
    final column = CustomScrollView(
      slivers: [list],
    );

    final padding = Padding(
      padding: const EdgeInsets.all(5),
      child: Scaffold(
        body: column,
        bottomNavigationBar: submit,
      ),
    );
    final form = Form(
      key: formKey,
      child: padding,
    );
    final box = Container(
      constraints: constraint,
      decoration: decoration,
      child: form,
    );

    if (widget.isBottomSheet) {
      return SafeArea(child: box);
    }
    return SafeArea(child: Center(child: box));
  }
}
