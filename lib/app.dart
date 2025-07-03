import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/router_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp.router(
      theme: ThemeData(fontFamily: 'Poppins'),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
