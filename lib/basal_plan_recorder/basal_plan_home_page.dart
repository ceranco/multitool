import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_plan_list_view.dart';
import 'package:multitool/basal_plan_recorder/widgets/edit_segment_bottom_sheet.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_segment_tile.dart';

class BasalPlanHomePage extends StatefulWidget {
  @override
  _BasalPlanHomePageState createState() => _BasalPlanHomePageState();
}

class _BasalPlanHomePageState extends State<BasalPlanHomePage> {
  final plan = BasalPlan();
  BasalSegmentTileMode mode = BasalSegmentTileMode.edit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basal Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: BasalPlanListView(
          plan: plan,
          mode: mode,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => EditSegmentBottomSheet(
                  onFinish: (segment) => setState(() {
                    plan.add(segment);
                  }),
                ),
              );
            },
            child: Icon(
              Icons.add,
              size: 30,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                mode = mode == BasalSegmentTileMode.edit
                    ? BasalSegmentTileMode.remove
                    : BasalSegmentTileMode.edit;
              });
            },
            child: Icon(
              Icons.remove,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
