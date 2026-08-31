import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// Menyiapkan lingkungan widget test agar tidak bergantung pada jaringan:
/// - `path_provider` dimock supaya `CachedNetworkImage` tidak melempar
///   `MissingPluginException`.
/// - `google_fonts` dilarang mengunduh berkas font saat pengujian.
void setUpWidgetTest() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  const channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        channel,
        (methodCall) async =>
            Directory.systemTemp.createTempSync('ditonton').path,
      );
}
