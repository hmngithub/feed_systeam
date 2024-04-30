class GetListRequest {
  /// The `key` is the name of the column in the database and value is what you expect.
  /// You can use equality queries
  final Map<String, dynamic> isEqualToQueries;
  final Map<String, dynamic> isNotEqualToQueries;
  final Map<String, dynamic> isLessThanQueries;
  final Map<String, dynamic> isLessOrEqualToQueries;
  final Map<String, dynamic> isGreaterThanQueries;
  final Map<String, dynamic> isGreaterOrEqualToQueries;

  /// Must have single key value pair if you are using firestore
  final Map<String, dynamic> orQueries;
  final Map<String, bool> orderBy;
  final String? searchTag;
  final String? lastQueriedId;
  final int? limit;
  final bool isTotalCounted;

  const GetListRequest({
    required this.isEqualToQueries,
    required this.isNotEqualToQueries,
    required this.isLessThanQueries,
    required this.isLessOrEqualToQueries,
    required this.isGreaterThanQueries,
    required this.isGreaterOrEqualToQueries,
    required this.orQueries,
    required this.orderBy,
    required this.searchTag,
    required this.lastQueriedId,
    required this.limit,
    required this.isTotalCounted,
  });

  const GetListRequest.init({
    this.isEqualToQueries = const <String, dynamic>{},
    this.isNotEqualToQueries = const <String, dynamic>{},
    this.isLessThanQueries = const <String, dynamic>{},
    this.isLessOrEqualToQueries = const <String, dynamic>{},
    this.isGreaterThanQueries = const <String, dynamic>{},
    this.isGreaterOrEqualToQueries = const <String, dynamic>{},
    this.orQueries = const <String, dynamic>{},
    this.orderBy = const <String, bool>{},
    this.searchTag,
    this.lastQueriedId,
    this.limit = 11,
    this.isTotalCounted = false,
  });

  GetListRequest copyWith({
    Map<String, dynamic>? isEqualToQueries,
    Map<String, dynamic>? isNotEqualToQueries,
    Map<String, dynamic>? isLessThanQueries,
    Map<String, dynamic>? isLessOrEqualToQueries,
    Map<String, dynamic>? isGreaterThanQueries,
    Map<String, dynamic>? isGreaterOrEqualToQueries,
    Map<String, dynamic>? orQueries,
    Map<String, bool>? orderBy,
    String? searchTag,
    String? lastQueriedId,
    int? limit,
    bool? isTotalCounted,
  }) {
    return GetListRequest(
      isEqualToQueries: isEqualToQueries ?? this.isEqualToQueries,
      isNotEqualToQueries: isNotEqualToQueries ?? this.isNotEqualToQueries,
      isLessThanQueries: isLessThanQueries ?? this.isLessThanQueries,
      isLessOrEqualToQueries:
          isLessOrEqualToQueries ?? this.isLessOrEqualToQueries,
      isGreaterThanQueries: isGreaterThanQueries ?? this.isGreaterThanQueries,
      isGreaterOrEqualToQueries:
          isGreaterOrEqualToQueries ?? this.isGreaterOrEqualToQueries,
      orQueries: orQueries ?? this.orQueries,
      orderBy: orderBy ?? this.orderBy,
      searchTag: searchTag ?? this.searchTag,
      lastQueriedId: lastQueriedId ?? this.lastQueriedId,
      limit: limit ?? this.limit,
      isTotalCounted: isTotalCounted ?? this.isTotalCounted,
    );
  }
}
