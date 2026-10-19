class PhoneValidator {
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your mobile number';
    }

    final cleaned = value.replaceAll(RegExp(r'\D'), '');

    if (cleaned.length < 10) {
      return 'Enter a valid 10-digit mobile number';
    }

    if (cleaned.length > 10) {
      return 'Mobile number must not exceed 10 digits';
    }

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned)) {
      return 'Enter a valid 10-digit mobile number';
    }

    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the 4-digit OTP';
    }

    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length != 4) {
      return 'OTP must be exactly 4 digits';
    }

    return null;
  }
}
