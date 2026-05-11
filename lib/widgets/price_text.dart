import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  final double price;
  final TextStyle? style;

  const PriceText({super.key, required this.price, this.style});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = style ??
        theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.primary,
        );

    return Text("${price.toStringAsFixed(2)} TL", style: base);
  }
}

