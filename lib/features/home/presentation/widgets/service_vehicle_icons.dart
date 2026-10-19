import 'package:flutter/material.dart';

class ServiceVehicleIcon extends StatelessWidget {
  final String serviceId;
  final double size;

  const ServiceVehicleIcon({
    super.key,
    required this.serviceId,
    this.size = 54,
  });

  @override
  Widget build(BuildContext context) {
    switch (serviceId.toLowerCase()) {
      case 'bike':
        return _buildBikeIcon();
      case 'auto':
        return _buildAutoIcon();
      case 'cab':
        return _buildCabIcon();
      case 'parcel':
        return _buildParcelIcon();
      case 'rentals':
        return _buildRentalsIcon();
      case 'outstation':
        return _buildOutstationIcon();
      default:
        return _buildCabIcon();
    }
  }

  Widget _buildBikeIcon() {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base bike shape
          Container(
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.two_wheeler_rounded,
              size: 42,
              color: Color(0xFF1E293B),
            ),
          ),
          // Sporty accent highlights
          Positioned(
            top: 13,
            right: 14,
            child: Container(
              width: 14,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFFBBF24),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: 17,
            child: Container(
              width: 6,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoIcon() {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.electric_rickshaw_rounded,
              size: 44,
              color: Color(0xFF047857), // Green auto body
            ),
          ),
          // Yellow roof cap (Iconic Indian Auto Rickshaw look)
          Positioned(
            top: 10,
            child: Container(
              width: 28,
              height: 7,
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCabIcon() {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.local_taxi_rounded,
              size: 44,
              color: Color(0xFFF59E0B), // Yellow taxi cab
            ),
          ),
          // Rooftop taxi light bar
          Positioned(
            top: 11,
            child: Container(
              width: 14,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParcelIcon() {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Box
          Positioned(
            bottom: 11,
            left: 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFD97706),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: const Color(0xFFB45309), width: 1),
              ),
              child: Center(
                child: Container(
                  width: 5,
                  height: 20,
                  color: const Color(0xFFFCD34D).withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
          // Main Front Box
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFB45309),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 6,
                  height: 24,
                  color: const Color(0xFFFDE68A).withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
          // Top smaller box
          Positioned(
            top: 9,
            right: 14,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentalsIcon() {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Yellow Car
          Container(
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.directions_car_rounded,
              size: 42,
              color: Color(0xFFF59E0B),
            ),
          ),
          // Red Clock / Timer Badge
          Positioned(
            top: 6,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.access_time_filled_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutstationIcon() {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Car
          Container(
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              size: 42,
              color: Color(0xFFD97706),
            ),
          ),
          // Driver / Shield Badge
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
