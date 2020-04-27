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
    final int divisions = 48;
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
            final newTime = BasalTime.decode(value.toInt());

            // We need to make sure that the segments `start` time is earlier than
            // the `end` time.
            // Otherwise the segment will be created with an invalid state.
            if (newTime < endTime) {
              setState(() {
                startTime = newTime;
              });
            }
          },
        ),
        SliderTile(
          title: 'End   ',
          sliderValue: endTime.asEncoded.toDouble(),
          trailing: endTime.format(),
          divisions: divisions,
          max: max,
          onChanged: (value) {
            final newTime = BasalTime.decode(value.toInt());

            // We need to make sure that the segments `end` time is later than
            // the `start` time.
            // Otherwise the segment will be created with an invalid state.
            if (newTime > startTime) {
              setState(() {
                endTime = newTime;
              });
            }
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
                  onPressed: () {
                    widget.onFinish(
                      BasalSegment(
                        start: startTime,
                        end: endTime,
                        basalRate: value,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
