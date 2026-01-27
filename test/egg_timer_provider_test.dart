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
      // Default Size: Medium (0 adj), Temp: Fridge (0 adj)
      // Medium Doneness: 8 mins = 480 seconds
      provider.selectDoneness(EggDoneness.medium);
      
      expect(provider.selectedDoneness, EggDoneness.medium);
      expect(provider.remainingSeconds, 480);
    });

    test('Size adjustment affects time', () {
      // Medium Doneness: 480s
      // Large Size: +30s -> 510s
      provider.selectDoneness(EggDoneness.medium);
      provider.setSize(EggSize.large);
      
      expect(provider.remainingSeconds, 480 + 30);
      
      // Small Size: -30s -> 450s
      provider.setSize(EggSize.small);
      expect(provider.remainingSeconds, 480 - 30);
    });

    test('Temperature adjustment affects time', () {
      // Medium Doneness: 480s (Medium Size default)
      // Room Temp: -60s -> 420s
      provider.selectDoneness(EggDoneness.medium);
      provider.setTemp(EggTemp.room);
      
      expect(provider.remainingSeconds, 480 - 60);
    });

    test('Combined adjustments work correctly', () {
      // Soft (6m = 360s) + Large (+30s) + Room (-60s) = 330s
      provider.selectDoneness(EggDoneness.soft);
      provider.setSize(EggSize.large);
      provider.setTemp(EggTemp.room);
      
      expect(provider.remainingSeconds, 330);
    });
    
    test('Upgrade doneness works', () {
      // Soft (360s) -> Medium (480s)
      // Diff = 120s
      provider.selectDoneness(EggDoneness.soft);
      expect(provider.remainingSeconds, 360);
      
      provider.upgradeDoneness(EggDoneness.medium);
      expect(provider.selectedDoneness, EggDoneness.medium);
      // We added difference to remaining seconds
      expect(provider.remainingSeconds, 360 + 120);
    });
  });
}
