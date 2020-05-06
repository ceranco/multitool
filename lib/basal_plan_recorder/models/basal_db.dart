import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';

const _basalPlansCollectionName = 'basal-plans';
const _currentPlanDocumentName = 'current';

class BasalDB {
  BasalDB._();

  static final _firestore = Firestore.instance;
  static final _basalPlanCollection =
      _firestore.collection(_basalPlansCollectionName);
  static final _currentPlanDocument =
      _basalPlanCollection.document(_currentPlanDocumentName);

  static Future<BasalPlan> currentPlan() async {
    final snapshot = await _currentPlanDocument.get();
    return BasalPlan.fromJson(snapshot.data);
  }

  static Future<void> setCurrentPlan(BasalPlan plan) =>
      _currentPlanDocument.setData(plan.json);

  static Future<void> addPlan(BasalPlan plan) =>
      _basalPlanCollection.add(plan.json);
}
