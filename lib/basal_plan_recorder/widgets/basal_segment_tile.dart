import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_segment.dart';
import 'package:multitool/basal_plan_recorder/widgets/non_clipping_dismissible.dart';

const _textStyle = TextStyle(
  fontSize: 24,
  color: Colors.white,
  fontWeight: FontWeight.w600,
);
const _boxDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

class BasalSegmentTile extends StatelessWidget {
  final BasalSegment segment;
  final IconData icon;
  final void Function() onTapIcon;
  final void Function() onSwipe;

  const BasalSegmentTile({
    @required this.segment,
    @required this.icon,
    this.onTapIcon,
    this.onSwipe,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final materialColor = Colors.transparent;
    final iconColor = onTapIcon != null ? Colors.white : Colors.white30;

    final tile = Container(
      decoration: _boxDecoration.copyWith(color: Colors.blue),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${segment.start.format()} - ${segment.end.format()}',
              textAlign: TextAlign.left,
              style: _textStyle,
            ),
            Text(
              '${segment.basalRate.toStringAsFixed(2)}',
              style: _textStyle,
            ),
            Material(
              shape: CircleBorder(),
              color: materialColor,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTapIcon,
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
    return onSwipe != null
        ? NonClippingDismissible(
            key: ValueKey(segment),
            direction: DismissDirection.startToEnd,
            background: Container(
              decoration: _boxDecoration.copyWith(color: Colors.red),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            onDismissed: (_) => onSwipe(),
            child: tile,
          )
        : tile;
  }
}
