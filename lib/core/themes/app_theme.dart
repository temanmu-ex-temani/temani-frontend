part of '_themes.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: BaseColors.primary,
      brightness: Brightness.light,
      visualDensity: VisualDensity.compact,
      listTileTheme: const ListTileThemeData(dense: true),
    );
  }
}
