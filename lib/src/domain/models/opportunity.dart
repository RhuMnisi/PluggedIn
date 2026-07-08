/// An entry-level opportunity: a graduate programme, internship, learnership,
/// or junior job.
class Opportunity {
  const Opportunity({
    required this.id,
    required this.title,
    required this.organisation,
    required this.type,
    required this.province,
    required this.field,
    required this.description,
    this.closingDate,
  });

  final String id;
  final String title;
  final String organisation;
  final OpportunityType type;
  final Province province;
  final String field;
  final String description;

  /// Some opportunities are open-ended (rolling applications).
  final DateTime? closingDate;

  /// Days from [today] until applications close. Null when open-ended,
  /// negative when already closed.
  int? daysUntilClose(DateTime today) {
    final closing = closingDate;
    if (closing == null) return null;
    return DateTime(closing.year, closing.month, closing.day)
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
  }
}

enum OpportunityType {
  graduateProgramme('Graduate programme'),
  internship('Internship'),
  learnership('Learnership'),
  juniorJob('Junior job');

  const OpportunityType(this.label);

  final String label;
}

enum Province {
  easternCape('Eastern Cape'),
  freeState('Free State'),
  gauteng('Gauteng'),
  kwaZuluNatal('KwaZulu-Natal'),
  limpopo('Limpopo'),
  mpumalanga('Mpumalanga'),
  northernCape('Northern Cape'),
  northWest('North West'),
  westernCape('Western Cape'),
  national('National / Remote');

  const Province(this.label);

  final String label;
}
