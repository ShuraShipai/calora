import 'dart:async';

import 'package:calora/core/models/user_profile.dart';
import 'package:calora/features/home/models/home_dashboard.dart';
import 'package:calora/features/home/services/home_dashboard_service.dart';
import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider(this._dashboardService);

  final HomeDashboardService _dashboardService;
  StreamSubscription<HomeDashboard>? _subscription;
  HomeDashboard _dashboard = HomeDashboard.empty();
  String? _uid;
  bool _isLoading = false;
  int _requestVersion = 0;

  HomeDashboard get dashboard => _dashboard;
  bool get isLoading => _isLoading;

  void updateUser(UserProfile? profile) {
    final uid = profile?.uid;
    final calorieGoal = profile?.onboarding?.dailyCalorieTarget ?? 0;
    if (_uid == uid && _dashboard.calorieGoal == calorieGoal) return;

    _uid = uid;
    _requestVersion++;
    unawaited(_subscription?.cancel());
    _subscription = null;
    _dashboard = HomeDashboard.empty(calorieGoal: calorieGoal);
    _isLoading = uid != null;
    notifyListeners();

    if (uid == null) return;
    final version = _requestVersion;
    _subscription = _dashboardService
        .watchToday(uid: uid, calorieGoal: calorieGoal)
        .listen(
          (dashboard) {
            if (version != _requestVersion) return;
            _dashboard = dashboard;
            _isLoading = false;
            notifyListeners();
          },
          onError: (_, _) {
            if (version != _requestVersion) return;
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
