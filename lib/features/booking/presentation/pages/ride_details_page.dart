import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/ride_option_entity.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../widgets/route_map_view.dart';

class RideDetailsPage extends StatefulWidget {
  final String pickupAddress;
  final String destinationAddress;

  const RideDetailsPage({
    super.key,
    required this.pickupAddress,
    required this.destinationAddress,
  });

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(
          LoadRideOptionsEvent(
            pickupAddress: widget.pickupAddress,
            destinationAddress: widget.destinationAddress,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingConfirmedState) {
            _showBookingConfirmedDialog(context, state.confirmation);
          } else if (state is BookingLoaded && state.actionMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.actionMessage!),
                duration: const Duration(milliseconds: 1400),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // 1. Live Route Map Canvas Background with Highway, Origin, Destination, and Polyline
              Positioned.fill(
                child: RouteMapView(
                  onRecenter: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('📍 Recentered on your ride route'),
                        duration: Duration(milliseconds: 1200),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),

              // 2. Top Header Over Map: Circular Back Button + "(+) Add Stop" Button
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Circular Back Button
                        Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 3,
                          shadowColor: Colors.black.withValues(alpha: 0.15),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => Navigator.pop(context),
                            child: const SizedBox(
                              width: 44,
                              height: 44,
                              child: Center(
                                child: Icon(
                                  Icons.chevron_left_rounded,
                                  color: Color(0xFF0F172A),
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // "(+) Add Stop" Pill Button
                        Material(
                          color: Colors.white,
                          elevation: 3,
                          shadowColor: Colors.black.withValues(alpha: 0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tap to add intermediate stop on route'),
                                  duration: Duration(milliseconds: 1200),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 17,
                                    height: 17,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF0F172A),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 11,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Add Stop',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Anchored Bottom Sheet Card with Ride Details, 3 Options, and "Book Auto" CTA
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildRideDetailsSheet(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Bottom Sheet Card matching the screenshot
  Widget _buildRideDetailsSheet(BuildContext context, BookingState state) {
    final loadedState = state is BookingLoaded ? state : null;
    final options = loadedState?.rideOptions ?? const [];
    final selected = loadedState?.selectedOption;
    final schedule = loadedState?.schedule ?? 'Now';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Header Row: "Ride details" + "Now 📅"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ride details',
                style: TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),

              // "Now 📅" Capsule Button
              Material(
                color: const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: loadedState != null ? () => _showScheduleModal(context, loadedState) : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          schedule,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 15,
                          color: Color(0xFF0F172A),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (loadedState == null || selected == null)
            const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            )
          else ...[
            // 3 Ride Options (Auto, Bike, Economy Car)
            Column(
              children: options.map((option) {
                final isSelected = selected.id == option.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildRideOptionCard(context, option, isSelected),
                );
              }).toList(),
            ),

            const SizedBox(height: 4),

            // Payment, Preference, Coupon Buttons Row
            Row(
              children: [
                // Cash Pill
                Expanded(
                  child: _buildOptionPill(
                    icon: Icons.payments_outlined,
                    label: loadedState.paymentMethod,
                    onTap: () => _showPaymentMethodModal(context, loadedState),
                  ),
                ),
                const SizedBox(width: 8),

                // Preference Pill
                Expanded(
                  child: _buildOptionPill(
                    icon: Icons.tune_rounded,
                    label: 'Preference',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Preferences: AC ride, Quiet ride, Luggage assistance enabled'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // Coupon Pill
                Expanded(
                  child: _buildOptionPill(
                    icon: Icons.local_offer_outlined,
                    label: 'Coupon',
                    onTap: () => _showCouponModal(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // "(+) Add Instructions" Link
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showInstructionsModal(context, loadedState),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF00C853), width: 1.5),
                        ),
                        child: const Center(
                          child: Icon(Icons.add, size: 10, color: Color(0xFF00C853)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        loadedState.instructions != null && loadedState.instructions!.isNotEmpty
                            ? 'Instructions: ${loadedState.instructions}'
                            : 'Add Instructions',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF00C853),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Large Green CTA Button: "Book Auto" (or "Book Bike", "Book Economy Car")
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: loadedState.isBookingInProgress
                    ? null
                    : () {
                        context.read<BookingBloc>().add(const ConfirmBookRideEvent());
                      },
                child: loadedState.isBookingInProgress
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Book ${selected.title}',
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.1,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Individual Ride Option Card (Auto, Bike, Economy Car)
  Widget _buildRideOptionCard(
    BuildContext context,
    RideOptionEntity option,
    bool isSelected,
  ) {
    Color cardBg;
    Color borderColor;

    if (isSelected) {
      cardBg = const Color(0xFFE8F8EE); // Soft green tint matching screenshot
      borderColor = const Color(0xFF10B981);
    } else {
      cardBg = Colors.white;
      borderColor = const Color(0xFFE2E8F0);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          context.read<BookingBloc>().add(SelectRideOptionEvent(option));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Vehicle Graphic Avatar
              _buildVehicleGraphic(option.vehicleType),

              const SizedBox(width: 14),

              // Title + ETA + Info icon
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      option.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          option.etaText,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${option.title}: Includes base fare & verified driver tracking.'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Fare Amount: "₹ 143.0"
              Text(
                '₹ ${option.fare.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Custom Vehicle Graphic (Auto, Bike, Economy Car)
  Widget _buildVehicleGraphic(String vehicleType) {
    if (vehicleType == 'auto') {
      return Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.electric_rickshaw_rounded,
            color: Color(0xFF047857),
            size: 28,
          ),
        ),
      );
    } else if (vehicleType == 'bike') {
      return Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.two_wheeler_rounded,
            color: Color(0xFFD97706),
            size: 28,
          ),
        ),
      );
    } else {
      return Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.directions_car_rounded,
            color: Color(0xFF475569),
            size: 28,
          ),
        ),
      );
    }
  }

  /// Option Pill (Cash, Preference, Coupon)
  Widget _buildOptionPill({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF1F3F5),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: const Color(0xFF0F172A)),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Payment Method Selection Sheet
  void _showPaymentMethodModal(BuildContext context, BookingLoaded state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.money_rounded, color: Color(0xFF10B981)),
                title: const Text('Cash to Driver', style: TextStyle(fontWeight: FontWeight.w700)),
                trailing: state.paymentMethod == 'Cash'
                    ? const Icon(Icons.check_circle, color: Color(0xFF10B981))
                    : null,
                onTap: () {
                  context.read<BookingBloc>().add(const ChangePaymentMethodEvent('Cash'));
                  Navigator.pop(sheetContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF3B82F6)),
                title: const Text('In-App Wallet', style: TextStyle(fontWeight: FontWeight.w700)),
                trailing: state.paymentMethod == 'Wallet'
                    ? const Icon(Icons.check_circle, color: Color(0xFF10B981))
                    : null,
                onTap: () {
                  context.read<BookingBloc>().add(const ChangePaymentMethodEvent('Wallet'));
                  Navigator.pop(sheetContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code_2_rounded, color: Color(0xFF8B5CF6)),
                title: const Text('UPI & Online', style: TextStyle(fontWeight: FontWeight.w700)),
                trailing: state.paymentMethod == 'UPI'
                    ? const Icon(Icons.check_circle, color: Color(0xFF10B981))
                    : null,
                onTap: () {
                  context.read<BookingBloc>().add(const ChangePaymentMethodEvent('UPI'));
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Ride Schedule Modal
  void _showScheduleModal(BuildContext context, BookingLoaded state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pickup Timing',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.flash_on_rounded, color: Color(0xFFF59E0B)),
                title: const Text('Book for Now (4 min away)', style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () {
                  context.read<BookingBloc>().add(const ChangeRideScheduleEvent('Now'));
                  Navigator.pop(sheetContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.alarm_rounded, color: Color(0xFF3B82F6)),
                title: const Text('Schedule for Later today', style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () {
                  context.read<BookingBloc>().add(const ChangeRideScheduleEvent('Later (15 min)'));
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Coupon Modal
  void _showCouponModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Available Coupons',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF10B981)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.discount_rounded, color: Color(0xFF10B981)),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('RIDEFAST20', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                          Text('Get ₹20 off on your next city ride', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🎉 Coupon RIDEFAST20 Applied!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Instructions Modal
  void _showInstructionsModal(BuildContext context, BookingLoaded state) {
    final controller = TextEditingController(text: state.instructions ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pickup Instructions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'e.g. Near gate 2, call upon reaching',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    context.read<BookingBloc>().add(AddInstructionEvent(controller.text));
                    Navigator.pop(sheetContext);
                  },
                  child: const Text(
                    'Save Instructions',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Booking Confirmation Dialog
  void _showBookingConfirmedDialog(
    BuildContext context,
    BookingConfirmationEntity confirmation,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 38,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${confirmation.rideOptionTitle} Booked!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Driver assigned and on the way!',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Start OTP:', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      confirmation.otp,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF00C853),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Fare:', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    '₹${confirmation.fare.toStringAsFixed(1)}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext); // Close dialog
                    Navigator.pop(context); // Return from RideDetailsPage
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
