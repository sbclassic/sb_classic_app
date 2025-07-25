import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartManager {
  static final List<Map<String, dynamic>> _cart = [];

  static List<Map<String, dynamic>> get cartItems => _cart;

  /// Loads cart from SharedPreferences
  static Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('sb_cart');
    if (saved != null) {
      final decoded = json.decode(saved) as List;
      _cart.clear();
      _cart.addAll(decoded.map((item) => Map<String, dynamic>.from(item)));
    }
  }

  /// Saves cart to SharedPreferences
  static Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sb_cart', json.encode(_cart));
  }

  static void addToCart(
      Map<String, dynamic> product,
      String selectedColor,
      String selectedSize,
      ) {
    final existing = _cart.indexWhere((item) =>
    item['product']['id'] == product['id'] &&
        item['color'] == selectedColor &&
        item['size'] == selectedSize);

    if (existing >= 0) {
      _cart[existing]['quantity'] += 1;
    } else {
      _cart.add({
        'product': product,
        'color': selectedColor,
        'size': selectedSize,
        'quantity': 1,
      });
    }

    saveCart(); // ✅ Save after update
  }

  static void increment(int index) {
    _cart[index]['quantity'] += 1;
    saveCart();
  }

  static void decrement(int index) {
    if (_cart[index]['quantity'] > 1) {
      _cart[index]['quantity'] -= 1;
    } else {
      _cart.removeAt(index);
    }
    saveCart();
  }

  static double totalPrice() {
    return _cart.fold(0, (sum, item) {
      return sum + (item['product']['price'] * item['quantity']);
    });
  }

  static void clear() {
    _cart.clear();
    saveCart();
  }
}
