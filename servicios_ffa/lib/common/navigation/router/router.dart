import 'package:servicios_ffa/common/navigation/router/routes.dart';
import 'package:servicios_ffa/features/clientes/ui/clientes_screen.dart';
import 'package:servicios_ffa/features/trip/ui/trips_list/menu_servicios.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:servicios_ffa/features/clientes/ui/crear_cliente.dart';
import 'package:servicios_ffa/features/clientes/ui/pedidos.dart';



final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      builder: (context, state) => const MyApp(),
    ),
      
    GoRoute(
      path: '/clientes',
      name: AppRoute.clientes.name,
      builder: (context, state) => const ClientesScreen(),
    ),
    GoRoute(
      path: '/crearcliente',
      name: AppRoute.crearcliente.name,
      builder: (context, state) => const CrearCliente(),
    ),
     GoRoute(
      path: '/pedidos',
      name: AppRoute.pedidos.name,
      builder: (context, state) =>   CrearPedidoScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(state.error.toString()),
    ),
  ),
);