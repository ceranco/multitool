import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_db.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_plan_overview_tile.dart';

class BasalPlanHistoryPage extends StatefulWidget {
  @override
  _BasalPlanHistoryPageState createState() => _BasalPlanHistoryPageState();
}

class _BasalPlanHistoryPageState extends State<BasalPlanHistoryPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const padding = 16.0;
    final overviewSize = (screenWidth - padding * 3) / 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('Basal Plan History'),
      ),
      body: StreamBuilder(
        stream: BasalDB.plans(),
        builder: (context, AsyncSnapshot<Iterable<BasalPlan>> snapshot) {
          final plans = snapshot.data.toList();
          return ListView(
            padding: EdgeInsets.only(top: padding),
            children: [
              for (int i = 0; i < plans.length; i += 2)
                Row(
                  children: <Widget>[
                    for (int j = i; j < i + 2; j++)
                      j < plans.length
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: padding,
                                bottom: padding,
                              ),
                              child: BasalPlanOverviewTile(
                                size: overviewSize,
                                plan: plans[j],
                              ),
                            )
                          : SizedBox(),
                  ],
                )
            ],
          );
        },
      ),
    );
  }
}
