import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:user/injection_container.dart';
import 'package:user/main.dart';

void main() {
  setUp(() {
    ServiceLocator.init();
  });

  testWidgets('UserLoginPage renders correctly and shows mobility chips', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Enter your mobile\nto get moving'), findsOneWidget);
    expect(find.text('Mobile Number'), findsOneWidget);
    expect(find.text('Get Verification Code'), findsOneWidget);
  });

  testWidgets('DashboardPage renders Home tab and navigates to Profile tab', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ServiceLocator.createDashboardBloc()),
          BlocProvider(create: (_) => ServiceLocator.createHomeBloc()),
          BlocProvider(create: (_) => ServiceLocator.createProfileBloc()),
        ],
        child: const MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Home tab elements
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Where are you going ?'), findsOneWidget);
    expect(find.text('Book a Ride'), findsOneWidget);
    expect(find.text('Bike'), findsOneWidget);
    expect(find.text('Auto'), findsOneWidget);
    expect(find.text('Cab'), findsOneWidget);

    // Tap Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // Verify Profile tab elements
    expect(find.text('Account & Profile'), findsOneWidget);
    expect(find.text('Mobility Cash & Wallet'), findsOneWidget);
  });

  testWidgets('Tapping "Where are you going ?" navigates to DestinationAddressPage matching screenshot', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ServiceLocator.createDashboardBloc()),
          BlocProvider(create: (_) => ServiceLocator.createHomeBloc()),
          BlocProvider(create: (_) => ServiceLocator.createProfileBloc()),
          BlocProvider(create: (_) => ServiceLocator.createDestinationBloc()),
        ],
        child: const MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Find and tap "Where are you going ?"
    final searchPill = find.text('Where are you going ?');
    expect(searchPill, findsOneWidget);
    await tester.tap(searchPill);
    await tester.pumpAndSettle();

    // Verify DestinationAddressPage elements matching screenshot
    expect(find.text('Destination address'), findsWidgets); // Title and placeholder
    expect(find.text('Manjeera Majestic Commercial, 30'), findsOneWidget);
    expect(find.text('Select from Map'), findsOneWidget);
    expect(find.text('Add Stop'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Work'), findsOneWidget);
    expect(find.text('Others'), findsOneWidget);

    // Tap back button
    final backBtn = find.byIcon(Icons.chevron_left_rounded);
    expect(backBtn, findsOneWidget);
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    // Verify returned to HomePage
    expect(find.text('Book a Ride'), findsOneWidget);
  });

  testWidgets('Selecting destination opens RideDetailsPage matching ride details screenshot', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ServiceLocator.createDashboardBloc()),
          BlocProvider(create: (_) => ServiceLocator.createHomeBloc()),
          BlocProvider(create: (_) => ServiceLocator.createProfileBloc()),
          BlocProvider(create: (_) => ServiceLocator.createDestinationBloc()),
          BlocProvider(create: (_) => ServiceLocator.createBookingBloc()),
        ],
        child: const MaterialApp(
          home: DashboardPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Tap search bar to open DestinationAddressPage
    await tester.tap(find.text('Where are you going ?'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // 2. Tap a destination suggestion (e.g., JNTU College Metro Station)
    final suggestion = find.text('JNTU College Metro Station');
    expect(suggestion, findsOneWidget);
    await tester.tap(suggestion);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    await tester.pump();
    await tester.pump();

    // 3. Verify RideDetailsPage matching screenshot
    expect(find.text('Ride details'), findsOneWidget);
    expect(find.text('Auto'), findsOneWidget);
    expect(find.text('Bike'), findsOneWidget);
    expect(find.text('Economy Car'), findsOneWidget);
    expect(find.text('₹ 143.0'), findsOneWidget);
    expect(find.text('₹ 129.0'), findsOneWidget);
    expect(find.text('₹ 297.0'), findsOneWidget);
    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('Preference'), findsOneWidget);
    expect(find.text('Coupon'), findsOneWidget);
    expect(find.text('Add Instructions'), findsOneWidget);
    expect(find.text('Book Auto'), findsOneWidget);

    // 4. Select Bike option -> Button updates to "Book Bike"
    await tester.tap(find.text('Bike'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Book Bike'), findsOneWidget);
  });
}
