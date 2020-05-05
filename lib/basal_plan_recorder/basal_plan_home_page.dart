import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_plan_list_view.dart';
import 'package:multitool/basal_plan_recorder/widgets/edit_segment_bottom_sheet.dart';
import 'package:multitool/basal_plan_recorder/widgets/hiding_progress_indicator.dart';
import 'package:provider/provider.dart';

const basalPlansCollectionName = 'basal-plans';
const currentPlanDocumentName = 'current';

class BasalPlanHomePage extends StatefulWidget {
  @override
  _BasalPlanHomePageState createState() => _BasalPlanHomePageState();
}

class _BasalPlanHomePageState extends State<BasalPlanHomePage> {
  bool editing = false;
  BasalPlan originalPlan;
  BasalPlan plan;
  DocumentReference currentPlanDocument;

  @override
  void initState() {
    getPlan();
    super.initState();
  }

  void getPlan() async {
    currentPlanDocument = Firestore.instance
        .collection(basalPlansCollectionName)
        .document(currentPlanDocumentName);
    final snapshot = await currentPlanDocument.get();

    setState(() {
      plan = BasalPlan.fromJson(snapshot.data);
      originalPlan = BasalPlan.copy(plan);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fabIcon = editing ? Icons.save : Icons.edit;
    final fabOnPressed = () {
      // Save the new plan if it changed.
      if (editing && originalPlan != plan) {
        plan.created = DateTime.now();
        currentPlanDocument.setData(plan.json);
        originalPlan = BasalPlan.copy(plan);
      }

      setState(() {
        editing = !editing;
      });
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Basal Plan'),
      ),
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
      floatingActionButton: plan != null
          ? Row(
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
            )
          : null,
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
