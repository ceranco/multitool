import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_db.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/pages/basal_plan_page.dart';
import 'package:multitool/basal_plan_recorder/pages/page.dart';
import 'package:multitool/basal_plan_recorder/widgets/basal_plan_overview_tile.dart';
import 'package:multitool/basal_plan_recorder/widgets/hiding_progress_indicator.dart';
import 'package:multitool/basal_plan_recorder/widgets/tile_chosen_bottom_sheet.dart';
import 'package:multitool/preferences.dart';

class BasalPlanHistoryPage extends StatefulWidget implements MultiToolPage {
  static const String _title = 'Basal Plan History';

  @override
  _BasalPlanHistoryPageState createState() => _BasalPlanHistoryPageState();

  @override
  String get title => _title;
}

class _BasalPlanHistoryPageState extends State<BasalPlanHistoryPage> {
  void preferencesChanged() {
    setState(() {});
  }

  @override
  void initState() {
    Preferences.addListener(preferencesChanged);
    super.initState();
  }

  @override
  void dispose() {
    Preferences.removeListener(preferencesChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const padding = 16.0;
    final overviewSize = (screenWidth - padding * 3) / 2;

    return StreamBuilder(
      stream: BasalDB.plans(),
      builder: (context, AsyncSnapshot<Iterable<BasalPlan>> snapshot) {
        return HidingProgressIndicator(
          inProgress: !snapshot.hasData,
          child: Builder(
            builder: (BuildContext context) {
              final plans = snapshot.data?.skip(1)?.toList();
              return ListView(
                padding: EdgeInsets.only(top: padding),
                children: [
                  for (int i = 0; i < plans.length; i += 2)
                    Row(
                      children: <Widget>[
                        for (int j = i; j < i + 2; j++)
                          j < plans.length
                              ? Padding(
                                  key: ValueKey(plans[j].created),
                                  padding: const EdgeInsets.only(
                                    left: padding,
                                    bottom: padding,
                                  ),
                                  child: BasalPlanOverviewTile(
                                    size: overviewSize,
                                    plan: plans[j],
                                    onLongPress: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return TileChosenBottomSheet(
                                            onDeleteSelected: () {
                                              BasalDB.removePlan(plans[j]);
                                              Navigator.pop(context);
                                            },
                                            onShowSelected: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return BasalPlanPage(
                                                      plan: plans[j],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                )
                              : SizedBox(),
                      ],
                    )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
