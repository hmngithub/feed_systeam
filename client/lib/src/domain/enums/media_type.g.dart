enum MediaType {
  photo,
  video,
}

extension MediaTypeParser on MediaType {
  bool get isPhoto => this == MediaType.photo;
  bool get isVideo => this == MediaType.video;
  static MediaType fromName(String? name, [MediaType value = MediaType.photo]) {
    if (name == null) return value;
    try {
      return MediaType.values.byName(name);
    } catch (err) {
      return value;
    }
  }
}
