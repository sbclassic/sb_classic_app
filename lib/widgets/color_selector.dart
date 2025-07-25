import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final Map<String, String> colors;
  final String selectedColor;
  final ValueChanged<String> onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: colors.entries.map((entry) {
        final colorName = entry.key;
        final isSelected = colorName == selectedColor;

        return GestureDetector(
          onTap: () => onColorSelected(colorName),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? Colors.black : Colors.grey),
              image: DecorationImage(
                image: NetworkImage(entry.value),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
