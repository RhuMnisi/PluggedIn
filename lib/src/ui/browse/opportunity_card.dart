import 'package:flutter/material.dart';

import '../../domain/models/opportunity.dart';

/// One opportunity in the browse list, with a deadline badge and a tap-through
/// detail sheet.
class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.today,
  });

  final Opportunity opportunity;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(opportunity.title,
                        style: theme.textTheme.titleMedium),
                  ),
                  _DeadlineBadge(opportunity: opportunity, today: today),
                ],
              ),
              const SizedBox(height: 4),
              Text(opportunity.organisation,
                  style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _Tag(opportunity.type.label),
                  _Tag(opportunity.province.label),
                  _Tag(opportunity.field),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(opportunity.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              '${opportunity.organisation} • ${opportunity.province.label}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(opportunity.description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            _DeadlineBadge(opportunity: opportunity, today: today),
          ],
        ),
      ),
    );
  }
}

class _DeadlineBadge extends StatelessWidget {
  const _DeadlineBadge({required this.opportunity, required this.today});

  final Opportunity opportunity;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysLeft = opportunity.daysUntilClose(today);

    final (label, urgent) = switch (daysLeft) {
      null => ('Rolling', false),
      0 => ('Closes today', true),
      1 => ('1 day left', true),
      final d when d <= 7 => ('$d days left', true),
      final d => ('$d days left', false),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: urgent
            ? theme.colorScheme.errorContainer
            : theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: urgent
              ? theme.colorScheme.onErrorContainer
              : theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: theme.textTheme.labelSmall),
    );
  }
}
