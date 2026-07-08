import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/opportunity.dart';
import 'browse_viewmodel.dart';
import 'opportunity_card.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<BrowseViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('PluggedIn'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: SearchBar(
                hintText: 'Search title, company or field…',
                leading: const Icon(Icons.search),
                onChanged: viewModel.setQuery,
              ),
            ),
            _FilterRow(viewModel: viewModel),
            Expanded(child: _buildBody(viewModel)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BrowseViewModel viewModel) {
    return switch (viewModel.state) {
      BrowseLoading() => const Center(child: CircularProgressIndicator()),
      BrowseError(message: final message) => _ErrorView(
          message: message,
          onRetry: viewModel.load,
        ),
      BrowseLoaded(visible: final visible) when visible.isEmpty =>
        const _EmptyView(),
      BrowseLoaded(visible: final visible) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          itemCount: visible.length,
          itemBuilder: (context, index) => OpportunityCard(
            opportunity: visible[index],
            today: viewModel.today,
          ),
        ),
    };
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.viewModel});

  final BrowseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _TypeFilterChip(viewModel: viewModel),
          const SizedBox(width: 8),
          _ProvinceFilterChip(viewModel: viewModel),
        ],
      ),
    );
  }
}

class _TypeFilterChip extends StatelessWidget {
  const _TypeFilterChip({required this.viewModel});

  final BrowseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final selected = viewModel.typeFilter;
    return MenuAnchor(
      builder: (context, controller, _) => FilterChip(
        label: Text(selected?.label ?? 'Type'),
        selected: selected != null,
        onSelected: (_) =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: () => viewModel.setTypeFilter(null),
          child: const Text('All types'),
        ),
        for (final type in OpportunityType.values)
          MenuItemButton(
            onPressed: () => viewModel.setTypeFilter(type),
            child: Text(type.label),
          ),
      ],
    );
  }
}

class _ProvinceFilterChip extends StatelessWidget {
  const _ProvinceFilterChip({required this.viewModel});

  final BrowseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final selected = viewModel.provinceFilter;
    return MenuAnchor(
      builder: (context, controller, _) => FilterChip(
        label: Text(selected?.label ?? 'Province'),
        selected: selected != null,
        onSelected: (_) =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: () => viewModel.setProvinceFilter(null),
          child: const Text('All provinces'),
        ),
        for (final province in Province.values)
          MenuItemButton(
            onPressed: () => viewModel.setProvinceFilter(province),
            child: Text(province.label),
          ),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text('No opportunities match your filters',
              style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
