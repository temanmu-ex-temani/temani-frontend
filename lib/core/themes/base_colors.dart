part of '_themes.dart';

class BaseColors {
  // Primary Colors - Using Tailwind's indigo palette
  static const int _primaryValue = 0xFF6366F1; // indigo-500
  static const MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFEEF2FF),   // indigo-50
      100: Color(0xFFE0E7FF),  // indigo-100
      200: Color(0xFFC7D2FE),  // indigo-200
      300: Color(0xFFA5B4FC),  // indigo-300
      400: Color(0xFF818CF8),  // indigo-400
      500: Color(_primaryValue), // indigo-500
      600: Color(0xFF4F46E5),  // indigo-600
      700: Color(0xFF4338CA),  // indigo-700
      800: Color(0xFF3730A3),  // indigo-800
      900: Color(0xFF312E81),  // indigo-900
    },
  );

  // Secondary Colors - Using Tailwind's sky palette
  static const int _secondaryValue = 0xFF0EA5E9; // sky-500
  static const MaterialColor secondary = MaterialColor(
    _secondaryValue,
    <int, Color>{
      50: Color(0xFFF0F9FF),   // sky-50
      100: Color(0xFFE0F2FE),  // sky-100
      200: Color(0xFFBAE6FD),  // sky-200
      300: Color(0xFF7DD3FC),  // sky-300
      400: Color(0xFF38BDF8),  // sky-400
      500: Color(_secondaryValue), // sky-500
      600: Color(0xFF0284C7),  // sky-600
      700: Color(0xFF0369A1),  // sky-700
      800: Color(0xFF075985),  // sky-800
      900: Color(0xFF0C4A6E),  // sky-900
    },
  );

  // Neutral Colors - Using Tailwind's gray palette
  static const int _neutralValue = 0xFF6B7280; // gray-500
  static const MaterialColor neutral = MaterialColor(
    _neutralValue,
    <int, Color>{
      50: Color(0xFFF9FAFB),   // gray-50
      100: Color(0xFFF3F4F6),  // gray-100
      200: Color(0xFFE5E7EB),  // gray-200
      300: Color(0xFFD1D5DB),  // gray-300
      400: Color(0xFF9CA3AF),  // gray-400
      500: Color(_neutralValue), // gray-500
      600: Color(0xFF4B5563),  // gray-600
      700: Color(0xFF374151),  // gray-700
      800: Color(0xFF1F2937),  // gray-800
      900: Color(0xFF111827),  // gray-900
    },
  );

  // Success Colors - Using Tailwind's emerald palette
  static const int _successValue = 0xFF10B981; // emerald-500
  static const MaterialColor success = MaterialColor(
    _successValue,
    <int, Color>{
      50: Color(0xFFECFDF5),   // emerald-50
      100: Color(0xFFD1FAE5),  // emerald-100
      200: Color(0xFFA7F3D0),  // emerald-200
      300: Color(0xFF6EE7B7),  // emerald-300
      400: Color(0xFF34D399),  // emerald-400
      500: Color(_successValue), // emerald-500
      600: Color(0xFF059669),  // emerald-600
      700: Color(0xFF047857),  // emerald-700
      800: Color(0xFF065F46),  // emerald-800
      900: Color(0xFF064E3B),  // emerald-900
    },
  );

  // Warning Colors - Using Tailwind's amber palette
  static const int _warningValue = 0xFFF59E0B; // amber-500
  static const MaterialColor warning = MaterialColor(
    _warningValue,
    <int, Color>{
      50: Color(0xFFFFFBEB),   // amber-50
      100: Color(0xFFFEF3C7),  // amber-100
      200: Color(0xFFFDE68A),  // amber-200
      300: Color(0xFFFCD34D),  // amber-300
      400: Color(0xFFFBBF24),  // amber-400
      500: Color(_warningValue), // amber-500
      600: Color(0xFFD97706),  // amber-600
      700: Color(0xFFB45309),  // amber-700
      800: Color(0xFF92400E),  // amber-800
      900: Color(0xFF78350F),  // amber-900
    },
  );

  // Error Colors - Using Tailwind's red palette
  static const int _errorValue = 0xFFEF4444; // red-500
  static const MaterialColor error = MaterialColor(
    _errorValue,
    <int, Color>{
      50: Color(0xFFFEF2F2),   // red-50
      100: Color(0xFFFEE2E2),  // red-100
      200: Color(0xFFFECACA),  // red-200
      300: Color(0xFFFCA5A5),  // red-300
      400: Color(0xFFF87171),  // red-400
      500: Color(_errorValue), // red-500
      600: Color(0xFFDC2626),  // red-600
      700: Color(0xFFB91C1C),  // red-700
      800: Color(0xFF991B1B),  // red-800
      900: Color(0xFF7F1D1D),  // red-900
    },
  );

  // Info Colors - Using Tailwind's blue palette
  static const int _infoValue = 0xFF3B82F6; // blue-500
  static const MaterialColor info = MaterialColor(
    _infoValue,
    <int, Color>{
      50: Color(0xFFEFF6FF),   // blue-50
      100: Color(0xFFDBEAFE),  // blue-100
      200: Color(0xFFBFDBFE),  // blue-200
      300: Color(0xFF93C5FD),  // blue-300
      400: Color(0xFF60A5FA),  // blue-400
      500: Color(_infoValue),  // blue-500
      600: Color(0xFF2563EB),  // blue-600
      700: Color(0xFF1D4ED8),  // blue-700
      800: Color(0xFF1E40AF),  // blue-800
      900: Color(0xFF1E3A8A),  // blue-900
    },
  );

  // Purple Colors - Using Tailwind's purple palette
  static const int _purpleValue = 0xFF8B5CF6; // purple-500
  static const MaterialColor purple = MaterialColor(
    _purpleValue,
    <int, Color>{
      50: Color(0xFFFAF5FF),   // purple-50
      100: Color(0xFFF3E8FF),  // purple-100
      200: Color(0xFFE9D5FF),  // purple-200
      300: Color(0xFFD8B4FE),  // purple-300
      400: Color(0xFFC084FC),  // purple-400
      500: Color(_purpleValue), // purple-500
      600: Color(0xFF7C3AED),  // purple-600
      700: Color(0xFF6D28D9),  // purple-700
      800: Color(0xFF5B21B6),  // purple-800
      900: Color(0xFF4C1D95),  // purple-900
    },
  );

  // Pink Colors - Using Tailwind's pink palette
  static const int _pinkValue = 0xFFEC4899; // pink-500
  static const MaterialColor pink = MaterialColor(
    _pinkValue,
    <int, Color>{
      50: Color(0xFFFDF2F8),   // pink-50
      100: Color(0xFFFCE7F3),  // pink-100
      200: Color(0xFFFBCFE8),  // pink-200
      300: Color(0xFFF9A8D4),  // pink-300
      400: Color(0xFFF472B6),  // pink-400
      500: Color(_pinkValue),  // pink-500
      600: Color(0xFFDB2777),  // pink-600
      700: Color(0xFFBE185D),  // pink-700
      800: Color(0xFF9D174D),  // pink-800
      900: Color(0xFF831843),  // pink-900
    },
  );

  // Green Colors - Using Tailwind's green palette
  static const int _greenValue = 0xFF22C55E; // green-500
  static const MaterialColor green = MaterialColor(
    _greenValue,
    <int, Color>{
      50: Color(0xFFF0FDF4),   // green-50
      100: Color(0xFFDCFCE7),  // green-100
      200: Color(0xFFBBF7D0),  // green-200
      300: Color(0xFF86EFAC),  // green-300
      400: Color(0xFF4ADE80),  // green-400
      500: Color(_greenValue), // green-500
      600: Color(0xFF16A34A),  // green-600
      700: Color(0xFF15803D),  // green-700
      800: Color(0xFF166534),  // green-800
      900: Color(0xFF14532D),  // green-900
    },
  );

  // Yellow Colors - Using Tailwind's yellow palette
  static const int _yellowValue = 0xFFEAB308; // yellow-500
  static const MaterialColor yellow = MaterialColor(
    _yellowValue,
    <int, Color>{
      50: Color(0xFFFEFCE8),   // yellow-50
      100: Color(0xFFFEF9C3),  // yellow-100
      200: Color(0xFFFEF08A),  // yellow-200
      300: Color(0xFFFDE047),  // yellow-300
      400: Color(0xFFFACC15),  // yellow-400
      500: Color(_yellowValue), // yellow-500
      600: Color(0xFFCA8A04),  // yellow-600
      700: Color(0xFFA16207),  // yellow-700
      800: Color(0xFF854D0E),  // yellow-800
      900: Color(0xFF713F12),  // yellow-900
    },
  );

  // Orange Colors - Using Tailwind's orange palette
  static const int _orangeValue = 0xFFF97316; // orange-500
  static const MaterialColor orange = MaterialColor(
    _orangeValue,
    <int, Color>{
      50: Color(0xFFFFF7ED),   // orange-50
      100: Color(0xFFFFEDD5),  // orange-100
      200: Color(0xFFFED7AA),  // orange-200
      300: Color(0xFFFDBA74),  // orange-300
      400: Color(0xFFFB923C),  // orange-400
      500: Color(_orangeValue), // orange-500
      600: Color(0xFFEA580C),  // orange-600
      700: Color(0xFFC2410C),  // orange-700
      800: Color(0xFF9A3412),  // orange-800
      900: Color(0xFF7C2D12),  // orange-900
    },
  );

  // Teal Colors - Using Tailwind's teal palette
  static const int _tealValue = 0xFF14B8A6; // teal-500
  static const MaterialColor teal = MaterialColor(
    _tealValue,
    <int, Color>{
      50: Color(0xFFF0FDFA),   // teal-50
      100: Color(0xFFCCFBF1),  // teal-100
      200: Color(0xFF99F6E4),  // teal-200
      300: Color(0xFF5EEAD4),  // teal-300
      400: Color(0xFF2DD4BF),  // teal-400
      500: Color(_tealValue),  // teal-500
      600: Color(0xFF0D9488),  // teal-600
      700: Color(0xFF0F766E),  // teal-700
      800: Color(0xFF115E59),  // teal-800
      900: Color(0xFF134E4A),  // teal-900
    },
  );

  // Cyan Colors - Using Tailwind's cyan palette
  static const int _cyanValue = 0xFF06B6D4; // cyan-500
  static const MaterialColor cyan = MaterialColor(
    _cyanValue,
    <int, Color>{
      50: Color(0xFFECFEFF),   // cyan-50
      100: Color(0xFFCFFAFE),  // cyan-100
      200: Color(0xFFA5F3FC),  // cyan-200
      300: Color(0xFF67E8F9),  // cyan-300
      400: Color(0xFF22D3EE),  // cyan-400
      500: Color(_cyanValue),  // cyan-500
      600: Color(0xFF0891B2),  // cyan-600
      700: Color(0xFF0E7490),  // cyan-700
      800: Color(0xFF155E75),  // cyan-800
      900: Color(0xFF164E63),  // cyan-900
    },
  );

  // Lime Colors - Using Tailwind's lime palette
  static const int _limeValue = 0xFF84CC16; // lime-500
  static const MaterialColor lime = MaterialColor(
    _limeValue,
    <int, Color>{
      50: Color(0xFFF7FEE7),   // lime-50
      100: Color(0xFFECFCCB),  // lime-100
      200: Color(0xFFD9F99D),  // lime-200
      300: Color(0xFFBEF264),  // lime-300
      400: Color(0xFFA3E635),  // lime-400
      500: Color(_limeValue),  // lime-500
      600: Color(0xFF65A30D),  // lime-600
      700: Color(0xFF4D7C0F),  // lime-700
      800: Color(0xFF3F6212),  // lime-800
      900: Color(0xFF365314),  // lime-900
    },
  );

  // Rose Colors - Using Tailwind's rose palette
  static const int _roseValue = 0xFFF43F5E; // rose-500
  static const MaterialColor rose = MaterialColor(
    _roseValue,
    <int, Color>{
      50: Color(0xFFFFF1F2),   // rose-50
      100: Color(0xFFFFE4E6),  // rose-100
      200: Color(0xFFFECDD3),  // rose-200
      300: Color(0xFFFDA4AF),  // rose-300
      400: Color(0xFFFB7185),  // rose-400
      500: Color(_roseValue),  // rose-500
      600: Color(0xFFE11D48),  // rose-600
      700: Color(0xFFBE123C),  // rose-700
      800: Color(0xFF9F1239),  // rose-800
      900: Color(0xFF881337),  // rose-900
    },
  );

  // Basic Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;

  // Background Colors
  static const Color scaffoldBackground = Color(0xFFF9FAFB); // gray-50
  static const Color surfaceBackground = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);   // gray-900
  static const Color textSecondary = Color(0xFF6B7280); // gray-500
  static const Color textTertiary = Color(0xFF9CA3AF);  // gray-400
  static const Color textInverse = Color(0xFFFFFFFF);

  // Border Colors
  static const Color borderLight = Color(0xFFE5E7EB);   // gray-200
  static const Color borderMedium = Color(0xFFD1D5DB);  // gray-300
  static const Color borderDark = Color(0xFF9CA3AF);    // gray-400

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // Legacy compatibility - keeping some of the original color names
  static const Color grey = neutral;
  static const Color lightGrey = Color(0xFF9CA3AF); // gray-400
}