import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/user_login_page.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/destination/presentation/bloc/destination_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => ServiceLocator.createAuthBloc(),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => ServiceLocator.createDashboardBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => ServiceLocator.createHomeBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ServiceLocator.createProfileBloc(),
        ),
        BlocProvider<DestinationBloc>(
          create: (_) => ServiceLocator.createDestinationBloc(),
        ),
        BlocProvider<BookingBloc>(
          create: (_) => ServiceLocator.createBookingBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Ride & Carpool',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const UserLoginPage(),
      ),
    );
  }
}
