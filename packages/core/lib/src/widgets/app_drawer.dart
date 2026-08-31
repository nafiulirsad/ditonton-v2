import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../common/routes.dart';

/// Menu navigasi utama yang dipakai bersama oleh modul movie dan tv_series.
///
/// Navigasi dilakukan lewat nama rute pada [AppRoutes] sehingga modul core tidak
/// perlu mengenal kelas halaman milik modul fitur.
class AppDrawer extends StatelessWidget {
  /// Nama rute halaman yang sedang aktif, dipakai untuk mencegah navigasi ulang.
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: const AssetImage(kAppLogoAsset),
              backgroundColor: Colors.grey.shade900,
            ),
            accountName: const Text('Ditonton'),
            accountEmail: const Text('ditonton@dicoding.com'),
            decoration: BoxDecoration(color: Colors.grey.shade900),
          ),
          ListTile(
            key: const Key('drawer_movies'),
            leading: const Icon(Icons.movie),
            title: const Text('Movies'),
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != AppRoutes.homeMovie) {
                Navigator.pushReplacementNamed(context, AppRoutes.homeMovie);
              }
            },
          ),
          ListTile(
            key: const Key('drawer_tv_series'),
            leading: const Icon(Icons.tv),
            title: const Text('TV Series'),
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != AppRoutes.homeTvSeries) {
                Navigator.pushReplacementNamed(context, AppRoutes.homeTvSeries);
              }
            },
          ),
          ListTile(
            key: const Key('drawer_watchlist'),
            leading: const Icon(Icons.save_alt),
            title: const Text('Watchlist'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.watchlist);
            },
          ),
          ListTile(
            key: const Key('drawer_about'),
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.about);
            },
          ),
        ],
      ),
    );
  }
}
