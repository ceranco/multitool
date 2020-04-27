import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_plan_list_view.dart';
import 'package:multitool/basal_plan_recorder/widgets/edit_segment_bottom_sheet.dart';

class BasalPlanHomePage extends StatefulWidget {
  @override
  _BasalPlanHomePageState createState() => _BasalPlanHomePageState();
}

class _BasalPlanHomePageState extends State<BasalPlanHomePage> {
  final plan = BasalPlan();

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
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
    );
  }
}
