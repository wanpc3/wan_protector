class AccEntry {
  final int? entryNo;
  final String accTitle;
  final String accUsername;
  final String? accUrl;
  final String? addNotes;

  AccEntry({
    this.entryNo,
    required this.accTitle,
    required this.accUsername,
    this.accUrl,
    this.addNotes,
  });

  // Convert a Map into an AccEntry object
  factory AccEntry.fromMap(Map<String, dynamic> map) {
    return AccEntry(
      entryNo: map['entry_no'],
      accTitle: map['title'],
      accUsername: map['acc_username'],
      accUrl: map['acc_url'],
      addNotes: map['notes'],
    );
  }

  // Convert an AccEntry object into a Map (for inserting into the database)
  Map<String, dynamic> toMap() {
    return {
      'entry_no': entryNo,
      'title': accTitle,
      'acc_username': accUsername,
      'acc_url': accUrl,
      'notes': addNotes,
    };
  }
}
