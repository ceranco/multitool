import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_plan_chart.dart';

class BasalPlanOverviewTile extends StatelessWidget {
  final BasalPlan plan;
  final double size;

  final void Function() onTap;
  final void Function() onLongPress;

  const BasalPlanOverviewTile({
    @required this.plan,
    @required this.size,
    this.onTap,
    this.onLongPress,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Colors.blue,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: SizedBox(
          width: size,
          height: size,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    plan.created.dmyHms,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IgnorePointer(
                    child: BasalPlanChart(plan: plan),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

extension _DateTimeExtensions on DateTime {
  String get dmy => '${this.day}/${this.month}/${this.year}';

  String get hms =>
      '${this.hour.toString().padLeft(2, '0')}:${this.minute.toString().padLeft(2, '0')}:${this.second.toString().padLeft(2, '0')}';

  String get dmyHms => '$dmy $hms';
}
