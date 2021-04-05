class ThemeType {
  const ThemeType(this._value);
  final String _value;
  String get value => _value;

  static const String _ROSE_VALUE = 'ROSE';
  static const String _SKY_VALUE = 'SKY';
  static const String _KONOHA_VALUE = 'KONOHA';
  static const String _DARK_VALUE = 'DARK';

  static const ThemeType ROSE = ThemeType(_ROSE_VALUE);
  static const ThemeType SKY = ThemeType(_SKY_VALUE);
  static const ThemeType KONOHA = ThemeType(_KONOHA_VALUE);
  static const ThemeType DARK = ThemeType(_DARK_VALUE);

  static List<ThemeType> values() {
    return [
      ThemeType.ROSE,
      ThemeType.SKY,
      ThemeType.KONOHA,
      ThemeType.DARK,
    ];
  }


  static ThemeType of(String theme) {
    return ThemeType.values().firstWhere((e) => e.toString() == theme);
  }

  String toString() {
    return this.value;
  }
}