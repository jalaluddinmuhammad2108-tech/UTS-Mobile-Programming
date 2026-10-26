import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../widgets/book_card.dart';
import 'detail_page.dart';

class _Category {
  final String name;
  final String query; // dipakai pada parameter q Google Books API
  final IconData icon;
  const _Category(this.name, this.query, this.icon);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _service = BookService();
  final _searchCtrl = TextEditingController();


  static const _allQuery = 'books';

  static const _categories = <_Category>[
    _Category('Fiksi', 'subject:fiction', Icons.auto_stories),
    _Category('Fantasi', 'subject:fantasy', Icons.auto_fix_high),
    _Category('Sains', 'subject:science', Icons.science),
    _Category('Sejarah', 'subject:history', Icons.history_edu),
    _Category('Romansa', 'subject:romance', Icons.favorite),
    _Category('Teknologi', 'subject:programming', Icons.computer),
    _Category('Bisnis', 'subject:business', Icons.business_center),
    _Category('Biografi', 'subject:biography', Icons.person),
    _Category('Misteri', 'subject:mystery', Icons.travel_explore),
    _Category('Psikologi', 'subject:psychology', Icons.psychology),
    _Category('Seni', 'subject:art', Icons.palette),
    _Category('Anak-anak', 'subject:juvenile fiction', Icons.child_care),
  ];

  late Future<List<Book>> _future;
  _Category? _category; // null = semua kategori
  String _text = ''; // teks pencarian
  String _sort = 'rating';

  /// Menggabungkan teks pencarian dan kategori menjadi satu query API.
  /// Contoh: "harry" + Fantasi  ->  "harry subject:fantasy"
  String get _query {
    final cat = _category?.query;
    if (_text.isEmpty) return cat ?? _allQuery;
    return cat == null ? _text : '$_text $cat';
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _service.fetchBooks(query: _query, sort: _sort);
  }

  void _reload() => setState(_load);

  void _search(String text) {
    _text = text.trim();
    _reload();
  }

  void _clearSearch() {
    _searchCtrl.clear();
    _text = '';
    _reload();
  }

  void _pickCategory(_Category? category) {
    _category = category;
    _reload();
  }

  /// Bottom sheet berisi daftar kategori.
  void _openCategorySheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Kategori Buku',
                    style: Theme.of(sheetContext)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      avatar: const Icon(Icons.apps, size: 18),
                      label: const Text('Semua'),
                      selected: _category == null,
                      onSelected: (_) {
                        Navigator.pop(sheetContext);
                        _pickCategory(null);
                      },
                    ),
                    for (final c in _categories)
                      ChoiceChip(
                        avatar: Icon(c.icon, size: 18),
                        label: Text(c.name),
                        selected: _category == c,
                        onSelected: (_) {
                          Navigator.pop(sheetContext);
                          _pickCategory(c);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Kategori',
            onPressed: _openCategorySheet,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Urutkan',
            onSelected: (v) {
              _sort = v;
              _reload();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'rating', child: Text('Rating tertinggi')),
              PopupMenuItem(value: 'new', child: Text('Terbaru')),
              PopupMenuItem(value: 'old', child: Text('Terlama')),
              PopupMenuItem(value: 'editions', child: Text('Edisi terbanyak')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // ---------- Search ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              controller: _searchCtrl,
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'Cari judul, penulis, atau topik...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Hapus',
                  onPressed: _clearSearch,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28)),
                isDense: true,
              ),
            ),
          ),

          // ---------- Judul daftar + tombol kategori ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: _category == null
                      ? Text('Semua Buku',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold))
                      : Align(
                    alignment: Alignment.centerLeft,
                    child: InputChip(
                      avatar: Icon(_category!.icon, size: 18),
                      label: Text(_category!.name),
                      // Tombol x untuk kembali ke "Semua Buku"
                      onDeleted: () => _pickCategory(null),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _openCategorySheet,
                  icon: const Icon(Icons.category_outlined),
                  label: const Text('Kategori'),
                ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _future,
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Memuat data buku...'),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off, size: 56),
                          const SizedBox(height: 12),
                          const Text('Terjadi kesalahan saat mengambil data.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('${snapshot.error}',
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _reload,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                // 3. EMPTY / SUCCESS
                final books = snapshot.data ?? [];
                if (books.isEmpty) {
                  return const Center(child: Text('Buku tidak ditemukan.'));
                }
                return RefreshIndicator(
                  onRefresh: () async => _reload(),
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, i) => BookCard(
                      book: books[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(book: books[i]),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}