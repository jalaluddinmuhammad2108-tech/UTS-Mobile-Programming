import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../widgets/book_card.dart';

class DetailPage extends StatefulWidget {
  final Book book;
  const DetailPage({super.key, required this.book});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<String> _desc;

  @override
  void initState() {
    super.initState();
    _desc = BookService().fetchDescription(widget.book.key);
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.book;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130,
                height: 190,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(tag: b.key, child: BookCover(book: b, size: 'L')),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.title,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(b.authorText),
                    const SizedBox(height: 12),
                    _info(Icons.calendar_today, 'Terbit pertama',
                        b.firstPublishYear?.toString() ?? '-'),
                    _info(Icons.description, 'Halaman',
                        b.pages?.toString() ?? '-'),
                    _info(Icons.library_books, 'Jumlah edisi',
                        '${b.editionCount}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (b.subjects.isNotEmpty) ...[
            Text('Subjek', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: b.subjects.map((s) => Chip(label: Text(s))).toList(),
            ),
            const SizedBox(height: 20),
          ],
          Text('Deskripsi', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FutureBuilder<String>(
            future: _desc,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snap.hasError) {
                return Row(
                  children: [
                    const Icon(Icons.error_outline),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Gagal memuat deskripsi.')),
                    TextButton(
                      onPressed: () => setState(() => _desc =
                          BookService().fetchDescription(widget.book.key)),
                      child: const Text('Ulangi'),
                    ),
                  ],
                );
              }
              return Text(snap.data ?? '-', style: const TextStyle(height: 1.5));
            },
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Expanded(child: Text('$label: $value')),
          ],
        ),
      );
}
