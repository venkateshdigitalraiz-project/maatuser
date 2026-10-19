import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/phone_validator.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/countdown_timer_widget.dart';
import '../widgets/otp_digit_input.dart';
import '../widgets/phone_input_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/ride_type_chips.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<OtpDigitInputState> _otpKey = GlobalKey<OtpDigitInputState>();

  String? _phoneError;
  String _enteredOtp = '';
  String? _otpError;

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSendOtpPressed() {
    FocusScope.of(context).unfocus();
    final validation = PhoneValidator.validatePhoneNumber(_phoneController.text);
    if (validation != null) {
      setState(() {
        _phoneError = validation;
      });
      return;
    }

    setState(() {
      _phoneError = null;
    });

    context.read<AuthBloc>().add(
          SendOtpEvent(phoneNumber: _phoneController.text.trim()),
        );
  }

  void _onVerifyOtpPressed() {
    FocusScope.of(context).unfocus();
    final validation = PhoneValidator.validateOtp(_enteredOtp);
    if (validation != null) {
      setState(() {
        _otpError = validation;
      });
      return;
    }

    setState(() {
      _otpError = null;
    });

    context.read<AuthBloc>().add(
          VerifyOtpEvent(
            phoneNumber: _phoneController.text.trim(),
            otp: _enteredOtp,
          ),
        );
  }

  void _onResendOtp() {
    _otpKey.currentState?.clear();
    setState(() {
      _enteredOtp = '';
      _otpError = null;
    });
    context.read<AuthBloc>().add(
          ResendOtpEvent(phoneNumber: _phoneController.text.trim()),
        );
  }

  void _onEditPhoneNumber() {
    _animationController.reverse().then((_) {
      _otpKey.currentState?.clear();
      setState(() {
        _enteredOtp = '';
        _otpError = null;
      });
      context.read<AuthBloc>().add(const ResetToPhoneInputEvent());
    });
  }

  void _showSuccessDialog(BuildContext context, AuthSuccess state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.accentYellow.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentYellowDark,
                  width: 2.5,
                ),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.accentYellowDark,
                size: 46,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Welcome Aboard!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Logged in as +91 ${state.user.phoneNumber}\nReady to book rides with Bike, Auto, Cab & Carpool!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Find a Ride Now 🚀',
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const DashboardPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthOtpSent) {
              _animationController.forward();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(16),
                  duration: const Duration(seconds: 3),
                ),
              );
            } else if (state is AuthError) {
              if (state.isOtpStep) {
                setState(() => _otpError = state.message);
              } else {
                setState(() => _phoneError = state.message);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(16),
                ),
              );
            } else if (state is AuthSuccess) {
              _showSuccessDialog(context, state);
            }
          },
          builder: (context, state) {
            final bool isOtpPhase = state is AuthOtpSent ||
                state is AuthVerifyingOtp ||
                (state is AuthError && state.isOtpStep);

            final bool isSendingOtp = state is AuthSendingOtp;
            final bool isVerifyingOtp = state is AuthVerifyingOtp;
            final bool isResending = (state is AuthOtpSent) && state.isResending;

            return Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Branding
                      _buildHeader(),

                      const SizedBox(height: 20),

                      // Mobility Service Chips
                      const RideTypeChips(),

                      const SizedBox(height: 24),

                      // Main Card Container
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.border, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Phone Number Field
                            PhoneInputField(
                              controller: _phoneController,
                              isReadOnly: isOtpPhase,
                              errorText: _phoneError,
                              onChanged: (_) {
                                if (_phoneError != null) {
                                  setState(() => _phoneError = null);
                                }
                              },
                              onEditPressed: _onEditPhoneNumber,
                              onClearPressed: () {
                                _phoneController.clear();
                                setState(() => _phoneError = null);
                              },
                            ),

                            // If not in OTP phase, show "Continue / Send OTP" button
                            if (!isOtpPhase) ...[
                              const SizedBox(height: 24),
                              PrimaryButton(
                                text: 'Get Verification Code',
                                icon: Icons.arrow_forward_rounded,
                                isLoading: isSendingOtp,
                                backgroundColor: AppColors.primary,
                                onPressed: _onSendOtpPressed,
                              ),
                            ],

                            // Bottom 4-digit OTP Box Section (Animated)
                            if (isOtpPhase) ...[
                              const SizedBox(height: 24),
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: SlideTransition(
                                  position: _slideAnimation,
                                  child: _buildOtpBottomSection(
                                    isVerifying: isVerifyingOtp,
                                    isResending: isResending,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Demo Hint Banner
                      _buildDemoBanner(),

                      const SizedBox(height: 24),

                      // Footer & Terms
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.electric_moped_rounded, color: AppColors.accentYellow, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'RIDE NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentBlueLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security_rounded, size: 14, color: AppColors.accentBlue),
                  SizedBox(width: 4),
                  Text(
                    'Safe & Verified',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Enter your mobile\nto get moving',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Instant rides, carpooling & deliveries at your fingertips.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpBottomSection({
    required bool isVerifying,
    required bool isResending,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Divider
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.pin_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Enter 4-Digit Code',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.border)),
          ],
        ),
        const SizedBox(height: 18),

        // Subtitle
        Text(
          'We sent a 4-digit verification code to +91 ${_phoneController.text.trim()}',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),

        // 4-Digit OTP Box
        OtpDigitInput(
          key: _otpKey,
          length: 4,
          hasError: _otpError != null,
          onChanged: (otp) {
            setState(() {
              _enteredOtp = otp;
              if (_otpError != null) _otpError = null;
            });
            context.read<AuthBloc>().add(OtpChangedEvent(otp: otp));
          },
          onCompleted: (otp) {
            setState(() {
              _enteredOtp = otp;
              _otpError = null;
            });
            _onVerifyOtpPressed();
          },
        ),

        // OTP Error text
        if (_otpError != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                size: 14,
                color: AppColors.error,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _otpError!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 20),

        // 30s Countdown timer & resend trigger
        CountdownTimerWidget(
          initialSeconds: 30,
          isResending: isResending,
          onResend: _onResendOtp,
        ),

        const SizedBox(height: 24),

        // Verify & Continue Button
        PrimaryButton(
          text: 'Verify & Continue',
          icon: Icons.check_circle_outline,
          isLoading: isVerifying,
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          onPressed: _enteredOtp.length == 4 ? _onVerifyOtpPressed : null,
        ),
      ],
    );
  }

  Widget _buildDemoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9C3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE047)),
      ),
      child: const Row(
        children: [
          Icon(Icons.bolt_rounded, color: Color(0xFFCA8A04), size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Demo Tip: Enter any 10-digit number & use OTP: 1234 to log in.',
              style: TextStyle(
                fontSize: 12.5,
                color: Color(0xFF854D0E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Column(
      children: [
        Text(
          'By proceeding, you agree to our Terms of Service\nand consent to receive SMS notifications.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
