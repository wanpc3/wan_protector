class AccEntry {
  final String accTitle;
  final String accUsername;
  final String? accUrl;
  final String? addNotes;

  AccEntry({
    required this.accTitle,
    required this.accUsername,
    this.accUrl,
    this.addNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'title' : accTitle,
      'acc_username' : accUsername,
      'acc_url' : accUrl,
      'notes' : addNotes,
    };
  }
}