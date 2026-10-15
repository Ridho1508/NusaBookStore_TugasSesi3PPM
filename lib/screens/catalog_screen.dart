import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'cart_screen.dart';

// Data contoh (harga hanya ilustrasi).
const List<Book> _books = [
  Book(
    id: 'b1',
    title: 'Laskar Pelangi',
    author: 'Andrea Hirata',
    price: 85000,
    icon: Icons.auto_stories,
  ),
  Book(
    id: 'b2',
    title: 'Bumi Manusia',
    author: 'Pramoedya Ananta Toer',
    price: 120000,
    icon: Icons.menu_book,
  ),
  Book(
    id: 'b3',
    title: 'Clean Code',
    author: 'Robert C. Martin',
    price: 350000,
    icon: Icons.code,
  ),
  Book(
    id: 'b4',
    title: 'Atomic Habits',
    author: 'James Clear',
    price: 99000,
    icon: Icons.bolt,
  ),
  Book(
    id: 'b5',
    title: 'Filosofi Teras',
    author: 'Henry Manampiring',
    price: 98000,
    icon: Icons.psychology,
  ),
];

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaBookstore'),
        actions: [
          // Tombol Light/Dark Mode
          Consumer<ThemeProvider>(
            builder: (context, theme, _) => IconButton(
              tooltip: theme.isDarkMode ? 'Mode terang' : 'Mode gelap',
              icon: Icon(theme.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => context.read<ThemeProvider>().toggleTheme(),
            ),
          ),
          // Ikon keranjang + badge jumlah item
          Consumer<CartProvider>(
            builder: (context, cart, _) => IconButton(
              tooltip: 'Keranjang',
              icon: Badge(
                isLabelVisible: cart.totalItems > 0,
                label: Text('${cart.totalItems}'),
                child: const Icon(Icons.shopping_cart),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _books.length,
        itemBuilder: (context, index) => _BookCard(book: _books[index]),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 90,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    book.icon,
                    size: 36,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(book.author, style: textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text(
                        formatRupiah(book.price),
                        style: textTheme.titleSmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Tambah ke Keranjang'),
                onPressed: () {
                  // Mengubah data -> context.read
                  context.read<CartProvider>().addItem(book);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('"${book.title}" ditambahkan ke keranjang'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}