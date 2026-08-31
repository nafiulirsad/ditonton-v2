import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mockito/annotations.dart';

/// Mock untuk layanan Firebase yang dipakai pada pengujian modul core.
@GenerateNiceMocks([
  MockSpec<FirebaseAnalytics>(),
  MockSpec<FirebaseCrashlytics>(),
])
void main() {}
