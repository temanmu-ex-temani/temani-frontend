import 'package:flutter/material.dart';
import 'package:temanmu/app.dart';
import 'package:temanmu/services/depedencies/di.dart';
import 'package:temanmu/services/shared_preference_service.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await SharedPreferencesService.init();
  await initializeDateFormatting('id_ID', null);

  runApp(const App());
}
