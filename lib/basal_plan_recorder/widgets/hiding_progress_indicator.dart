import 'package:flutter/material.dart';

class HidingProgressIndicator extends StatelessWidget {
  final bool inProgress;
  final Widget child;

  const HidingProgressIndicator({
    @required this.inProgress,
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (inProgress) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return child;
  }
}
