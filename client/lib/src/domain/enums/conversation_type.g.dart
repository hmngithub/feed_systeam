enum ConversationType {
  oneToOne,
  group,
}

extension ConversationTypeParser on ConversationType {
  bool get isOneToOne => this == ConversationType.oneToOne;
  bool get isGroup => this == ConversationType.group;
  static ConversationType fromName(String? name,
      [ConversationType value = ConversationType.oneToOne]) {
    if (name == null) return value;
    try {
      return ConversationType.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}
