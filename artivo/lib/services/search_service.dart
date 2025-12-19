class SearchService {
  Future<List<String>> suggest(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ['Suggestion 1', 'Suggestion 2', 'Suggestion 3'];
  }
}


