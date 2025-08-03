import 'package:servicios_ffa/common/navigation/router/routes.dart';
import 'package:servicios_ffa/features/trip/ui/trips_list/trips_list_page.dart';
import 'package:servicios_ffa/features/trip/ui/trips_list/menu_servicios.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      builder: (context, state) => const MyApp(),
    ),
      GoRoute(
      path: '/trip',
      name: AppRoute.trip.name,
      builder: (context, state) => const TripsListPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(state.error.toString()),
    ),
  ),
);