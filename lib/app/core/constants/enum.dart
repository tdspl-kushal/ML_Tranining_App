import 'dart:ui';





enum filterType {
  ageGroup(value: 0, text: 'ageGroup'),
  tournamentType(value: 1, text: 'tournamentType'),
  tournamentCategory(value: 2, text: 'tournamentCategory'),
  cityOrState(value: 3, text: 'cityOrState');

  const filterType({required this.value, required this.text});

  final int value;
  final String text;

  static filterType getType(value) {
    switch (value) {
      case 0:
        return filterType.ageGroup;
      case 1:
        return filterType.tournamentType;
      case 2:
        return filterType.tournamentCategory;
      case 3:
        return filterType.cityOrState;
      default:
        return filterType.ageGroup;
    }
  }
}