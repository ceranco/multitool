import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_segment_tile.dart';
import 'package:multitool/basal_plan_recorder/widgets/edit_segment_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BasalPlanListView extends StatelessWidget {
  const BasalPlanListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BasalPlan>(
      builder: (BuildContext context, BasalPlan plan, Widget child) {
        return ListView(
          children: [
            for (final entry in plan.segments.asMap().entries)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BasalSegmentTile(
                  icon: Icons.edit,
                  segment: entry.value,
                  onTapIcon: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => EditSegmentBottomSheet(
                        startTime: entry.value.start,
                        endTime: entry.value.end,
                        value: entry.value.basalRate,
                        onFinish: (segment) {
                          try {
                            plan.replaceAt(entry.key, segment);
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    );
                  },
                  onSwipe: plan.segments.length > 1
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
