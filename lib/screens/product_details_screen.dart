import 'package:flutter/material.dart';
import '../widgets/size_dropdown.dart';
import '../widgets/color_selector.dart';
import '../utils/cart.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late String selectedColor;
  late String selectedSize;

  @override
  void initState() {
    super.initState();

    selectedColor = widget.product['colors'].keys.first;

    final rawSize = widget.product['sizes'];
    final sizeList = rawSize.contains('-') ? generateSizeList(rawSize) : [rawSize];

    selectedSize = sizeList.first;
  }

  List<String> generateSizeList(String sizeRange) {
    if (sizeRange.contains('–')) {
      final parts = sizeRange.split('–');
      final start = parts[0];
      final end = parts[1];

      if (int.tryParse(start) != null && int.tryParse(end) != null) {
        final startNum = int.parse(start);
        final endNum = int.parse(end);
        return List.generate(endNum - startNum + 1, (i) => (startNum + i).toString());
      }

      return [start, 'M', 'L', 'XL', '2XL', '3XL', '4XL', '5XL', '6XL']
          .skipWhile((s) => s != start)
          .takeWhile((s) => s != end)
          .followedBy([end])
          .toList();
    }

    return [sizeRange];
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final imageUrl = product['colors'][selectedColor];

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name & Price
            Text(
              product['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '₵${product['price']}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // Size Selector
            const Text('Select Size', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizeDropdown(
              sizes: generateSizeList(product['sizes']),
              selectedSize: selectedSize,
              onChanged: (value) {
                setState(() {
                  selectedSize = value ?? selectedSize;
                });
              },
            ),
            const SizedBox(height: 24),

            // Color Selector
            const Text('Select Color', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ColorSelector(
              colors: product['colors'],
              selectedColor: selectedColor,
              onColorSelected: (value) {
                setState(() {
                  selectedColor = value;
                });
              },
            ),
            const SizedBox(height: 30),

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  CartManager.addToCart(product, selectedColor, selectedSize);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to cart: $selectedSize, $selectedColor'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Add to Cart', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),

            // Go to Cart Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.black),
                ),
                child: const Text('Go to Cart', style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
            ),
            const SizedBox(height: 12),

            // Buy Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  CartManager.clear();
                  CartManager.addToCart(product, selectedColor, selectedSize);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Buy Now', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
