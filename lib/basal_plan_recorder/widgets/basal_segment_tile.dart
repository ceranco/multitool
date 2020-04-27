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
    final onTap = mode.map(
      whenEdit: onEdit,
      whenRemove: onRemove,
    );
    final icon = mode.map(
      whenView: Icons.remove_red_eye,
      whenEdit: Icons.edit,
      whenRemove: Icons.clear,
    );
    final backgroundColor = mode.map(
      whenView: Colors.blue,
      whenEdit: Colors.blue,
      whenRemove: Colors.red,
    );
    final materialColor = mode == BasalSegmentTileMode.view
        ? Colors.transparent
        : onTap != null ? Colors.transparent : Color(0x409E9E9E);
    final iconColor = mode == BasalSegmentTileMode.view
        ? Colors.white
        : onTap != null ? Colors.white : Colors.white30;

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

enum BasalSegmentTileMode {
  view,
  edit,
  remove,
}

extension _BasalSegmentTileMode on BasalSegmentTileMode {
  T map<T>({T whenView, T whenEdit, T whenRemove}) {
    switch (this) {
      case BasalSegmentTileMode.view:
        return whenView;
      case BasalSegmentTileMode.edit:
        return whenEdit;
      case BasalSegmentTileMode.remove:
        return whenRemove;
    }
    return null;
  }
}
