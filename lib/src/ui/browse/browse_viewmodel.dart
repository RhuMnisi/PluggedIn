import 'package:flutter/foundation.dart';

import '../../domain/models/opportunity.dart';
import '../../domain/repositories/opportunity_repository.dart';

/// Single source of truth for the browse screen: owns the full dataset,
/// the active filters, and the resulting visible list.
class BrowseViewModel extends ChangeNotifier {
  BrowseViewModel({
    required OpportunityRepository repository,
    DateTime Function()? now,
  })  : _repository = repository,
        _now = now ?? DateTime.now;

  final OpportunityRepository _repository;

  /// Injectable so tests can pin "today" for closing-date logic.
  final DateTime Function() _now;

  BrowseState _state = const BrowseState.loading();
  BrowseState get state => _state;

  List<Opportunity> _all = const [];
  String _query = '';
  OpportunityType? _typeFilter;
  Province? _provinceFilter;

  String get query => _query;
  OpportunityType? get typeFilter => _typeFilter;
  Province? get provinceFilter => _provinceFilter;

  DateTime get today => _now();

  Future<void> load() async {
    _emit(const BrowseState.loading());
    try {
      _all = await _repository.allOpportunities();
      _applyFilters();
    } on OpportunityException catch (e) {
      _emit(BrowseState.error(e.message));
    }
  }

  void setQuery(String query) {
    _query = query;
    _applyFilters();
  }

  void setTypeFilter(OpportunityType? type) {
    _typeFilter = type;
    _applyFilters();
  }

  void setProvinceFilter(Province? province) {
    _provinceFilter = province;
    _applyFilters();
  }

  void _applyFilters() {
    final needle = _query.trim().toLowerCase();
    final today = _now();

    final visible = _all.where((o) {
      if (_typeFilter != null && o.type != _typeFilter) return false;
      if (_provinceFilter != null && o.province != _provinceFilter) {
        return false;
      }
      // Hide opportunities whose closing date has passed.
      final daysLeft = o.daysUntilClose(today);
      if (daysLeft != null && daysLeft < 0) return false;
      if (needle.isEmpty) return true;
      return o.title.toLowerCase().contains(needle) ||
          o.organisation.toLowerCase().contains(needle) ||
          o.field.toLowerCase().contains(needle);
    }).toList()
      // Soonest deadline first; open-ended (rolling) entries at the end.
      ..sort((a, b) {
        final da = a.closingDate;
        final db = b.closingDate;
        if (da == null && db == null) return a.title.compareTo(b.title);
        if (da == null) return 1;
        if (db == null) return -1;
        return da.compareTo(db);
      });

    _emit(BrowseState.loaded(visible));
  }

  void _emit(BrowseState next) {
    _state = next;
    notifyListeners();
  }
}

/// The finite set of states the browse screen can be in.
sealed class BrowseState {
  const BrowseState();

  const factory BrowseState.loading() = BrowseLoading;
  const factory BrowseState.loaded(List<Opportunity> visible) = BrowseLoaded;
  const factory BrowseState.error(String message) = BrowseError;
}

class BrowseLoading extends BrowseState {
  const BrowseLoading();
}

class BrowseLoaded extends BrowseState {
  const BrowseLoaded(this.visible);

  final List<Opportunity> visible;
}

class BrowseError extends BrowseState {
  const BrowseError(this.message);

  final String message;
}
