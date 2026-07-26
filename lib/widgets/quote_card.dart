import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import 'glass_container.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;

  const QuoteCard({
    super.key,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GlassContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.format_quote_rounded,
                size: 40,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  quote.category.toUpperCase(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 11,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quote Text
          Text(
            '"${quote.quote}"',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          // Divider
          Container(
            height: 1,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.3),
                  theme.colorScheme.secondary.withOpacity(0.05),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Author & Year
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '- ${quote.author}',
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (quote.year.toLowerCase() != 'unknown' && quote.year.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Year: ${quote.year}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Year circular indicator or static details
              Icon(
                Icons.favorite_border_rounded,
                color: theme.colorScheme.secondary.withOpacity(0.2),
                size: 24,
              )
            ],
          ),
        ],
      ),
    );
  }
}
extension on EdgeInsets {
  // Adding small helper extension for custom naming if needed
}
