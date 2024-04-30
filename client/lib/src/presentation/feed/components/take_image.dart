import 'package:converse_client/src/blocs/feed_bloc.g.dart';
import 'package:converse_client/src/blocs/states/upload_state.dart';
import 'package:converse_client/src/blocs/upload_block.dart';
import 'package:converse_client/src/domain/entities/media.g.dart';
import 'package:converse_client/src/domain/enums/media_type.g.dart';
import 'package:converse_client/src/presentation/feed/components/feed_post_editor.dart';
import 'package:converse_client/src/presentation/feed/components/memor_image_builder.dart';
import 'package:converse_client/src/presentation/feed/components/networ_image_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class TakeImage extends StatefulWidget {
  final bool isUpdate;
  const TakeImage({
    super.key,
    this.isUpdate = false,
  });

  @override
  State<TakeImage> createState() => _TakeImageState();
}

class _TakeImageState extends State<TakeImage> {
  List<AppFile> files = [];
  bool select = false;
  bool showPickColor = false;
  bool isUploaded = false;
  bool again = false;

  double? hight;
  late bool update;
  late MediaType type;

  void resetOnPressed(BuildContext context) {
    context.read<FeedBloc>().setFeedHasbackRound(true);
    hight = null;
    select = false;
    setState(() {});
  }

  void aginOnPressed(BuildContext context) {
    if (type == MediaType.photo) {
      choseImageOnPressed(context);
    } else {
      choseVideoOnPressed(context);
    }
  }

  void choseVideoOnPressed(BuildContext context) async {
    final file = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (file != null) {
      type = MediaType.video;
      isUploaded = false;
      again = true;
      files = [
        AppFile(
          name: file.name,
          extension: file.name.split('.').last,
          data: await file.readAsBytes(),
          path: file.path,
          type: MediaType.video,
        )
      ];
      setFile(files);
      select = true;
      update = false;
      hight = 400;
      setState(() {});
    }
  }

  void setFile(List<AppFile> files) {
    context.read<UploadBloc>().setFiles(files);
    context.read<FeedBloc>().setFeedHasbackRound(false);
  }

  void choseImageOnPressed(BuildContext context) async {
    FilePickerResult? file;

    file = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (file != null) {
      type = MediaType.photo;
      isUploaded = false;
      again = true;
      files = file.files
          .map(
            (e) => AppFile(
              name: e.name,
              extension: e.extension!,
              data: e.bytes!,
              path: '',
              type: MediaType.photo,
            ),
          )
          .toList();
      setFile(files);
      select = true;
      update = false;
      hight = 400;
      setState(() {});
    }
  }

  @override
  void initState() {
    update = widget.isUpdate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isUpdate == true &&
        context.read<FeedBloc>().state.feed.hasbackRound == false) {
      hight = 400;
      select = true;
    }
    final imageDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: const Color.fromARGB(131, 240, 237, 241),
    );

    final buttonStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ));
    final takeImageButton = FilledButton(
      onPressed: () => choseImageOnPressed(context),
      style: buttonStyle,
      child: const Text("   Take Image   "),
    );
    final takeImage = Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: takeImageButton,
    );
    final takeVideoButton = FilledButton(
      onPressed: () => choseVideoOnPressed(context),
      style: buttonStyle,
      child: const Text("   Take Video    "),
    );
    final takeVideo = Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: takeVideoButton,
    );
    const takeImageIcon = Icon(
      Icons.photo,
      color: Colors.blue,
      size: 200,
    );

    final takeMediaBox = Container(
      width: double.infinity,
      decoration: imageDecoration,
      child: Column(
        children: [
          takeImageIcon,
          takeImage,
          const SizedBox(height: 5),
          takeVideo,
          const SizedBox(height: 25)
        ],
      ),
    );

    List<Media>? medias =
        widget.isUpdate ? context.read<FeedBloc>().state.feed.medias : [];

    final images = widget.isUpdate && again == false
        ? NetworkImageBuilder(medias: medias ?? [])
        : MemorImageBuilder(files: files);

    final retake = IconButton(
      onPressed: () => aginOnPressed(context),
      icon: const Icon(Icons.restart_alt_sharp),
    );

    final reset = IconButton(
      onPressed: () => resetOnPressed(context),
      icon: const Icon(Icons.close_rounded),
    );

    final details = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        reset,
        retake,
      ],
    );

    final item = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        details,
        const SizedBox(height: 10),
      ],
    );

    final moreIcon = item;

    final box = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        images,
        const Spacer(),
        moreIcon,
        const Spacer(),
      ],
    );

    final textEditor = Container(
      decoration: imageDecoration,
      height: hight,
      child: select ? box : FeedPostEditor(isUpdate: widget.isUpdate),
    );

    final sections = Column(
      children: [
        textEditor,
        const SizedBox(height: 15),
        select ? Container() : takeMediaBox,
      ],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: sections,
    );
  }
}
