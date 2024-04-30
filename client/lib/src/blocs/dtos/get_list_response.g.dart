class GetListResponse<Entity> {
  final int? totalCount;
  final List<Entity> entities;

  const GetListResponse({
    this.totalCount,
    this.entities = const [],
  });

  GetListResponse<Entity> copyWith({
    int? totalCount,
    List<Entity>? entities,
  }) {
    return GetListResponse<Entity>(
      totalCount: totalCount ?? this.totalCount,
      entities: entities ?? this.entities,
    );
  }
}
