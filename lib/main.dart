import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/pages/basal_plan_history_page.dart';
import 'package:multitool/basal_plan_recorder/pages/basal_plan_home_page.dart';
import 'package:multitool/basal_plan_recorder/pages/page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  final pages = <MultiToolPage>[
    BasalPlanHomePage(),
    BasalPlanHistoryPage(),
  ];

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MultiToolPage currentPage;

  @override
  void initState() {
    currentPage = widget.pages.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multitool',
      // home: BasalPlanHomePage(),
      // home: BasalPlanHistoryPage(),
      home: Builder(builder: (context) {
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    'Basal Plan',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]..addAll(
                  widget.pages.map(
                    (page) {
                      return ListTile(
                        enabled: page != currentPage,
                        title: Text(page.title),
                        onTap: () {
                          setState(() {
                            currentPage = page;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
            ),
          ),
          appBar: AppBar(
            title: Text(currentPage.title),
          ),
          body: currentPage,
        );
      }),
    );
  }
}
