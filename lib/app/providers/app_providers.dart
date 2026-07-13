import 'package:calora/app/providers/theme_provider.dart';
import 'package:calora/features/auth/providers/auth_provider.dart';
import 'package:calora/features/auth/services/auth_service.dart';
import 'package:calora/features/auth/services/user_profile_service.dart';
import 'package:calora/features/diary/providers/diary_provider.dart';
import 'package:calora/features/diary/services/diary_service.dart';
import 'package:calora/features/home/providers/home_provider.dart';
import 'package:calora/features/home/services/home_dashboard_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> appProviders = <SingleChildWidget>[
  ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
  Provider<AuthService>(create: (_) => FirebaseAuthService()),
  Provider<UserProfileService>(create: (_) => FirestoreUserProfileService()),
  Provider<HomeDashboardService>(
    create: (_) => FirestoreHomeDashboardService(),
  ),
  Provider<DiaryService>(create: (_) => FirestoreDiaryService()),
  ChangeNotifierProvider<AuthProvider>(
    create: (context) => AuthProvider(
      context.read<AuthService>(),
      context.read<UserProfileService>(),
    ),
  ),
  ChangeNotifierProxyProvider<AuthProvider, HomeProvider>(
    create: (context) => HomeProvider(context.read<HomeDashboardService>()),
    update: (_, auth, home) => home!..updateUser(auth.profile),
  ),
  ChangeNotifierProxyProvider<AuthProvider, DiaryProvider>(
    create: (context) => DiaryProvider(context.read<DiaryService>()),
    update: (_, auth, diary) => diary!..updateUser(auth.profile),
  ),
];
