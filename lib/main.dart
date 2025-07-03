import 'package:flutter/material.dart';
import 'package:temani_frontend/app.dart';
import 'package:temani_frontend/services/depedencies/di.dart';
import 'package:temani_frontend/services/shared_preference_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
    await SharedPreferencesService.init();

  runApp(const App());
}
