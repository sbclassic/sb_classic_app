import 'package:flutter/material.dart';

class SizeDropdown extends StatelessWidget {
  final List<String> sizes;
  final String selectedSize;
  final ValueChanged<String?>? onChanged; // ✅ Make this nullable

  const SizeDropdown({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedSize,
      isExpanded: true,
      onChanged: onChanged,
      items: sizes.map((size) {
        return DropdownMenuItem(
          value: size,
          child: Text(size),
        );
      }).toList(),
    );
  }
}
