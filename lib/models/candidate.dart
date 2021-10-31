class Candidate {
  final int candidateNumber;
  final String candidateTitle;
  final String candidateFirstName;
  final String candidateLastName;

  Candidate({
    required this.candidateNumber,
    required this.candidateTitle,
    required this.candidateFirstName,
    required this.candidateLastName,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      candidateNumber: json["candidateNumber"],
      candidateTitle: json["candidateTitle"],
      candidateFirstName: json["candidateFirstName"],
      candidateLastName: json["candidateLastName"],
    );
  }
}