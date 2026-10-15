import 'package:flutter/material.dart';

/// Model data buku.
class Book {
  final String id;
  final String title;
  final String author;
  final int price; // dalam Rupiah
  final IconData icon; // ikon placeholder pengganti gambar sampul

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    this.icon = Icons.menu_book,
  });
}

/// Mengubah angka menjadi format Rupiah, contoh: 85000 -> "Rp 85.000".
String formatRupiah(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return 'Rp $buffer';
}