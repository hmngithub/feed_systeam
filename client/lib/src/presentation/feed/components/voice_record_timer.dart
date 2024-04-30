import 'dart:async';

import 'package:flutter/material.dart';

class VoiceRecordTimer extends StatefulWidget {
  const VoiceRecordTimer({super.key});

  @override
  State<VoiceRecordTimer> createState() => _VoiceRecordTimerState();
}

class _VoiceRecordTimerState extends State<VoiceRecordTimer> {
  int menut = 0;
  int second = 0;
  String data = "00:00";
  late Timer timer;

  void format() {
    if (second < 10 && menut < 10) {
      data = "0$menut:0$second";
      return;
    }
    if (second < 10) {
      data = "$menut:0$second";
      return;
    }
    if (menut < 10) {
      data = "0$menut:$second";
    }
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (second == 60) {
          menut += 1;
          second = 0;
          format();
          return;
        }
        second += 1;
        format();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    timer;
    return Text(data);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
