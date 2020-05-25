import 'package:flutter/material.dart';

class TileChosenBottomSheet extends StatelessWidget {
  final void Function() onDeleteSelected;
  final void Function() onShowSelected;

  const TileChosenBottomSheet({
    this.onDeleteSelected,
    this.onShowSelected,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 18,
      color: Colors.white,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _TileFlatButton(
            label: "Delete",
            color: Colors.red,
            textStyle: textStyle,
            onPressed: onDeleteSelected,
          ),
          _TileFlatButton(
            label: "Show",
            color: Colors.green,
            textStyle: textStyle,
            onPressed: onShowSelected,
          ),
        ],
      ),
    );
  }
}

class _TileFlatButton extends StatelessWidget {
  final Color color;
  final void Function() onPressed;
  final String label;
  final TextStyle textStyle;

  const _TileFlatButton({
    @required this.label,
    @required this.textStyle,
    this.color,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          label,
          style: textStyle,
        ),
      ),
    );
  }
}
