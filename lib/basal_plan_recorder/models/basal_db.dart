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

  static Stream<Iterable<BasalPlan>> plans() {
    return _basalPlanCollection
        .orderBy('created', descending: true)
        .snapshots()
        .map(
          (QuerySnapshot snapshot) => snapshot.documents.map(
            (document) =>
                _BasalPlanIdx.fromJson(document.data, document.reference),
          ),
        );
  }

  static Future<void> removePlan(BasalPlan plan) {
    _BasalPlanIdx planIdx = plan as _BasalPlanIdx;
    assert(planIdx != null, '[plan] must be received using [BasalDB.plans].');
    return planIdx.document.delete();
  }
}

class _BasalPlanIdx extends BasalPlan {
  final DocumentReference document;

  _BasalPlanIdx.fromJson(Map<String, dynamic> data, this.document)
      : super.fromJson(data);
}
