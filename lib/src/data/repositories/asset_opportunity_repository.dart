import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle;

import '../../domain/models/opportunity.dart';
import '../../domain/repositories/opportunity_repository.dart';

/// Loads the bundled seed dataset from assets. JSON field names and parsing
/// stay in this file — the rest of the app only sees domain models.
///
/// Swapping this for a backend-driven implementation later means implementing
/// [OpportunityRepository] again; nothing above the domain contract changes.
class AssetOpportunityRepository implements OpportunityRepository {
  AssetOpportunityRepository({required AssetBundle bundle}) : _bundle = bundle;

  final AssetBundle _bundle;

  static const _assetPath = 'assets/opportunities.json';

  @override
  Future<List<Opportunity>> allOpportunities() async {
    final Map<String, dynamic> json;
    try {
      final raw = await _bundle.loadString(_assetPath);
      json = jsonDecode(raw) as Map<String, dynamic>;
    } on FormatException {
      throw const OpportunityException(
          'The opportunity data is corrupted. Please reinstall the app.');
    } catch (_) {
      throw const OpportunityException('Could not load opportunities.');
    }

    final items = json['opportunities'] as List<dynamic>? ?? const [];
    return items.cast<Map<String, dynamic>>().map(_parse).toList();
  }

  Opportunity _parse(Map<String, dynamic> item) {
    final closing = item['closingDate'] as String?;
    return Opportunity(
      id: item['id'] as String,
      title: item['title'] as String,
      organisation: item['organisation'] as String,
      type: OpportunityType.values.byName(item['type'] as String),
      province: Province.values.byName(item['province'] as String),
      field: item['field'] as String,
      description: item['description'] as String,
      closingDate: closing == null ? null : DateTime.parse(closing),
    );
  }
}
