import 'dart:typed_data';

import 'package:converse_client/src/blocs/upload_block.dart';
import 'package:converse_client/src/presentation/feed/components/voice_record_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';

class CahtTypeSection extends StatefulWidget {
  const CahtTypeSection({super.key});

  @override
  State<CahtTypeSection> createState() => _CahtTypeSectionState();
}

class _CahtTypeSectionState extends State<CahtTypeSection> {
  final inputController = TextEditingController();
  bool hasText = false;
  bool isMin = true;
  bool isRecording = false;

  String audioPath = '';
  List<Uint8List> audioBytes = [];

  void onChange() {
    if (isMin && inputController.text.isNotEmpty) {
      setState(() {
        hasText = true;
        isMin = false;
      });
    }
    if (inputController.text.isEmpty) {
      hasText = false;
      isMin = true;
      setState(() {});
    }
    if (inputController.text.length == 1) {
      hasText = true;
      isMin = false;
      setState(() {});
    }
  }

  void onBackMessage() {
    setState(() {
      isMin = true;
    });
  }

  final audioRecord = AudioRecorder();
  void onVoicePressed() async {
    // final player = AudioPlayer();
    // await player.play(UrlSource('https://example.com/my-audio.wav'));

    if (await audioRecord.hasPermission()) {
      setState(() {
        isRecording = true;
      });
      audioRecord.start(const RecordConfig(encoder: AudioEncoder.wav),
          path: 'audio.wav');
    }
  }

  void onDeleteVoice() async {
    setState(() {
      isRecording = false;
    });
    await audioRecord.stop();
    audioRecord.dispose();
  }

  void onSend() async {
    if (isRecording) {
      setState(() {
        isRecording = false;
      });
      final path = await audioRecord.stop();
      final url = Uri.parse(path ?? "");
      final result = await http.get(url);
      if (result.statusCode == 200) {
        final data = result.bodyBytes;
        // ignore: use_build_context_synchronously
        context.read<UploadBloc>().uploadVoice(data);
      }
    }
  }

  @override
  void dispose() {
    audioRecord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const moreIcon = Icon(
      Icons.add_circle_rounded,
      color: Colors.blue,
    );
    final more = IconButton(
      splashColor: theme.highlightColor,
      hoverColor: theme.highlightColor,
      focusColor: theme.highlightColor,
      highlightColor: theme.highlightColor,
      splashRadius: 0.1,
      onPressed: () {},
      icon: moreIcon,
    );

    const backIcon = Icon(
      Icons.arrow_forward_ios_outlined,
      color: Colors.blue,
    );
    final back = IconButton(
      splashColor: theme.highlightColor,
      hoverColor: theme.highlightColor,
      focusColor: theme.highlightColor,
      highlightColor: theme.highlightColor,
      splashRadius: 0.1,
      onPressed: onBackMessage,
      icon: backIcon,
    );

    const addMediaIcon = Icon(
      Icons.add_a_photo_rounded,
      color: Colors.blue,
    );
    final addMedia = IconButton(
      splashColor: theme.highlightColor,
      hoverColor: theme.highlightColor,
      focusColor: theme.highlightColor,
      highlightColor: theme.highlightColor,
      splashRadius: 0.1,
      onPressed: () {},
      icon: addMediaIcon,
    );
    const addPhotoIcon = Icon(
      Icons.photo,
      color: Colors.blue,
    );
    final addPhoto = IconButton(
      splashColor: theme.highlightColor,
      hoverColor: theme.highlightColor,
      focusColor: theme.highlightColor,
      highlightColor: theme.highlightColor,
      splashRadius: 0.1,
      onPressed: () {},
      icon: addPhotoIcon,
    );
    const voiceIcon = Icon(
      Icons.mic,
      color: Colors.blue,
    );
    final voice = IconButton(
      splashColor: theme.highlightColor,
      hoverColor: theme.highlightColor,
      focusColor: theme.highlightColor,
      highlightColor: theme.highlightColor,
      splashRadius: 0.1,
      onPressed: onVoicePressed,
      icon: voiceIcon,
    );
    const likeIcon = Icon(
      Icons.favorite,
      color: Colors.red,
    );
    final like = IconButton(
      splashColor: theme.highlightColor,
      hoverColor: theme.highlightColor,
      focusColor: theme.highlightColor,
      highlightColor: theme.highlightColor,
      splashRadius: 0.1,
      onPressed: () {},
      icon: likeIcon,
    );

    const sendIcon = Icon(
      Icons.send,
      color: Colors.blue,
    );
    final send = IconButton(
      splashColor: theme.highlightColor,
      hoverColor: theme.highlightColor,
      focusColor: theme.highlightColor,
      highlightColor: theme.highlightColor,
      splashRadius: 0.1,
      onPressed: onSend,
      icon: sendIcon,
    );

    const searchConstraint = BoxConstraints(
      maxHeight: 35,
      minHeight: 30,
      maxWidth: 300,
      minWidth: 80,
    );
    final secondChild = TextField(
      controller: inputController,
      maxLines: null,
      minLines: null,
      // onSubmitted: (vl) => onSearch(context),
      onChanged: (value) => onChange(),
      // controller: inputController,
      style: const TextStyle(fontSize: 13),
      expands: true,
      textInputAction: TextInputAction.newline,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        isDense: true,
        constraints: searchConstraint,
        hintStyle: TextStyle(fontSize: 13),
        hintText: "Aa",
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );

    final decoration = BoxDecoration(
      color: theme.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(15),
    );

    const constraint = BoxConstraints(
      maxHeight: 35,
      minHeight: 30,
      maxWidth: 300,
      minWidth: 80,
    );
    final childPadding = Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: secondChild,
    );
    final messageBox = Container(
      constraints: constraint,
      decoration: decoration,
      child: childPadding,
    );

    final message = Expanded(child: messageBox);
    final first = isMin ? more : back;
    final second = isMin ? addMedia : Container();
    final third = isMin ? addPhoto : Container();
    final fourth = isMin ? voice : Container();
    final fifth = hasText ? send : like;

    final defult = Row(
      children: [first, second, third, fourth, message, fifth],
    );
    const deleteRecordIcon = Icon(
      Icons.delete,
      color: Colors.red,
    );
    final deleteRecord = IconButton(
      splashColor: theme.highlightColor,
      hoverColor: theme.highlightColor,
      focusColor: theme.highlightColor,
      highlightColor: theme.highlightColor,
      splashRadius: 0.1,
      onPressed: onDeleteVoice,
      icon: deleteRecordIcon,
    );
    const spacer = Spacer();
    final voiceMode = Row(
      children: [deleteRecord, voice, const VoiceRecordTimer(), spacer, send],
    );
    return isRecording ? voiceMode : defult;
  }
}
