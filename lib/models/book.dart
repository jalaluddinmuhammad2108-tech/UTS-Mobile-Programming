class Book {
  final String key; // contoh: /works/OL45883W
  final String title;
  final List<String> authors;
  final int? firstPublishYear;
  final int? coverId;
  final int? pages;
  final int editionCount;
  final List<String> subjects;

  Book({
    required this.key,
    required this.title,
    required this.authors,
    this.firstPublishYear,
    this.coverId,
    this.pages,
    this.editionCount = 0,
    this.subjects = const [],
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      key: json['key'] as String? ?? '',
      title: json['title'] as String? ?? 'Tanpa judul',
      authors: (json['author_name'] as List?)?.map((e) => '$e').toList() ?? [],
      firstPublishYear: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
      pages: json['number_of_pages_median'] as int?,
      editionCount: json['edition_count'] as int? ?? 0,
      subjects:
          (json['subject'] as List?)?.take(6).map((e) => '$e').toList() ?? [],
    );
  }

  String get authorText =>
      authors.isEmpty ? 'Penulis tidak diketahui' : authors.join(', ');

  String? coverUrl([String size = 'M']) => coverId == null
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-$size.jpg';
}
