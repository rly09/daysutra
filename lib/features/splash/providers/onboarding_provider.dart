import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../data/repositories/hive_repository.dart';

final onboardingCompletedProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _loadState();
  }

  void _loadState() {
    final box = Hive.box(HiveRepository.settingsBoxName);
    state = box.get('onboardingCompleted', defaultValue: false) as bool;
  }

  Future<void> completeOnboarding() async {
    final box = Hive.box(HiveRepository.settingsBoxName);
    await box.put('onboardingCompleted', true);
    state = true;
  }

  Future<void> resetOnboarding() async {
    final box = Hive.box(HiveRepository.settingsBoxName);
    await box.put('onboardingCompleted', false);
    state = false;
  }
}
