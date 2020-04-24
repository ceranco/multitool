import 'package:flutter_test/flutter_test.dart';
import 'package:multitool/basal_plan_recorder/models/basal_time.dart';

void main() {
  group('BasalTime', () {
    test('Identical instances should be equal', () {
      final hour = 10;
      final minute = 11;

      final time1 = BasalTime(hour: hour, minute: minute);
      final time2 = BasalTime(hour: hour, minute: minute);

      expect(time1 == time2, true);
    });
    test('Different instances should not be equal', () {
      // different hour
      {
        final hour1 = 10;
        final hour2 = 11;
        final minute = 0;

        final time1 = BasalTime(hour: hour1, minute: minute);
        final time2 = BasalTime(hour: hour2, minute: minute);

        expect(time1 == time2, false, reason: 'minute field is different');
      }
      // different minute
      {
        final hour = 10;
        final minute1 = 0;
        final minute2 = 20;

        final time1 = BasalTime(hour: hour, minute: minute1);
        final time2 = BasalTime(hour: hour, minute: minute2);

        expect(time1 == time2, false, reason: 'minute field is different');
      }
      // different hour and minute
      {
        final hour1 = 10;
        final hour2 = 11;
        final minute1 = 0;
        final minute2 = 20;

        final time1 = BasalTime(hour: hour1, minute: minute1);
        final time2 = BasalTime(hour: hour2, minute: minute2);

        expect(time1 == time2, false,
            reason: 'hour and minute fields are different');
      }
    });
    test('Identical instances shouldn\'t greater / lesser than one another',
        () {
      final hour = 23;
      final minute = 10;

      final time1 = BasalTime(hour: hour, minute: minute);
      final time2 = BasalTime(hour: hour, minute: minute);

      expect(time1 > time2, false, reason: 'Instances are identical');
      expect(time1 < time2, false, reason: 'Instances are identical');
    });
    test('Greater / lesser than operators should work', () {
      // Different hour
      {
        final hour1 = 5;
        final hour2 = 6;
        final minute = 10;

        final time1 = BasalTime(hour: hour1, minute: minute);
        final time2 = BasalTime(hour: hour2, minute: minute);

        expect(time1 > time2, false, reason: 'time1 hour is earlier');
        expect(time1 < time2, true, reason: 'time1 hour is earlier');
      }
      // Different minute
      {
        final hour = 10;
        final minute1 = 10;
        final minute2 = 30;

        final time1 = BasalTime(hour: hour, minute: minute1);
        final time2 = BasalTime(hour: hour, minute: minute2);

        expect(time1 > time2, false, reason: 'time1 minute is earlier');
        expect(time1 < time2, true, reason: 'time1 minute is earlier');
      }
    });
  });
}
