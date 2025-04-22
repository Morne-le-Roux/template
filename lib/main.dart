import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:template/usecases/init_env.dart';
import 'package:template/usecases/init_supabase.dart';
import 'package:template/usecases/run_app_with_wrappers.dart';
import 'package:template/usecases/sentry_filter_rules.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Hydrated Bloc Storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
        (await getApplicationDocumentsDirectory()).path),
  );

  await initEnv(); //Currently only loads single .env file. Adjust if separate .env files are used for different environments.
  await initSupabase(); //Sets global Supabase client and initializes it with the environment variables from the .env file.

  await SentryFlutter.init(
    (options) {
      options.beforeSend = sentryFilterRules;
      options.dsn =
          kDebugMode ? "false-yet" : dotenv.env['SENTRY_DSN'] ?? 'false-yet';
      options.attachScreenshot = true;
      options.environment = appFlavor;
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runAppWithWrappers(MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
