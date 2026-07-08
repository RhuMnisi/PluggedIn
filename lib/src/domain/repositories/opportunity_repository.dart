import '../models/opportunity.dart';

/// Contract for fetching opportunities. The UI depends on this abstraction so
/// the source can evolve — bundled seed data today, a real backend later —
/// without the rest of the app changing.
abstract interface class OpportunityRepository {
  Future<List<Opportunity>> allOpportunities();
}

/// Thrown when opportunities can't be loaded.
class OpportunityException implements Exception {
  const OpportunityException(this.message);

  final String message;

  @override
  String toString() => message;
}
