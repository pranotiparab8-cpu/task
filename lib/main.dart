import 'package:flutter/material.dart';
import 'package:stacked/stacked_annotations.dart';

import 'app/app.router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vistar App',
      onGenerateRoute: StackedRouter().onGenerateRoute,
      initialRoute: Routes.dashboardView,
    );
  }
}

