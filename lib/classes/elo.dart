import 'dart:math';

Map<String, int> CalculateRatings(
  int ratingA,
  int ratingB,
  double scoreA,
  double scoreB,
) {
  final double Denominator = 400;
  final double K = 32;

  double expectedA = 1 / (1 + pow(10, (ratingB - ratingA) / Denominator));
  double expectedB = 1 / (1 + pow(10, (ratingA - ratingB) / Denominator));

  double scoreCoefficient = 1;
  if (scoreA == 0.5) {
    scoreCoefficient = 0.5;
  }

  int newRatingA = (ratingA + K * scoreCoefficient * (scoreA - expectedA))
      .round();
  int newRatingB = (ratingB + K * scoreCoefficient * (scoreB - expectedB))
      .round();

  return {"ratingA": newRatingA, "ratingB": newRatingB};
}
