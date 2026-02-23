class PaginatedResult<T> {
  final List<T> results;
  final int? nextPage;
  final int totalPages;

  const PaginatedResult({
    required this.results,
    required this.nextPage,
    required this.totalPages,
  });

  bool get hasMore => nextPage != null;
}
