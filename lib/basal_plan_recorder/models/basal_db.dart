import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/preferences.dart';

const _releaseNames = _Names(
  basalPlansCollection: 'basal-plans',
  removedBasalPlansCollection: 'removed-basal-plans',
  currentPlanDocument: 'current',
);
const _devNames = _Names(
  basalPlansCollection: 'dev-basal-plans',
  removedBasalPlansCollection: 'dev-removed-basal-plans',
  currentPlanDocument: 'current',
);

class BasalDB {
  BasalDB._();

  static final _release = _Fields(Firestore.instance, _releaseNames);
  static final _dev = _Fields(Firestore.instance, _devNames);
  static _Fields get _fields => Preferences.devMode ? _dev : _release;

  static Future<BasalPlan> currentPlan() async {
    final snapshot = await _fields.currentPlanDocument.get();
    return BasalPlan.fromJson(snapshot.data);
  }

  static Future<void> setCurrentPlan(BasalPlan plan) =>
      _fields.currentPlanDocument.setData(plan.json);

  static Future<void> addPlan(BasalPlan plan) =>
      _fields.basalPlanCollection.add(plan.json);

  static Stream<Iterable<BasalPlan>> plans() {
    return _fields.basalPlanCollection
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

    // move the plan to the remove plans collection first
    return _fields.removedBasalPlanCollection
        .document(planIdx.document.documentID)
        .setData(plan.json)
        .then((_) => planIdx.document.delete());
  }
}

class _BasalPlanIdx extends BasalPlan {
  final DocumentReference document;

  _BasalPlanIdx.fromJson(Map<String, dynamic> data, this.document)
      : super.fromJson(data);
}

@immutable
class _Names {
  final String basalPlansCollection;
  final String removedBasalPlansCollection;
  final String currentPlanDocument;

  const _Names({
    @required this.basalPlansCollection,
    @required this.removedBasalPlansCollection,
    @required this.currentPlanDocument,
  });
}

@immutable
class _Fields {
  final CollectionReference basalPlanCollection;
  final CollectionReference removedBasalPlanCollection;
  final DocumentReference currentPlanDocument;

  _Fields(Firestore firestore, _Names names)
      : basalPlanCollection = firestore.collection(names.basalPlansCollection),
        removedBasalPlanCollection =
            firestore.collection(names.removedBasalPlansCollection),
        currentPlanDocument = firestore
            .collection(names.basalPlansCollection)
            .document(names.currentPlanDocument);
}
