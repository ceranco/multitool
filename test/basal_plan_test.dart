import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multitool/basal_plan_recorder/models/basal_plan.dart';
import 'package:multitool/basal_plan_recorder/models/basal_segment.dart';
import 'package:multitool/basal_plan_recorder/models/basal_time.dart';
import 'package:multitool/exceptions/exceptions.dart';

void main() {
  group('BasalPlan.add', () {
    test('Adding contained segment should split existing one', () {
      final plan = BasalPlan();
      final segment1 = BasalSegment(
        start: BasalTime(hour: 10, minute: 0),
        end: BasalTime(hour: 11, minute: 30),
        basalRate: 5.0,
      );
      final segment2 = BasalSegment(
        start: BasalTime(hour: 13, minute: 0),
        end: BasalTime(hour: 20, minute: 30),
        basalRate: 7.5,
      );

      final expected1 = [
        BasalSegment(
          start: BasalTime.earliest,
          end: segment1.start,
          basalRate: plan.segments[0].basalRate,
        ),
        segment1,
        BasalSegment(
          start: segment1.end,
          end: BasalTime.latest,
          basalRate: plan.segments[0].basalRate,
        ),
      ];
      final expected2 = [
        BasalSegment(
          start: BasalTime.earliest,
          end: segment1.start,
          basalRate: plan.segments[0].basalRate,
        ),
        segment1,
        BasalSegment(
          start: segment1.end,
          end: segment2.start,
          basalRate: plan.segments[0].basalRate,
        ),
        segment2,
        BasalSegment(
          start: segment2.end,
          end: BasalTime.latest,
          basalRate: plan.segments[0].basalRate,
        ),
      ];

      plan.add(segment1);
      expect(
        listEquals(plan.segments, expected1),
        true,
        reason: 'first segment in the middle',
      );
      plan.add(segment2);
      expect(
        listEquals(plan.segments, expected2),
        true,
        reason: 'second middle added second from last',
      );
    });
    test('Adding overlapping segment should shrink existing one', () {
      final plan = BasalPlan();
      final segment1 = BasalSegment(
        start: BasalTime.earliest,
        end: BasalTime(hour: 8, minute: 30),
        basalRate: 0.5,
      );
      final segment2 = BasalSegment(
        start: BasalTime(hour: 8, minute: 0),
        end: BasalTime(hour: 10, minute: 30),
        basalRate: 0.75,
      );

      final expected1 = [
        segment1,
        BasalSegment(
          start: segment1.end,
          end: plan.segments[0].end,
          basalRate: plan.segments[0].basalRate,
        ),
      ];
      final expected2 = [
        BasalSegment(
          start: segment1.start,
          end: segment2.start,
          basalRate: segment1.basalRate,
        ),
        segment2,
        BasalSegment(
          start: segment2.end,
          end: plan.segments[0].end,
          basalRate: plan.segments[0].basalRate,
        ),
      ];

      plan.add(segment1);
      expect(
        listEquals(plan.segments, expected1),
        true,
        reason: 'first segment in the beginning',
      );
      plan.add(segment2);
      expect(
        listEquals(plan.segments, expected2),
        true,
        reason: 'second middle added between previous',
      );
    });
    test('Adding containing segment should discard other one', () {
      final plan = BasalPlan();
      final segment1 = BasalSegment(
        start: BasalTime(hour: 8, minute: 30),
        end: BasalTime(hour: 11, minute: 30),
        basalRate: 0.5,
      );
      final segment2 = BasalSegment(
        start: BasalTime(hour: 6, minute: 30),
        end: BasalTime(hour: 13, minute: 30),
        basalRate: 0.75,
      );

      final expected = [
        BasalSegment(
          start: plan.segments[0].start,
          end: segment2.start,
          basalRate: plan.segments[0].basalRate,
        ),
        segment2,
        BasalSegment(
          start: segment2.end,
          end: plan.segments[0].end,
          basalRate: plan.segments[0].basalRate,
        ),
      ];

      plan.add(segment1);
      plan.add(segment2);
      expect(listEquals(plan.segments, expected), true);
    });
  });
  group('BasalPlan.removeAt', () {
    test('Removing non-last segment should expand the following one', () {
      final plan = BasalPlan();
      final segment1 = BasalSegment(
        start: plan.segments[0].start,
        end: BasalTime(hour: 10, minute: 0),
        basalRate: plan.segments[0].basalRate,
      );
      final segment2 = BasalSegment(
        start: segment1.end,
        end: BasalTime(hour: 15, minute: 15),
        basalRate: 10,
      );
      final segment3 = BasalSegment(
        start: segment2.end,
        end: BasalTime.latest,
        basalRate: 0.4,
      );

      final expected1 = [
        segment1,
        BasalSegment(
          start: segment1.end,
          end: BasalTime.latest,
          basalRate: 0.4,
        ),
      ];
      final expected2 = [
        BasalSegment(
          start: segment1.start,
          end: BasalTime.latest,
          basalRate: segment1.basalRate,
        ),
      ];

      plan.add(segment2);
      plan.add(segment3);

      plan.removeAt(1);
      expect(
        listEquals(plan.segments, expected1),
        true,
        reason: 'Removed middle segment',
      );

      plan.removeAt(0);
      expect(
        listEquals(plan.segments, expected2),
        true,
        reason: 'Removed first segment',
      );
    });
    test('Removing last segment should expand the previous one', () {
      final plan = BasalPlan();

      final segment1 = BasalSegment(
        start: plan.segments[0].start,
        end: BasalTime(hour: 5, minute: 30),
        basalRate: plan.segments[0].basalRate,
      );
      final segment2 = BasalSegment(
        start: segment1.end,
        end: BasalTime(hour: 10, minute: 20),
        basalRate: 9,
      );
      final segment3 = BasalSegment(
        start: segment2.end,
        end: BasalTime.latest,
        basalRate: 20,
      );

      final expected1 = [
        segment1,
        BasalSegment(
          start: segment2.start,
          end: segment3.end,
          basalRate: segment2.basalRate,
        ),
      ];
      final expected2 = [
        BasalSegment(
          start: segment1.start,
          end: segment3.end,
          basalRate: segment1.basalRate,
        ),
      ];

      plan.add(segment2);
      plan.add(segment3);

      plan.removeAt(2);
      expect(
        listEquals(plan.segments, expected1),
        true,
        reason: 'Remove last segment (two remaining)',
      );

      plan.removeAt(1);
      expect(
        listEquals(plan.segments, expected2),
        true,
        reason: 'Remove last segment (one remaining)',
      );
    });
    test('Removing last remaining segment should throw', () {
      final plan = BasalPlan();

      expect(
        () => plan.removeAt(0),
        throwsA(isInstanceOf<InvalidOperationException>()),
      );
    });
  });
  group('BasalPlan.replaceAt', () {
    test(
      'Replacing first segment with `segment.start != BasalTime.earliest` throws',
      () {
        final plan = BasalPlan();
        final lastSegment = BasalSegment(
          start: BasalTime(hour: 15, minute: 0),
          end: BasalTime.latest,
          basalRate: 42,
        );
        final replacingSegment = BasalSegment(
          start: BasalTime(hour: 0, minute: 30),
          end: lastSegment.start,
          basalRate: 0.15,
        );

        plan.add(lastSegment);

        expect(
          () => plan.replaceAt(0, replacingSegment),
          throwsA(isInstanceOf<InvalidOperationException>()),
        );
      },
    );
    test(
      'Replacing last segment with `segment.end != BasalTime.latest` throws',
      () {
        final plan = BasalPlan();
        final lastSegment = BasalSegment(
          start: BasalTime(hour: 15, minute: 0),
          end: BasalTime.latest,
          basalRate: 42,
        );
        final replacingSegment = BasalSegment(
          start: lastSegment.end,
          end: BasalTime(hour: 23, minute: 30),
          basalRate: 0.15,
        );

        plan.add(lastSegment);

        expect(
          () => plan.replaceAt(1, replacingSegment),
          throwsA(isInstanceOf<InvalidOperationException>()),
        );
      },
    );
    test('Replacing works correctly', () {
      final plan = BasalPlan();

      final segment1 = BasalSegment(
        start: plan.segments[0].start,
        end: BasalTime(hour: 10, minute: 15),
        basalRate: plan.segments[0].basalRate,
      );
      final segment2 = BasalSegment(
        start: segment1.end,
        end: BasalTime(hour: 15, minute: 20),
        basalRate: 20,
      );
      final segment3 = BasalSegment(
        start: segment2.end,
        end: BasalTime.latest,
        basalRate: 12,
      );

      final replacement1 = BasalSegment(
        start: segment1.start,
        end: segment1.end,
        basalRate: 18,
      );
      final replacement2 = BasalSegment(
        start: BasalTime(hour: 9, minute: 0),
        end: BasalTime(hour: 16, minute: 0),
        basalRate: 99,
      );
      final replacement3 = BasalSegment(
        start: BasalTime(hour: 19, minute: 15),
        end: segment3.end,
        basalRate: 11,
      );

      final expected1 = [
        replacement1,
        segment2,
        segment3,
      ];
      final expected2 = [
        BasalSegment(
          start: replacement1.start,
          end: replacement2.start,
          basalRate: replacement1.basalRate,
        ),
        replacement2,
        BasalSegment(
          start: replacement2.end,
          end: segment3.end,
          basalRate: segment3.basalRate,
        ),
      ];
      final expected3 = [
        expected2[0],
        BasalSegment(
          start: replacement2.start,
          end: replacement3.start,
          basalRate: replacement2.basalRate,
        ),
        replacement3,
      ];

      plan.add(segment2);
      plan.add(segment3);

      plan.replaceAt(0, replacement1);
      expect(
        listEquals(plan.segments, expected1),
        true,
        reason: 'Replaced first segment (basal rate only)',
      );

      plan.replaceAt(1, replacement2);
      expect(
        listEquals(plan.segments, expected2),
        true,
        reason: 'Replaced middle segment (overlapping first and last)',
      );

      plan.replaceAt(2, replacement3);
      expect(
        listEquals(plan.segments, expected3),
        true,
        reason: 'Replaced last segment (middle segments should expand)',
      );
    });
  });
}
