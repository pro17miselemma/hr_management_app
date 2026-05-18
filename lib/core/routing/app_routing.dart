import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/presentation/employee_details_screen.dart';
import '../../features/presentation/home_screen.dart';
import '../models/employee_model.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/employee/:id', builder: (context, state) => EmployeeDetailsScreen(employee: state.extra as Employee)),
  ]
);