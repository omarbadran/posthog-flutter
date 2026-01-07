import 'package:flutter_test/flutter_test.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:posthog_flutter/src/posthog_flutter_platform_interface.dart';

import 'posthog_flutter_platform_interface_fake.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Posthog', () {
    late PosthogFlutterPlatformFake fakePlatformInterface;

    setUp(() {
      fakePlatformInterface = PosthogFlutterPlatformFake();
      PosthogFlutterPlatformInterface.instance = fakePlatformInterface;
    });

    test(
        'setup passes config and onFeatureFlags callback to platform interface',
        () async {
      void testCallback() {}

      final config = PostHogConfig(
        'test_api_key',
        onFeatureFlags: testCallback,
      );

      await Posthog().setup(config);

      expect(fakePlatformInterface.receivedConfig, equals(config));
      expect(fakePlatformInterface.registeredOnFeatureFlagsCallback,
          equals(testCallback));
    });

    test('capture supports event-level groups via \$groups', () async {
      await Posthog().capture(
        eventName: 'thing_happened',
        groups: {
          'company': 'c_123',
          'project': 42,
        },
      );

      expect(fakePlatformInterface.capturedEvents, hasLength(1));
      final call = fakePlatformInterface.capturedEvents.single;
      expect(call.eventName, equals('thing_happened'));

      final properties = call.properties;
      expect(properties, isNotNull);
      expect(properties!.containsKey('\$groups'), isTrue);
      expect(properties['\$groups'], equals({'company': 'c_123', 'project': 42}));
    });

    test('capture merges existing \$groups with groups parameter', () async {
      await Posthog().capture(
        eventName: 'merged_groups',
        properties: {
          '\$groups': {
            'company': 'c_old',
            'team': 't_1',
          },
        },
        groups: {
          'company': 'c_new',
          'project': 'p_9',
        },
      );

      final properties = fakePlatformInterface.capturedEvents.single.properties!;
      expect(
        properties['\$groups'],
        equals({
          'company': 'c_new',
          'team': 't_1',
          'project': 'p_9',
        }),
      );
    });

    test('capture adds \$screen_name when groups provided', () async {
      await Posthog().screen(screenName: 'Checkout');

      await Posthog().capture(
        eventName: 'purchase_clicked',
        groups: {'project': 'p1'},
      );

      final properties = fakePlatformInterface.capturedEvents.last.properties!;
      expect(properties['\$screen_name'], equals('Checkout'));
      expect(properties['\$groups'], equals({'project': 'p1'}));
    });
  });
}
