import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/product_card.dart';

class SlippersSandalsScreen extends StatefulWidget {
  const SlippersSandalsScreen({super.key});

  @override
  State<SlippersSandalsScreen> createState() => _SlippersSandalsScreenState();
}

class _SlippersSandalsScreenState extends State<SlippersSandalsScreen> {
  List<dynamic> slippers = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final String response = await rootBundle.loadString('assets/sb_classic_products.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      slippers = data.where((item) => item['category'] == 'Slippers/Sandals').toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slippers & Sandals')),
      body: slippers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: slippers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.68,
        ),
        itemBuilder: (context, index) {
          return ProductCard(product: slippers[index]);
        },
      ),
    );
  }
}
