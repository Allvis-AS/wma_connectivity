double wma(List<double> values) {
  final len = values.length;
  final d = (len + 1.0) * (len / 2.0);
  var avg = 0.0;
  for (var i = 0; i < len; i++) {
    final n = i + 1;
    final w = n / d;
    avg += w * values[i];
  }
  return avg;
}
