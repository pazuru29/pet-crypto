import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:pet_crypto/core/router/app_router.dart';
import 'package:pet_crypto/core/util/bloc/observers/app_bloc_observer.dart';
import 'package:pet_crypto/core/util/log.dart';
import 'package:pet_crypto/di/dependency_injector.dart';
import 'package:pet_crypto/features/authorization/presentation/bloc/auth_cubit.dart';

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

      // Run App
      runApp(const MyApp());
    },
    (error, trace) {
      Logger('APP').severe('ERROR', error, trace);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => DI.get<AuthCubit>(),
      child: MaterialApp.router(
        title: 'Pet Crypto',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
