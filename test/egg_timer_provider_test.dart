import 'package:flutter_test/flutter_test.dart';
import 'package:boil_eggs/providers/egg_timer_provider.dart';
void main() {
  group('EggTimerProvider', () {
    late EggTimerProvider provider;
    setUp(() {
      provider = EggTimerProvider();
    });
    test('Initial state is idle', () {
      expect(provider.status, TimerStatus.idle);
      expect(provider.selectedDoneness, null);
    });
    test('Selecting doneness calculates correct time (Medium Egg)', () {
      provider.selectDoneness(EggDoneness.medium);
      expect(provider.selectedDoneness, EggDoneness.medium);
      expect(provider.remainingSeconds, 480);
    });
    test('Size adjustment affects time', () {
      provider.selectDoneness(EggDoneness.medium);
      provider.setSize(EggSize.large);
      expect(provider.remainingSeconds, 480 + 30);
      provider.setSize(EggSize.small);
      expect(provider.remainingSeconds, 480 - 30);
    });
    test('Temperature adjustment affects time', () {
      provider.selectDoneness(EggDoneness.medium);
      provider.setTemp(EggTemp.room);
      expect(provider.remainingSeconds, 480 - 60);
    });
    test('Combined adjustments work correctly', () {
      provider.selectDoneness(EggDoneness.soft);
      provider.setSize(EggSize.large);
      provider.setTemp(EggTemp.room);
      expect(provider.remainingSeconds, 330);
    });
    test('Upgrade doneness works', () {
      provider.selectDoneness(EggDoneness.soft);
      expect(provider.remainingSeconds, 360);
      provider.upgradeDoneness(EggDoneness.medium);
      expect(provider.selectedDoneness, EggDoneness.medium);
      expect(provider.remainingSeconds, 360 + 120);
    });
  });
}
