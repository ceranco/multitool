import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_segment_tile.dart';
import 'package:multitool/basal_plan_recorder/widgets/edit_segment_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BasalPlanListView extends StatelessWidget {
  final bool editable;

  const BasalPlanListView({
    Key key,
    this.editable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final segmentIcon = editable ? Icons.edit : Icons.no_encryption;

    return Consumer<BasalPlan>(
      builder: (BuildContext context, BasalPlan plan, Widget child) {
        return ListView(
          children: [
            for (final entry in plan.segments.asMap().entries)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BasalSegmentTile(
                  icon: segmentIcon,
                  segment: entry.value,
                  onTapIcon: editable
                      ? () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => EditSegmentBottomSheet(
                              startTime: entry.value.start,
                              endTime: entry.value.end,
                              value: entry.value.basalRate,
                              onFinish: (segment) {
                                plan.replaceAt(entry.key, segment);
                              },
                            ),
                          );
                        }
                      : null,
                  onSwipe: editable && plan.segments.length > 1
                      ? () => plan.removeAt(entry.key)
                      : null,
                ),
              )
          ],
        );
      },
    );
  }
}
