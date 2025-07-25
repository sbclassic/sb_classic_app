import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../widgets/featured_product_card.dart';
import '../data/products.dart';
import '../utils/cart.dart';
import 'clothes_screen.dart';
import 'shoes_screen.dart';
import 'accessories_screen.dart';
import 'slippers_sandals_screen.dart';
import 'product_details_screen.dart';
import 'cart_screen.dart';
import '../data/products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'SB Classic',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (CartManager.cartItems.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      '${CartManager.cartItems.length}',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Category Buttons
            CategoryCard(
              title: 'Clothes',
              icon: Icons.checkroom,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClothesScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            CategoryCard(
              title: 'Shoes',
              icon: Icons.directions_walk,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShoesScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            CategoryCard(
              title: 'Accessories',
              icon: Icons.watch,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AccessoriesScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            CategoryCard(
              title: 'Slippers/Sandals',
              icon: Icons.flip,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SlippersSandalsScreen()),
                );
              },
            ),
            const SizedBox(height: 20),

            // Featured Products Header
            const Text(
              'Featured Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Featured Product Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 4,
              children: allProducts
                  .where((product) => product['featured'] == true)
                  .map((product) {
                return FeaturedProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                );
              })
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
