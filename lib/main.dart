import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/pages/basal_plan_history_page.dart';
import 'package:multitool/basal_plan_recorder/pages/basal_plan_home_page.dart';
import 'package:multitool/basal_plan_recorder/pages/page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multitool/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferencesInstance = await SharedPreferences.getInstance();
  Preferences.initialize(preferencesInstance);

  runApp(MyApp());
}

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
            child: Column(
              children: <Widget>[
                Expanded(
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
                ListTile(
                  title: Text('Dev Mode'),
                  trailing: Switch(
                      value: Preferences.devMode,
                      onChanged: (value) {
                        setState(() {
                          return Preferences.devMode = value;
                        });
                      }),
                ),
              ],
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
