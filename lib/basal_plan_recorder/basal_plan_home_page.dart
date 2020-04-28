import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_plan_list_view.dart';
import 'package:multitool/basal_plan_recorder/widgets/edit_segment_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BasalPlanHomePage extends StatefulWidget {
  @override
  _BasalPlanHomePageState createState() => _BasalPlanHomePageState();
}

class _BasalPlanHomePageState extends State<BasalPlanHomePage> {
  BasalPlan plan;

  @override
  void initState() {
    getPlan();
    super.initState();
  }

  void getPlan() async {
    const collectionName = 'basalplans';
    const documentName = 'plan';
    final document =
        Firestore.instance.collection(collectionName).document(documentName);
    final snapshot = await document.get();

    setState(() {
      plan = BasalPlan.fromJson(snapshot.data);
    });
    plan.addListener(() async {
      await document.setData(plan.json);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final encoder = JsonEncoder.withIndent('  ');
    // print(encoder.convert(plan.json));
    if (plan == null) {
      return CircularProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Basal Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: ChangeNotifierProvider.value(
          value: plan,
          child: BasalPlanListView(),
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
