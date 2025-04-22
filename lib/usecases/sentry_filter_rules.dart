import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

FutureOr<SentryEvent?> sentryFilterRules(SentryEvent event, Hint hint) {
  return event;
}
