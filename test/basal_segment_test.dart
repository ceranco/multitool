import 'package:flutter_test/flutter_test.dart';
import 'package:multitool/basal_plan_recorder/models/basal_segment.dart';
import 'package:multitool/basal_plan_recorder/models/basal_time.dart';

void main() {
  group('BasalSegment', () {
    test('Calculates `BasalSegmentRelationship.before` correctly', () {
      final segment1 = BasalSegment(
        start: BasalTime(hour: 5, minute: 30),
        end: BasalTime(hour: 10, minute: 15),
        basalRate: 1,
      );
      final segment2 = BasalSegment(
        start: BasalTime(hour: 20, minute: 30),
        end: BasalTime(hour: 21, minute: 15),
        basalRate: 1,
      );

      final relationship = segment1.calculateRelationship(segment2);
      expect(relationship, BasalSegmentRelationship.before);
    });
    test('Calculates `BasalSegmentRelationship.after` correctly', () {
      final segment1 = BasalSegment(
        start: BasalTime(hour: 5, minute: 30),
        end: BasalTime(hour: 10, minute: 15),
        basalRate: 1,
      );
      final segment2 = BasalSegment(
        start: BasalTime(hour: 0, minute: 30),
        end: BasalTime(hour: 1, minute: 15),
        basalRate: 1,
      );

      final relationship = segment1.calculateRelationship(segment2);
      expect(relationship, BasalSegmentRelationship.after);
    });
    test('Calculates `BasalSegmentRelationship.beforeOverlap` correctly', () {
      final segment1 = BasalSegment(
        start: BasalTime(hour: 5, minute: 30),
        end: BasalTime(hour: 10, minute: 15),
        basalRate: 1,
      );
      final segment2 = BasalSegment(
        start: BasalTime(hour: 9, minute: 30),
        end: BasalTime(hour: 21, minute: 15),
        basalRate: 1,
      );

      final relationship = segment1.calculateRelationship(segment2);
      expect(relationship, BasalSegmentRelationship.beforeOverlap);
    });
    test('Calculates `BasalSegmentRelationship.afterOverlap` correctly', () {
      final segment1 = BasalSegment(
        start: BasalTime(hour: 9, minute: 30),
        end: BasalTime(hour: 10, minute: 15),
        basalRate: 1,
      );
      final segment2 = BasalSegment(
        start: BasalTime(hour: 8, minute: 30),
        end: BasalTime(hour: 10, minute: 0),
        basalRate: 1,
      );

      final relationship = segment1.calculateRelationship(segment2);
      expect(relationship, BasalSegmentRelationship.afterOverlap);
    });
    test('Calculates `BasalSegmentRelationship.contains` correctly', () {
      final segment1 = BasalSegment(
        start: BasalTime(hour: 10, minute: 30),
        end: BasalTime(hour: 20, minute: 15),
        basalRate: 1,
      );
      final segment2 = BasalSegment(
        start: BasalTime(hour: 12, minute: 30),
        end: BasalTime(hour: 14, minute: 0),
        basalRate: 1,
      );

      final relationship = segment1.calculateRelationship(segment2);
      expect(relationship, BasalSegmentRelationship.contains);
    });
    test('Calculates `BasalSegmentRelationship.contained` correctly', () {
      final segment1 = BasalSegment(
        start: BasalTime(hour: 10, minute: 30),
        end: BasalTime(hour: 20, minute: 15),
        basalRate: 1,
      );
      final segment2 = BasalSegment(
        start: BasalTime(hour: 5, minute: 30),
        end: BasalTime(hour: 21, minute: 0),
        basalRate: 1,
      );

      final relationship = segment1.calculateRelationship(segment2);
      expect(relationship, BasalSegmentRelationship.contained);
    });
    test('Calculates `BasalSegmentRelationship.match` correctly', () {
      final start = BasalTime(hour: 10, minute: 30);
      final end = BasalTime(hour: 20, minute: 30);

      final segment1 = BasalSegment(
        start: start,
        end: end,
        basalRate: 1,
      );
      final segment2 = BasalSegment(
        start: start,
        end: end,
        basalRate: 1,
      );

      final relationship = segment1.calculateRelationship(segment2);
      expect(relationship, BasalSegmentRelationship.match);
    });
    test(
      'Calculates `BasalSegmentRelationship.contained` for segments with same `start` ',
      () {
        final segment1 = BasalSegment(
          start: BasalTime.earliest,
          end: BasalTime(hour: 10, minute: 30),
          basalRate: 1,
        );
        final segment2 = BasalSegment(
          start: BasalTime.earliest,
          end: BasalTime.latest,
          basalRate: 1,
        );

        final relationship = segment1.calculateRelationship(segment2);
        expect(relationship, BasalSegmentRelationship.contained);
      },
    );
    test(
      'Calculates `BasalSegmentRelationship.contained` for segments with same `end` ',
      () {
        final segment1 = BasalSegment(
          start: BasalTime(hour: 10, minute: 30),
          end: BasalTime.latest,
          basalRate: 1,
        );
        final segment2 = BasalSegment(
          start: BasalTime.earliest,
          end: BasalTime.latest,
          basalRate: 1,
        );

        final relationship = segment1.calculateRelationship(segment2);
        expect(relationship, BasalSegmentRelationship.contained);
      },
    );
    test(
      'Calculates `BasalSegmentRelationship.before` for touching segments',
      () {
        final segment1 = BasalSegment(
          start: BasalTime(hour: 5, minute: 30),
          end: BasalTime(hour: 10, minute: 15),
          basalRate: 1,
        );
        final segment2 = BasalSegment(
          start: segment1.end,
          end: BasalTime(hour: 21, minute: 15),
          basalRate: 1,
        );

        final relationship = segment1.calculateRelationship(segment2);
        expect(relationship, BasalSegmentRelationship.before);
      },
    );
    test(
      'Calculates `BasalSegmentRelationship.after` for touching segments',
      () {
        final segment1 = BasalSegment(
          start: BasalTime(hour: 5, minute: 30),
          end: BasalTime(hour: 10, minute: 15),
          basalRate: 1,
        );
        final segment2 = BasalSegment(
          start: BasalTime.earliest,
          end: segment1.start,
          basalRate: 1,
        );

        final relationship = segment1.calculateRelationship(segment2);
        expect(relationship, BasalSegmentRelationship.after);
      },
    );
    test('CopyWith works correctly', () {
      final segment = BasalSegment(
        start: BasalTime(hour: 10, minute: 30),
        end: BasalTime(hour: 20, minute: 1),
        basalRate: 5,
      );

      final newStart = BasalTime(hour: 5, minute: 5);
      final newEnd = BasalTime.latest;
      final newBasalRate = 42.42;

      expect(
          segment.copyWith(start: newStart),
          equals(BasalSegment(
            start: newStart,
            end: segment.end,
            basalRate: segment.basalRate,
          )),
          reason: 'Changed `start`');
      expect(
          segment.copyWith(end: newEnd),
          equals(BasalSegment(
            start: segment.start,
            end: newEnd,
            basalRate: segment.basalRate,
          )),
          reason: 'Changed `end`');
      expect(
          segment.copyWith(basalRate: newBasalRate),
          equals(BasalSegment(
            start: segment.start,
            end: segment.end,
            basalRate: newBasalRate,
          )),
          reason: 'Changed `basalRate`');
      expect(
          segment.copyWith(
            start: newStart,
            end: newEnd,
            basalRate: newBasalRate,
          ),
          equals(BasalSegment(
            start: newStart,
            end: newEnd,
            basalRate: newBasalRate,
          )),
          reason: 'Changed everything');
    });
  });
}
