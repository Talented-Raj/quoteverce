import 'package:flutter/material.dart';
import 'action_button.dart';
import 'glass_container.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 64,
            color: theme.colorScheme.error.withOpacity(0.8),
          ),
          const SizedBox(height: 16),
          Text(
            'Connection Error',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ActionButton(
            icon: Icons.refresh_rounded,
            label: 'Retry Connection',
            onTap: onRetry,
            color: theme.colorScheme.error.withOpacity(0.08),
          ),
        ],
      ),
    );
  }
}
