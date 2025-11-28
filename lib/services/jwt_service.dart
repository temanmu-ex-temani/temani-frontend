import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:temanmu/services/shared_preference_service.dart';

import '../core/constants/_constants.dart';

class JwtService {
  static Map<String, dynamic> decodeToken({
    required String token,
  }) {
    return JwtDecoder.decode(token);
  }

  static bool isTokenExpirate() {
    final token = SharedPreferencesService.getString(PreferencesKeys.token);
    if (token == null) return false;
    return JwtDecoder.isExpired(token);
  }
}
