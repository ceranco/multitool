import 'package:flutter/material.dart';
import 'package:multitool/basal_plan_recorder/models/basal_segment.dart';
import 'package:multitool/basal_plan_recorder/models/basal_time.dart';
import 'package:multitool/basal_plan_recorder/widgets/slider_tile.dart';

class EditSegmentBottomSheet extends StatefulWidget {
  final void Function(BasalSegment) onFinish;
  final BasalTime startTime;
  final BasalTime endTime;
  final double value;

  const EditSegmentBottomSheet({
    @required this.onFinish,
    this.startTime = BasalTime.earliest,
    this.endTime = BasalTime.latest,
    this.value = 1.0,
    Key key,
  }) : super(key: key);

  @override
  _EditSegmentBottomSheetState createState() => _EditSegmentBottomSheetState();
}

class _EditSegmentBottomSheetState extends State<EditSegmentBottomSheet> {
  BasalTime startTime;
  BasalTime endTime;
  double value;

  @override
  void initState() {
    startTime = widget.startTime;
    endTime = widget.endTime;
    value = widget.value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int divisions = 1 ~/ 0.5 * 24;
    final int max = 60 * 24;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SliderTile(
          title: 'Start ',
          sliderValue: startTime.asEncoded.toDouble(),
          trailing: startTime.format(),
          divisions: divisions,
          max: max,
          onChanged: (value) {
            setState(() {
              startTime = BasalTime.decode(value.toInt());
            });
          },
        ),
        SliderTile(
          title: 'End   ',
          sliderValue: endTime.asEncoded.toDouble(),
          trailing: endTime.format(),
          divisions: divisions,
          max: max,
          onChanged: (value) {
            setState(() {
              endTime = BasalTime.decode(value.toInt());
            });
          },
        ),
        SliderTile(
          title: 'Value',
          sliderValue: value * 20,
          trailing: ' ${value.toStringAsFixed(2)}',
          divisions: 60,
          max: 60,
          onChanged: (value) {
            setState(() {
              this.value = value / 20;
            });
          },
        ),
        Expanded(
          child: Center(
            child: ClipOval(
              child: Container(
                color: Colors.blue,
                child: IconButton(
                  iconSize: 50,
                  color: Colors.white,
                  icon: Icon(
                    Icons.done,
                  ),
                  onPressed: () => widget.onFinish(
                    BasalSegment(
                      start: startTime,
                      end: endTime,
                      basalRate: value,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

extension BasalTimeExtensions on BasalTime {
  /// Creates a new instance of [BasalTime] from an
  /// [int] in the range [0..48].
  ///
  /// This enables "encoding" time in a simple value that can
  /// be used in a slider easily.
  static BasalTime fromIntRange(int value) {
    assert(0 <= value && value <= 48);

    final int hour = value ~/ 2;
    final int minute = value % 2 == 0 ? 0 : 30;
    return BasalTime(hour: hour, minute: minute);
  }

  /// Encodes the instance of [BasalTime] to an
  /// [int] in the range [0..48].
  ///
  /// This enables "encoding" time in a simple value that can
  /// be used in a slider easily.
  int toIntRange() => hour * 2 + (minute == 0 ? 0 : 1);
}
