import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/pages/home_page.dart';
import '../features/map/pages/map_page.dart';

enum Routes {
  home(name: 'home', path: '/'),
  map(name: 'map', path: '/home/map'),
  ;

  final String name;
  final String path;

  const Routes({required this.name, required this.path});
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: _getInitialPath(),
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: Routes.home.name,
      path: Routes.home.path,
      pageBuilder: (context, state) => _buildPage(
        state.pageKey,
        state.name!,
        const HomePage(),
      ),
      routes: [
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: Routes.map.name,
          path: Routes.map.path,
          pageBuilder: (context, state) => _buildPage(
            state.pageKey,
            state.name!,
            MapPage(
              lat: double.parse(state.uri.queryParameters['lat']!),
              lng: double.parse(state.uri.queryParameters['lng']!),
            ),
          ),
        ),
      ],
    ),
  ],
);

Page<MaterialPage> _buildPage(LocalKey key, String name, Widget child) {
  return MaterialPage(
    key: key,
    name: name,
    child: GestureDetector(
      onTap: () => FocusScope.of(_rootNavigatorKey.currentContext!).unfocus(),
      child: child,
    ),
  );
}

String _getInitialPath() {
  return Routes.home.path;
}
