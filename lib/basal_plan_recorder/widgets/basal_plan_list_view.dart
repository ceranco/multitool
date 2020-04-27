import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_segment_tile.dart';
import 'package:multitool/basal_plan_recorder/widgets/edit_segment_bottom_sheet.dart';

class BasalPlanListView extends StatefulWidget {
  final BasalPlan plan;

  const BasalPlanListView({
    Key key,
    @required this.plan,
  }) : super(key: key);

  @override
  _BasalPlanListViewState createState() => _BasalPlanListViewState();
}

class _BasalPlanListViewState extends State<BasalPlanListView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final entry in widget.plan.segments.asMap().entries)
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
                    onFinish: (segment) => setState(() {
                      widget.plan.replaceAt(entry.key, segment);
                    }),
                  ),
                );
              },
              onSwipe: widget.plan.segments.length > 1
                  ? () {
                      setState(() {
                        widget.plan.removeAt(entry.key);
                      });
                    }
                  : null,
            ),
          )
      ],
    );
  }
}
