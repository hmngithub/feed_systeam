import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date, BuildContext context) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 365) {
    return DateFormat.yMMMd().format(date);
  } else if (difference.inDays >= 2) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours == 1) {
    return 'An hour ago';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inMinutes == 1) {
    return 'A minute ago';
  } else {
    return 'Just now';
  }
}
