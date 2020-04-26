import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_segment.dart';

class BasalSegmentTile extends StatelessWidget {
  final BasalSegment segment;
  final BasalSegmentTileMode mode;
  final void Function() onEdit;
  final void Function() onRemove;

  const BasalSegmentTile({
    @required this.segment,
    this.mode = BasalSegmentTileMode.edit,
    this.onEdit,
    this.onRemove,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onTap = mode == BasalSegmentTileMode.edit ? onEdit : onRemove;
    final icon = mode == BasalSegmentTileMode.edit ? Icons.edit : Icons.clear;
    final backgroundColor =
        mode == BasalSegmentTileMode.edit ? Colors.blue : Colors.red;
    final materialColor =
        onTap != null ? Colors.transparent : Color(0x409E9E9E);
    final iconColor = onTap != null ? Colors.white : Colors.white30;

    final textStyle = TextStyle(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${segment.start.format()} - ${segment.end.format()}',
              textAlign: TextAlign.left,
              style: textStyle,
            ),
            Text(
              '${segment.basalRate.toStringAsFixed(2)}',
              style: textStyle,
            ),
            Material(
              shape: CircleBorder(),
              color: materialColor,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    size: 30,
                    color: iconColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum BasalSegmentTileMode { edit, remove }
