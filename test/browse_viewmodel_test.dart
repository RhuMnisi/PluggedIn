import 'package:flutter_test/flutter_test.dart';
import 'package:pluggedin/src/domain/models/opportunity.dart';
import 'package:pluggedin/src/domain/repositories/opportunity_repository.dart';
import 'package:pluggedin/src/ui/browse/browse_viewmodel.dart';

/// Hand-rolled fake so the viewmodel can be tested without assets or IO.
class FakeOpportunityRepository implements OpportunityRepository {
  List<Opportunity> toReturn = [];
  OpportunityException? errorToThrow;

  @override
  Future<List<Opportunity>> allOpportunities() async {
    final error = errorToThrow;
    if (error != null) throw error;
    return toReturn;
  }
}

/// Pinned "today" so closing-date logic is deterministic.
final _today = DateTime(2026, 7, 9);

Opportunity _op(
  String id, {
  String title = 'Junior Developer',
  String organisation = 'Ubuntu Digital',
  OpportunityType type = OpportunityType.juniorJob,
  Province province = Province.gauteng,
  String field = 'Software Development',
  DateTime? closingDate,
}) {
  return Opportunity(
    id: id,
    title: title,
    organisation: organisation,
    type: type,
    province: province,
    field: field,
    description: 'desc',
    closingDate: closingDate,
  );
}

void main() {
  late FakeOpportunityRepository repository;
  late BrowseViewModel viewModel;

  setUp(() {
    repository = FakeOpportunityRepository();
    viewModel = BrowseViewModel(repository: repository, now: () => _today);
  });

  List<Opportunity> visible() =>
      (viewModel.state as BrowseLoaded).visible;

  group('load', () {
    test('emits loaded state with all open opportunities', () async {
      repository.toReturn = [
        _op('a', closingDate: DateTime(2026, 8, 1)),
        _op('b', closingDate: null),
      ];

      await viewModel.load();

      expect(viewModel.state, isA<BrowseLoaded>());
      expect(visible().length, 2);
    });

    test('hides opportunities whose closing date has passed', () async {
      repository.toReturn = [
        _op('open', closingDate: DateTime(2026, 8, 1)),
        _op('closed', closingDate: DateTime(2026, 7, 1)),
      ];

      await viewModel.load();

      expect(visible().map((o) => o.id), ['open']);
    });

    test('sorts by soonest deadline with rolling entries last', () async {
      repository.toReturn = [
        _op('rolling', closingDate: null),
        _op('later', closingDate: DateTime(2026, 9, 1)),
        _op('soon', closingDate: DateTime(2026, 7, 15)),
      ];

      await viewModel.load();

      expect(visible().map((o) => o.id), ['soon', 'later', 'rolling']);
    });

    test('emits error state when the repository fails', () async {
      repository.errorToThrow =
          const OpportunityException('Could not load opportunities.');

      await viewModel.load();

      expect(viewModel.state, isA<BrowseError>());
    });
  });

  group('filters', () {
    setUp(() async {
      repository.toReturn = [
        _op('dev-gp',
            type: OpportunityType.juniorJob, province: Province.gauteng),
        _op('intern-wc',
            type: OpportunityType.internship, province: Province.westernCape),
        _op('learner-kzn',
            type: OpportunityType.learnership,
            province: Province.kwaZuluNatal),
      ];
      await viewModel.load();
    });

    test('filters by opportunity type', () {
      viewModel.setTypeFilter(OpportunityType.internship);

      expect(visible().map((o) => o.id), ['intern-wc']);
    });

    test('filters by province', () {
      viewModel.setProvinceFilter(Province.kwaZuluNatal);

      expect(visible().map((o) => o.id), ['learner-kzn']);
    });

    test('clearing a filter restores the full list', () {
      viewModel.setTypeFilter(OpportunityType.internship);
      viewModel.setTypeFilter(null);

      expect(visible().length, 3);
    });

    test('search matches title, organisation and field', () {
      viewModel.setQuery('ubuntu');

      expect(visible().length, 3); // all share the organisation

      viewModel.setQuery('nothing-matches-this');

      expect(visible(), isEmpty);
    });

    test('type and province filters combine', () {
      viewModel.setTypeFilter(OpportunityType.juniorJob);
      viewModel.setProvinceFilter(Province.westernCape);

      expect(visible(), isEmpty);
    });
  });

  group('daysUntilClose', () {
    test('is null for rolling opportunities', () {
      expect(_op('x', closingDate: null).daysUntilClose(_today), isNull);
    });

    test('counts calendar days ignoring time of day', () {
      final op = _op('x', closingDate: DateTime(2026, 7, 16, 23, 59));
      expect(op.daysUntilClose(_today), 7);
    });

    test('is negative when closed', () {
      final op = _op('x', closingDate: DateTime(2026, 7, 1));
      expect(op.daysUntilClose(_today), lessThan(0));
    });
  });
}
