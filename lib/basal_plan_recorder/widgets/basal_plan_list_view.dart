import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_segment_tile.dart';
import 'package:multitool/basal_plan_recorder/widgets/edit_segment_bottom_sheet.dart';

class BasalPlanListView extends StatefulWidget {
  const BasalPlanListView({
    Key key,
    @required this.plan,
    @required this.mode,
  }) : super(key: key);

  final BasalPlan plan;
  final BasalSegmentTileMode mode;

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
              mode: widget.mode,
              segment: entry.value,
              onEdit: () {
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
              onRemove: widget.plan.segments.length > 1
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
