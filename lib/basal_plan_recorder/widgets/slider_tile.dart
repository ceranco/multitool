import 'package:flutter/material.dart';

class SliderTile extends StatelessWidget {
  final double sliderValue;
  final String title;
  final String trailing;
  final int divisions;
  final int max;
  final void Function(double value) onChanged;

  const SliderTile({
    Key key,
    @required this.sliderValue,
    @required this.title,
    @required this.trailing,
    @required this.divisions,
    @required this.max,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: sliderValue,
              divisions: divisions,
              max: max.toDouble(),
              onChanged: onChanged,
            ),
          ),
          Text(
            trailing,
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
