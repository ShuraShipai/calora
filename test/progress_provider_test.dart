import 'dart:async';

import 'package:calora/core/models/user_profile.dart';
import 'package:calora/features/progress/models/water_entry.dart';
import 'package:calora/features/progress/models/weight_entry.dart';
import 'package:calora/features/progress/providers/progress_provider.dart';
import 'package:calora/features/progress/services/progress_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'progress provider persists water and weight entries for the user',
    () async {
      final service = _FakeProgressService();
      final provider = ProgressProvider(service);
      addTearDown(() async {
        provider.dispose();
        await service.dispose();
      });
      provider.updateUser(
        const UserProfile(
          uid: 'user-1',
          name: 'Aanya',
          isAnonymous: false,
          onboardingComplete: true,
        ),
      );

      await provider.addWater(500);
      final loggedAt = DateTime.now();
      await provider.addWeight(
        weightKg: 68.4,
        loggedAt: loggedAt,
        note: 'Feeling steady',
      );
      await Future<void>.delayed(Duration.zero);

      expect(service.waterEntries.single.amountMl, 500);
      expect(service.weightEntries.single.weightKg, 68.4);
      expect(service.weightEntries.single.loggedAt, loggedAt);
      expect(provider.waterTodayMl, 500);
      expect(provider.latestWeight?.note, 'Feeling steady');
    },
  );

  test('progress provider calculates the monthly weight change', () async {
    final service = _FakeProgressService();
    final provider = ProgressProvider(service);
    addTearDown(() async {
      provider.dispose();
      await service.dispose();
    });
    provider.updateUser(
      const UserProfile(
        uid: 'user-1',
        name: 'Aanya',
        isAnonymous: false,
        onboardingComplete: true,
      ),
    );
    final now = DateTime.now();
    service.weightController.add(<WeightEntry>[
      WeightEntry(id: 'new', weightKg: 67.8, loggedAt: now),
      WeightEntry(
        id: 'old',
        weightKg: 68.6,
        loggedAt: DateTime(now.year, now.month, 1),
      ),
    ]);
    await Future<void>.delayed(Duration.zero);

    expect(provider.weightChangeThisMonth, closeTo(-0.8, 0.001));
    expect(provider.weightTrend, <double>[68.6, 67.8]);
  });

  test('exposes a load error from a progress stream', () async {
    final service = _FakeProgressService();
    final provider = ProgressProvider(service);
    addTearDown(() async {
      provider.dispose();
      await service.dispose();
    });
    provider.updateUser(
      const UserProfile(
        uid: 'user-1',
        name: 'Aanya',
        isAnonymous: false,
        onboardingComplete: true,
      ),
    );

    service.waterController.addError(StateError('Firestore unavailable'));
    await Future<void>.delayed(Duration.zero);

    expect(provider.errorMessage, 'Could not load progress entries.');
  });
}

class _FakeProgressService implements ProgressService {
  final waterController = StreamController<List<WaterEntry>>.broadcast();
  final weightController = StreamController<List<WeightEntry>>.broadcast();
  final waterEntries = <WaterEntry>[];
  final weightEntries = <WeightEntry>[];

  @override
  Future<void> addWaterEntry(String uid, WaterEntry entry) async {
    waterEntries.insert(0, entry);
    waterController.add(waterEntries);
  }

  @override
  Future<void> addWeightEntry(String uid, WeightEntry entry) async {
    weightEntries.insert(0, entry);
    weightController.add(weightEntries);
  }

  @override
  Stream<List<WaterEntry>> watchWaterEntries(String uid) =>
      waterController.stream;

  @override
  Stream<List<WeightEntry>> watchWeightEntries(String uid) =>
      weightController.stream;

  Future<void> dispose() async {
    await waterController.close();
    await weightController.close();
  }
}
