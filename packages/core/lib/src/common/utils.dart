import 'package:flutter/widgets.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

/// Pesan yang ditampilkan ketika perangkat tidak memiliki koneksi internet.
const String kConnectionFailureMessage = 'Failed to connect to the network';
