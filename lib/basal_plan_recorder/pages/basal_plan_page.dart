import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/extensions/date_time_extensions.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_plan_chart.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_plan_list_view.dart';
import 'package:provider/provider.dart';

class BasalPlanPage extends StatelessWidget {
  final BasalPlan plan;

  const BasalPlanPage({@required this.plan, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plan.created.dmyHms),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 32.0,
                ).copyWith(bottom: 8.0),
                child: BasalPlanChart(
                  plan: plan,
                  lineColor: Colors.blue,
                  gridColor: Colors.black26,
                  titleStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ChangeNotifierProvider<BasalPlan>.value(
              value: plan,
              child: BasalPlanListView(),
            ),
          )
        ],
      ),
    );
  }
}
