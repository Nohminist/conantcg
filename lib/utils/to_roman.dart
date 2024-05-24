// utils/to_roman.dart

String toRoman(int number) {
  if (number < 1 || number > 10) return "";
  List<String> romanNumerals = [
    "I",
    "II",
    "III",
    "IV",
    "V",
    "VI",
    "VII",
    "VIII",
    "IX",
    "X"
  ];
  return romanNumerals[number - 1];
}

