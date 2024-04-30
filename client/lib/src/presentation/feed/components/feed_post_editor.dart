import 'package:converse_client/converse_client.dart';
import 'package:converse_client/src/domain/entities/feed_back_round.g.dart';
import 'package:converse_client/src/presentation/feed/components/color_box.dart';
import 'package:converse_client/src/presentation/feed/components/popup.dart';
import 'package:converse_client/src/presentation/feed/components/select_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedPostEditor extends StatefulWidget {
  final bool isUpdate;
  const FeedPostEditor({super.key, required this.isUpdate});

  @override
  State<FeedPostEditor> createState() => _FeedPostEditorState();
}

class _FeedPostEditorState extends State<FeedPostEditor> {
  int bRed = 0;
  int bGreen = 0;
  int bBlue = 0;
  int bAccent = 200;
  int tRed = 13;
  int tGreen = 214;
  int tBlue = 12;
  int tAccent = 200;
  double textFont = 24;
  bool showColor = true;
  bool showBackroundColor = true;
  bool showTextColor = false;
  bool textSelect = false;
  bool backroundColorSelect = true;
  bool textColorSelect = false;
  bool fontSelect = false;

  bool notText = true;
  TextEditingController inputConroller = TextEditingController();
  @override
  void initState() {
    try {
      final feed = context.read<FeedBloc>().state.feed;
      if (feed.hasbackRound == true) {
        notText = false;
        bRed = feed.backRound!.backroundRedValue ?? 0;
        bGreen = feed.backRound!.backroundGreenValue ?? 0;
        bBlue = feed.backRound!.backroundBlueValue ?? 0;
        bAccent = feed.backRound!.backroundAccentValue ?? 200;
        tRed = feed.backRound!.contentRedValue ?? 0;
        tGreen = feed.backRound!.contentgreenValue ?? 0;
        tBlue = feed.backRound!.contentBlueValue ?? 0;
        tAccent = feed.backRound!.contenAccentValue ?? 200;
        inputConroller = TextEditingController.fromValue(
          TextEditingValue(text: feed.backRound?.content ?? ''),
        );
      }
    } catch (e) {}
    super.initState();
  }

  void backroundOnPressed() {
    textColorSelect = false;
    textSelect = false;
    backroundColorSelect = true;
    fontSelect = false;
    if (showBackroundColor == false) {
      showBackroundColor = true;
      showTextColor = false;
    }
    if (showColor == false) {
      showColor = true;
    }
    setState(() {});
  }

  void textColorOnPressed() {
    textColorSelect = true;
    textSelect = false;
    backroundColorSelect = false;
    fontSelect = false;
    if (showTextColor == false) {
      showBackroundColor = false;
      showTextColor = true;
    }

    if (showColor == false) {
      showColor = true;
    }
    setState(() {});
  }

  void changeBC(int red, int green, int blue) {
    if (showTextColor) {
      setState(() {
        tRed = red;
        tGreen = green;
        tBlue = blue;
      });
    } else {
      setState(() {
        bRed = red;
        bGreen = green;
        bBlue = blue;
      });
    }
  }

  void enterText() {
    textColorSelect = false;
    textSelect = true;
    backroundColorSelect = false;
    fontSelect = false;
    if (notText == false && inputConroller.text.isEmpty) {
      setState(() {
        notText = true;
      });
    } else {
      setState(() {
        notText = false;
      });
    }
  }

  void fontOnPressed(double font) {
    setState(() {
      textFont = font;
      Navigator.of(context).pop();
    });
  }

