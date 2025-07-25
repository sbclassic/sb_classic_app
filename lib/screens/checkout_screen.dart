import 'package:flutter/material.dart';
import '../utils/cart.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      final cart = CartManager.cartItems;
      final itemsSummary = cart.map((item) {
        final p = item['product'];
        return '${p['name']} (${item['quantity']}x, Size: ${item['size']}, Color: ${item['color']})';
      }).join('\n');

      final message = '''
🛍 *SB Classic Order*
👤 Name: ${_nameController.text}
📞 Phone: ${_phoneController.text}
🏠 Address: ${_addressController.text}

🧾 *Order Summary:*
$itemsSummary

💵 Total: ₵${CartManager.totalPrice().toStringAsFixed(2)}

📝 Notes: ${_notesController.text}
''';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout submitted:\n$message')),
      );

      // You could later send this to WhatsApp or an API here
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartManager.cartItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...cart.map((item) {
              final p = item['product'];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(p['name']),
                subtitle: Text('Qty: ${item['quantity']} • Size: ${item['size']} • Color: ${item['color']}'),
              );
            }),
            Divider(height: 32),
            Text('Total: ₵${CartManager.totalPrice().toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Form fields
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Buyer Details', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) => value!.isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Delivery Address'),
                    validator: (value) => value!.isEmpty ? 'Enter address' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(labelText: 'Order Notes (optional)'),
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
