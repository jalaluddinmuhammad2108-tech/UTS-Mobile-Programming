import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  static const String host = 'openlibrary.org';

  Future<List<Book>> fetchBooks({
    String query = 'subject:fiction',
    String sort = 'rating',
  }) async {
    final uri = Uri.https(host, '/search.json', {
      'q': query,
      'limit': '30',
      'sort': sort,
      'fields':
          'key,title,author_name,first_publish_year,cover_i,number_of_pages_median,edition_count,subject',
    });

    final response =
        await http.get(uri).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Server merespons dengan kode ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = (data['docs'] as List?) ?? [];
    return docs.map((e) => Book.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<String> fetchDescription(String workKey) async {
    final response = await http
        .get(Uri.https(host, '$workKey.json'))
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat deskripsi (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final desc = data['description'];
    if (desc is String) return desc;
    if (desc is Map && desc['value'] != null) return '${desc['value']}';
    return 'Deskripsi belum tersedia untuk buku ini.';
  }
}
