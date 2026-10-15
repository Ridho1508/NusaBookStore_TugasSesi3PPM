import 'package:flutter/foundation.dart';

import '../models/book.dart';

/// Satu baris di keranjang: buku + jumlahnya.
class CartItem {
  final Book book;
  int quantity;

  CartItem({required this.book, this.quantity = 1});

  int get subtotal => book.price * quantity;
}

class CartProvider extends ChangeNotifier {
  // Key = id buku, supaya buku yang sama tidak muncul dua kali.
  final Map<String, CartItem> _items = {};

  /// Daftar buku di keranjang.
  List<CartItem> get items => _items.values.toList();

  bool get isEmpty => _items.isEmpty;

  /// Jumlah seluruh buku (akumulasi quantity).
  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  /// Total harga seluruh buku.
  int get totalPrice =>
      _items.values.fold(0, (sum, item) => sum + item.subtotal);

  /// Tambah buku baru, atau tambah jumlahnya jika sudah ada.
  void addItem(Book book) {
    final existing = _items[book.id];
    if (existing != null) {
      existing.quantity++;
    } else {
      _items[book.id] = CartItem(book: book);
    }
    notifyListeners();
  }

  /// Kurangi jumlah buku; jika tinggal 1, buku dihapus dari keranjang.
  void removeItem(String bookId) {
    final existing = _items[bookId];
    if (existing == null) return;
    if (existing.quantity > 1) {
      existing.quantity--;
    } else {
      _items.remove(bookId);
    }
    notifyListeners();
  }

  /// Hapus satu buku sekaligus (berapa pun jumlahnya).
  void deleteItem(String bookId) {
    if (_items.remove(bookId) != null) {
      notifyListeners();
    }
  }

  /// Kosongkan keranjang.
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}