import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:pet_crypto/application/localization/s.dart';
import 'package:pet_crypto/application/router/app_router.dart';
import 'package:pet_crypto/application/theme/app_theme_provider.dart';
import 'package:pet_crypto/core/util/bloc/observers/app_bloc_observer.dart';
import 'package:pet_crypto/core/util/log.dart';
import 'package:pet_crypto/di/dependency_injector.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_cubit.dart';
import 'package:provider/provider.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Init logging
      Log.init();

      // Add logging for BLoC
      if (kDebugMode) {
        Bloc.observer = AppBlocObserver();
      }

      // Init DI
      await DI.init();

      // Init Localization
      S localizationProvider = DI.get<S>();
      localizationProvider.init();

      // Init Theme
      AppThemeProvider themeProvider = DI.get<AppThemeProvider>();
      themeProvider.init();

      // Run App
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => localizationProvider),
            ChangeNotifierProvider(create: (context) => themeProvider),
          ],
          child: const MyApp(),
        ),
      );
    },
    (error, trace) {
      Logger('APP').severe('ERROR', error, trace);
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthCubit authCubit;
  late final AppRouter appRouter;
  late final S localeProvider;
  late final AppThemeProvider themeProvider;

  @override
  void initState() {
    localeProvider = context.read<S>();
    themeProvider = context.read<AppThemeProvider>();
    authCubit = DI.get<AuthCubit>();
    appRouter = DI.get<AppRouter>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: authCubit,
      child: MaterialApp.router(
        title: 'Pet Crypto',
        theme: AppThemeProvider.lightTheme,
        darkTheme: AppThemeProvider.darkTheme,
        themeMode: themeProvider.mode,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.router,
        locale: localeProvider.locale,
        supportedLocales: S.supportedLocales.values,
        localizationsDelegates: S.localizationDelegates,
      ),
    );
  }
}
