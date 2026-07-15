abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const diary = '/diary';
  static const addFood = '/food/add';
  static const copyMeal = '/food/copy-meal';
  static const customFood = '/food/custom';
  static const scanner = '/scanner';
  static const scanResults = '/scanner/results';
  static const water = '/progress/water';
  static const weight = '/progress/weight';
  static const progress = '/progress';
  static const goals = '/profile/goals';
  static const profile = '/profile';
  static const reminders = '/profile/reminders';
  static const units = '/profile/units';
  static const personalDetails = '/profile/personal-details';
  static const privacy = '/profile/privacy';
  static const helpSupport = '/profile/help-support';

  static const all = <String>{
    splash,
    login,
    signUp,
    forgotPassword,
    onboarding,
    home,
    diary,
    addFood,
    copyMeal,
    customFood,
    scanner,
    scanResults,
    water,
    weight,
    progress,
    goals,
    profile,
    reminders,
    units,
    personalDetails,
    privacy,
    helpSupport,
  };
}
