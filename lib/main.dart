import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/basal_plan_home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multitool',
      home: BasalPlanHomePage(),
    );
  }
}
