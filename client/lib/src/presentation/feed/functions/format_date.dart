String dateFormat(DateTime? dateTime, bool isModified) {
  String editText = isModified ? 'edited' : '';
  if (dateTime == null) {
    return '$editText now';
  }
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return '$editText now';
  } else if (difference.inMinutes < 60) {
    return '$editText ${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '$editText ${difference.inHours}h ago';
  } else if (dateTime.day == now.day &&
      dateTime.month == now.month &&
      dateTime.year == now.year) {
    // Same day
    return '$editText today at ${dateTime.hour}:${dateTime.minute}';
  } else if (difference.inDays == 1) {
    // Yesterday
    return '$editText yesterday at ${dateTime.hour}:${dateTime.minute}';
  } else if (difference.inDays == 2) {
    // 2 days ago
    return '$editText 2 days ago';
  } else {
    // Default date format
    return '$editText ${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
