enum MessageType {
  text,
  url,
  photo,
  video,
  audio,
  document,
  location,
  emoje,
}

extension MessageTypeParser on MessageType {
  bool get isText => this == MessageType.text;
  bool get isUrl => this == MessageType.url;
  bool get isPhoto => this == MessageType.photo;
  bool get isVideo => this == MessageType.video;
  bool get isAudio => this == MessageType.audio;
  bool get isDocument => this == MessageType.document;
  bool get isLocation => this == MessageType.location;
  bool get isEmoje => this == MessageType.emoje;
  static MessageType fromName(String? name,
      [MessageType value = MessageType.text]) {
    if (name == null) return value;
    try {
      return MessageType.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}
