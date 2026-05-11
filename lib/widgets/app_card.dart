import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) return card;

    return InkWell(
      borderRadius: (Theme.of(context).cardTheme.shape as RoundedRectangleBorder?)
              ?.borderRadius
              .resolve(Directionality.of(context)) ??
          BorderRadius.circular(16),
      onTap: onTap,
      child: card,
    );
  }
}

