double? roundToDecimalPlaces(num? value, int places) {
  if (value == null) {
    return null;
  }
  double factor = 1;
  for (int i = 0; i < places; i++) {
    factor *= 10;
  }
  return (value * factor).round() / factor;
}
