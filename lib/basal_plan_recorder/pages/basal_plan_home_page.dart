import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_db.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/pages/page.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_plan_list_view.dart';
import 'package:multitool/basal_plan_recorder/widgets/edit_segment_bottom_sheet.dart';
import 'package:multitool/basal_plan_recorder/widgets/hiding_progress_indicator.dart';
import 'package:provider/provider.dart';

class BasalPlanHomePage extends StatefulWidget implements MultiToolPage {
  static const String _title = 'Basal Plan';

  @override
  _BasalPlanHomePageState createState() => _BasalPlanHomePageState();

  @override
  String get title => _title;
}

class _BasalPlanHomePageState extends State<BasalPlanHomePage> {
  bool editing = false;
  BasalPlan originalPlan;
  BasalPlan plan;

  @override
  void initState() {
    getPlan();
    super.initState();
  }

  void getPlan() async {
    final currentPlan = await BasalDB.currentPlan();

    setState(() {
      plan = currentPlan;
      originalPlan = BasalPlan.copy(plan);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fabIcon = editing ? Icons.save : Icons.edit;
    final fabOnPressed = () {
      // Save the new plan if it changed.
      if (editing && originalPlan != plan) {
        // First we want to save the old plan as a new document in the collection.
        // This is so that we can view it later.
        BasalDB.addPlan(originalPlan);

        // Then we update the time the plan was created an set the `current` document.
        plan.created = DateTime.now();
        BasalDB.setCurrentPlan(plan);
        originalPlan = BasalPlan.copy(plan);
      }

      setState(() {
        editing = !editing;
      });
    };

    return Scaffold(
      body: HidingProgressIndicator(
        inProgress: plan == null,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: ChangeNotifierProvider.value(
            value: plan,
            child: BasalPlanListView(
              editable: editing,
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: plan != null,
        child: Row(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            FloatingActionButton(
              onPressed: fabOnPressed,
              child: Icon(
                fabIcon,
                size: 30,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            AnimatedOpacity(
              opacity: editing ? 1.0 : 0.0,
              duration: Duration(milliseconds: 250),
              child: FloatingActionButton(
                onPressed: editing ? openAddSegmentModal : null,
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openAddSegmentModal() => showModalBottomSheet(
        context: context,
        builder: (context) => EditSegmentBottomSheet(
          onFinish: (segment) => setState(() {
            plan.add(segment);
          }),
        ),
      );
}
