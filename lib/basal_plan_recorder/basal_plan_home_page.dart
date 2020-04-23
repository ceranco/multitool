import 'package:flutter/material.dart';

class BasalPlanHomePage extends StatelessWidget {
  final List<BasalSegment> segments = [
    BasalSegment(
      start: BasalTime(hour: 0, minute: 0),
      end: BasalTime(hour: 5, minute: 0),
      basalRate: 1.30,
    ),
    BasalSegment(
      start: BasalTime(hour: 5, minute: 0),
      end: BasalTime(hour: 8, minute: 30),
      basalRate: 1.45,
    ),
    BasalSegment(
      start: BasalTime(hour: 8, minute: 30),
      end: BasalTime(hour: 15, minute: 0),
      basalRate: 1.40,
    ),
    BasalSegment(
      start: BasalTime(hour: 15, minute: 0),
      end: BasalTime(hour: 18, minute: 30),
      basalRate: 1.05,
    ),
    BasalSegment(
      start: BasalTime(hour: 18, minute: 30),
      end: BasalTime(hour: 24, minute: 0),
      basalRate: 1.40,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basal Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: ListView(
          children: [
            for (final segment in segments)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BasalSegmentTile(
                  segment: segment,
                  onEdit: () {},
                ),
              )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.add,
              size: 30,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.remove,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class BasalTime {
  final int hour;
  final int minute;

  BasalTime({@required this.hour, @required this.minute})
      : assert(0 <= hour && hour <= 24),
        assert(0 <= minute && minute < 60);

  String format() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padRight(2, '0')}';
}

@immutable
class BasalSegment {
  final BasalTime start;
  final BasalTime end;
  final double basalRate;

  BasalSegment({
    @required this.start,
    @required this.end,
    @required this.basalRate,
  });
}

class BasalSegmentTile extends StatelessWidget {
  final BasalSegment segment;
  final void Function() onEdit;

  const BasalSegmentTile({
    Key key,
    @required this.segment,
    @required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
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
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onEdit,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.edit,
                    size: 30,
                    color: Colors.white,
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
