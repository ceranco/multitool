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
  });
}