  void onSavedState(String? vl, BuildContext context) {
    FeedBackRound feedBackRound = const FeedBackRound.init();
    feedBackRound = feedBackRound.copyWith(
      content: vl,
      contentRedValue: tRed,
      contentgreenValue: tGreen,
      contentBlueValue: tBlue,
      contenAccentValue: tAccent,
      backroundRedValue: bRed,
      backroundGreenValue: bGreen,
      backroundBlueValue: bBlue,
      backroundAccentValue: bAccent,
      fontSize: textFont,
    );
    context.read<FeedBloc>().setFeedBackRound(feedBackRound);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const addTextIcon = Icon(
      Icons.text_fields_rounded,
      color: Colors.blue,
    );
    final addtext = SelectButton(
      icon: addTextIcon,
      callBack: enterText,
      selected: textSelect,
    );
    final pickBackroundColorIcon = Icon(
      Icons.color_lens_rounded,
      color: Color.fromARGB(bAccent, bRed, bGreen, bBlue),
    );
    final pickBackroundColor = SelectButton(
      icon: pickBackroundColorIcon,
      callBack: backroundOnPressed,
      text: "Background",
      color: Color.fromARGB(bAccent, bRed, bGreen, bBlue),
      selected: backroundColorSelect,
    );
    final pickTextColorIcon = Icon(
      Icons.format_color_text_rounded,
      color: Color.fromARGB(tAccent, tRed, tGreen, tBlue),
    );

    final pickTextColor = SelectButton(
      icon: pickTextColorIcon,
      callBack: textColorOnPressed,
      text: "textColor",
      color: Color.fromARGB(tAccent, tRed, tGreen, tBlue),
      selected: textColorSelect,
    );

    const pickTextFontIcon = Icon(
      Icons.font_download,
      color: Color.fromARGB(200, 50, 50, 50),
    );

    List<PopUp> items = [
      PopUp(
        child: TextButton(
          onPressed: () => fontOnPressed(5),
          child: const Text("5"),
        ),
      ),
      PopUp(
        child: TextButton(
          onPressed: () => fontOnPressed(10),
          child: const Text("10"),
        ),
      ),
      PopUp(
        child: TextButton(
          onPressed: () => fontOnPressed(14),
          child: const Text("14"),
        ),
      ),
      PopUp(
        child: TextButton(
          onPressed: () => fontOnPressed(16),
          child: const Text("16"),
        ),
      ),
      PopUp(
        child: TextButton(
          onPressed: () => fontOnPressed(18),
          child: const Text("18"),
        ),
      ),
      PopUp(
        child: TextButton(
          onPressed: () => fontOnPressed(20),
          child: const Text("20"),
        ),
      ),
      PopUp(
        child: TextButton(
          onPressed: () => fontOnPressed(22),
          child: const Text("22"),
        ),
      ),
      PopUp(
        child: TextButton(
          onPressed: () => fontOnPressed(24),
          child: const Text("24"),
        ),
      ),
      PopUp(
        child: TextButton(
          onPressed: () => fontOnPressed(26),
          child: const Text("26"),
        ),
      ),
      PopUp(
        child: TextButton(
          onPressed: () => fontOnPressed(28),
          child: const Text("28"),
        ),
      ),
      PopUp(
        child: TextButton(
          onPressed: () => fontOnPressed(30),
          child: const Text("30"),
        ),
      ),
    ];
    final pickTextFont = PopupMenuButton(
      elevation: 0.9,
      tooltip: 'Fonts',
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      icon: pickTextFontIcon,
      color: theme.scaffoldBackgroundColor,
      clipBehavior: Clip.antiAlias,
      itemBuilder: (c) => items,
    );

    List<ColorBox> colors = [
      ColorBox(
        red: 0,
        green: 0,
        blue: 0,
        onClick: () => changeBC(0, 0, 0),
      ),
      ColorBox(
        red: 250,
        green: 250,
        blue: 250,
        onClick: () => changeBC(250, 250, 250),
      ),
      ColorBox(
        red: 214,
        green: 51,
        blue: 13,
        onClick: () => changeBC(241, 51, 13),
      ),
      ColorBox(
        red: 214,
        green: 130,
        blue: 11,
        onClick: () => changeBC(214, 130, 11),
      ),
      ColorBox(
        red: 214,
        green: 211,
        blue: 8,
        onClick: () => changeBC(214, 211, 8),
      ),
      ColorBox(
        red: 121,
        green: 214,
        blue: 8,
        onClick: () => changeBC(121, 214, 8),
      ),
      ColorBox(
        red: 13,
        green: 214,
        blue: 12,
        onClick: () => changeBC(13, 214, 12),
      ),
      ColorBox(
        red: 11,
        green: 214,
        blue: 153,
        onClick: () => changeBC(11, 214, 153),
      ),
      ColorBox(
        red: 8,
        green: 209,
        blue: 214,
        onClick: () => changeBC(8, 201, 214),
      ),
      ColorBox(
        red: 9,
        green: 127,
        blue: 214,
        onClick: () => changeBC(9, 127, 214),
      ),
      ColorBox(
        red: 9,
        green: 16,
        blue: 214,
        onClick: () => changeBC(9, 16, 214),
      ),
      ColorBox(
        red: 132,
        green: 9,
        blue: 214,
        onClick: () => changeBC(132, 9, 214),
      ),
      ColorBox(
        red: 190,
        green: 11,
        blue: 214,
        onClick: () => changeBC(190, 11, 214),
      ),
      ColorBox(
        red: 214,
        green: 10,
        blue: 181,
        onClick: () => changeBC(214, 10, 181),
      ),
      ColorBox(
        red: 214,
        green: 12,
        blue: 82,
        onClick: () => changeBC(214, 12, 82),
      ),
      ColorBox(
        red: 187,
        green: 174,
        blue: 214,
        onClick: () => changeBC(187, 174, 214),
      ),
      ColorBox(
        red: 219,
        green: 163,
        blue: 117,
        onClick: () => changeBC(219, 163, 117),
      ),
      ColorBox(
        red: 219,
        green: 179,
        blue: 152,
        onClick: () => changeBC(219, 179, 152),
      ),
      ColorBox(
        red: 219,
        green: 209,
        blue: 200,
        onClick: () => changeBC(219, 209, 200),
      ),
      ColorBox(
        red: 203,
        green: 219,
        blue: 197,
        onClick: () => changeBC(187, 174, 214),
      ),
      ColorBox(
        red: 219,
        green: 173,
        blue: 195,
        onClick: () => changeBC(219, 173, 195),
      ),
      ColorBox(
        red: 189,
        green: 181,
        blue: 219,
        onClick: () => changeBC(187, 174, 214),
      ),
    ];

    final colorList = ListView(
      scrollDirection: Axis.horizontal,
      children: colors,
    );

    final colorBox = SizedBox(
      height: 40,
      width: double.infinity,
      child: colorList,
    );
    final editeStep = Row(
      children: [
        addtext,
        pickBackroundColor,
        pickTextColor,
        pickTextFont,
      ],
    );

    final editeStepPadding = Padding(
      padding: const EdgeInsets.all(5),
      child: editeStep,
    );

    final hintStyle = TextStyle(
      fontSize: textFont,
      color: Color.fromARGB(200, tRed, tGreen, tBlue),
    );
    final backroundText = TextFormField(
      readOnly: notText,
      autofocus: true,
      textAlign: TextAlign.center,
      onSaved: (vl) => onSavedState(vl, context),
      controller: inputConroller,
      style: hintStyle,
      minLines: null,
      maxLines: null,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        hintStyle: hintStyle,
        hintText: notText ? "" : "A",
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );

    final backroundBox = Container(
      alignment: Alignment.center,
      height: 310,
      width: double.infinity,
      color: Color.fromARGB(200, bRed, bGreen, bBlue),
      child: backroundText,
    );

    final backround = GestureDetector(
      onDoubleTap: () => enterText(),
      child: backroundBox,
    );
    final cover = Column(
      children: [
        editeStepPadding,
        backround,
        const SizedBox(height: 5),
        showColor ? colorBox : Container(),
        const SizedBox(height: 10)
      ],
    );
    return SizedBox(
      child: cover,
    );
  }
}
