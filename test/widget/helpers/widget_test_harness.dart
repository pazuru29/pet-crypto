import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/theme/app_theme_provider.dart';
import 'package:pet_crypto/core/util/app_storage_keys.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'in_memory_preferences_storage.dart';

class PumpedTestApp {
  final InMemoryPreferencesStorage storage;
  final S localization;
  final AppThemeProvider theme;

  const PumpedTestApp({
    required this.storage,
    required this.localization,
    required this.theme,
  });
}

class _TestApp extends StatelessWidget {
  final Widget? home;
  final GoRouter? router;

  const _TestApp.home({required Widget child}) : home = child, router = null;

  const _TestApp.router({required GoRouter this.router}) : home = null;

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<S>();
    final theme = context.watch<AppThemeProvider>();

    if (router != null) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: AppThemeProvider.lightTheme,
        darkTheme: AppThemeProvider.darkTheme,
        themeMode: theme.mode,
        locale: localization.locale,
        supportedLocales: S.supportedLocales.values,
        localizationsDelegates: S.localizationDelegates,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeProvider.lightTheme,
      darkTheme: AppThemeProvider.darkTheme,
      themeMode: theme.mode,
      locale: localization.locale,
      supportedLocales: S.supportedLocales.values,
      localizationsDelegates: S.localizationDelegates,
      home: home,
    );
  }
}

PumpedTestApp _prepareDependencies(
  WidgetTester tester, {
  required Locale locale,
  required ThemeMode themeMode,
  required Size viewport,
}) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = viewport;

  final storage = InMemoryPreferencesStorage(
    initialValues: {
      AppStorageKeys.locale: locale.languageCode,
      AppStorageKeys.themeMode: themeMode.index,
    },
  );

  final localization = S(storage: storage)..init();
  final theme = AppThemeProvider(storage: storage)..init();

  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();

    localization.dispose();
    theme.dispose();
  });

  return PumpedTestApp(
    storage: storage,
    localization: localization,
    theme: theme,
  );
}

Future<PumpedTestApp> pumpTestApp(
  WidgetTester tester, {
  required Widget child,
  Locale locale = const Locale('en'),
  ThemeMode themeMode = ThemeMode.light,
  List<SingleChildWidget> providers = const [],
  Size viewport = const Size(390, 844),
}) async {
  final dependencies = _prepareDependencies(
    tester,
    locale: locale,
    themeMode: themeMode,
    viewport: viewport,
  );

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<S>.value(value: dependencies.localization),
        ChangeNotifierProvider<AppThemeProvider>.value(
          value: dependencies.theme,
        ),
        ...providers,
      ],
      child: _TestApp.home(child: child),
    ),
  );

  await tester.pump();

  return dependencies;
}

Future<PumpedTestApp> pumpTestRouter(
  WidgetTester tester, {
  required GoRouter router,
  Locale locale = const Locale('en'),
  ThemeMode themeMode = ThemeMode.light,
  List<SingleChildWidget> providers = const [],
  Size viewport = const Size(390, 844),
}) async {
  final dependencies = _prepareDependencies(
    tester,
    locale: locale,
    themeMode: themeMode,
    viewport: viewport,
  );

  addTearDown(router.dispose);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<S>.value(value: dependencies.localization),
        ChangeNotifierProvider<AppThemeProvider>.value(
          value: dependencies.theme,
        ),
        ...providers,
      ],
      child: _TestApp.router(router: router),
    ),
  );

  await tester.pump();

  return dependencies;
}
