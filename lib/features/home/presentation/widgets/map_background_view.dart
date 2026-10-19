import 'package:flutter/material.dart';

class MapBackgroundView extends StatelessWidget {
  final VoidCallback? onRecenter;

  const MapBackgroundView({
    super.key,
    this.onRecenter,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map Canvas Drawing (Streets, Highways, Water, Blocks)
        Positioned.fill(
          child: CustomPaint(
            painter: _MapCanvasPainter(),
          ),
        ),

        // Landmark: JNTU University Badge
        Positioned(
          top: 155,
          left: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 15),
              ),
              const SizedBox(width: 5),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jawaharlal\nNehru\nTechnological\nUniversity...',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'జవహర్‌లాల్ నెహ్రూ సాంకేతిక\nవిశ్వవిద్యాలయం\nహైదరాబాద్',
                    style: TextStyle(
                      fontSize: 8.5,
                      color: Color(0xFF3B82F6),
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Center Location: Green "T" Marker & Blue User Dot (Matching screenshot)
        Positioned(
          top: 180,
          left: MediaQuery.of(context).size.width * 0.46,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green "T" Pin Marker
              SizedBox(
                width: 36,
                height: 46,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'T',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      child: CustomPaint(
                        size: const Size(11, 9),
                        painter: _PinBottomPointerPainter(color: const Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Blue User GPS Dot
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Road Names Overlay
        Positioned(
          top: 215,
          right: 50,
          child: Transform.rotate(
            angle: -0.45,
            child: const Text(
              'Rythubazar Rd',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
        Positioned(
          top: 270,
          right: 75,
          child: Transform.rotate(
            angle: 0.85,
            child: const Text(
              'Road No. 5',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 390,
          left: 145,
          child: const Text(
            'eSeva Ln',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        Positioned(
          bottom: 390,
          right: 32,
          child: Transform.rotate(
            angle: 0.85,
            child: const Text(
              'GP Rao Ests Rd',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 330,
          left: 32,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'KPHB 6th Phase Rd',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'KUKATPALLY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        // Bottom Right Landmark: TIG... marker (visible right above sheet in screenshot)
        Positioned(
          bottom: 322,
          right: 14,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFF047857),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'TIG...',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF047857),
                    ),
                  ),
                  Text(
                    'టైటి...',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF047857),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Floating Target GPS Recenter Button (Right side, matching screenshot)
        Positioned(
          bottom: 360,
          right: 18,
          child: Material(
            elevation: 4,
            shadowColor: Colors.black.withValues(alpha: 0.2),
            shape: const CircleBorder(),
            color: Colors.white,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onRecenter,
              child: const SizedBox(
                width: 46,
                height: 46,
                child: Center(
                  child: Icon(
                    Icons.my_location_rounded,
                    color: Color(0xFF1E293B),
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PinBottomPointerPainter extends CustomPainter {
  final Color color;
  _PinBottomPointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapCanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Base map background (Light clean Google Maps grey-white)
    final bgPaint = Paint()..color = const Color(0xFFF3F4F6);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. City block patches (Slightly warmer white-grey)
    final blockPaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(10, 140, 160, 150), const Radius.circular(8)),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(180, 190, 180, 130), const Radius.circular(8)),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(40, 310, 140, 160), const Radius.circular(8)),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(190, 340, 170, 180), const Radius.circular(8)),
      blockPaint,
    );

    // 3. Minor local roads (Thin white with grey border lines)
    final roadBorderPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;

    final roadSurfacePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    // Road 1: Diagonal street from Kukatpally through center
    final road1 = Path()
      ..moveTo(-20, 480)
      ..lineTo(size.width * 0.52, 220)
      ..lineTo(size.width * 0.45, 80);
    canvas.drawPath(road1, roadBorderPaint);
    canvas.drawPath(road1, roadSurfacePaint);

    // Road 2: Cross street eSeva lane
    final road2 = Path()
      ..moveTo(20, 340)
      ..lineTo(size.width + 20, 410);
    canvas.drawPath(road2, roadBorderPaint);
    canvas.drawPath(road2, roadSurfacePaint);

    // Road 3: Rythubazar connecting diagonal
    final road3 = Path()
      ..moveTo(size.width * 0.42, 240)
      ..lineTo(size.width + 10, 330);
    canvas.drawPath(road3, roadBorderPaint);
    canvas.drawPath(road3, roadSurfacePaint);

    // Road 4: Vertical road No. 5
    final road4 = Path()
      ..moveTo(size.width * 0.65, 140)
      ..lineTo(size.width * 0.58, 480);
    canvas.drawPath(road4, roadBorderPaint);
    canvas.drawPath(road4, roadSurfacePaint);

    // Road 5: KPHB 6th Phase Rd
    final road5 = Path()
      ..moveTo(-10, 380)
      ..lineTo(140, 490);
    canvas.drawPath(road5, roadBorderPaint);
    canvas.drawPath(road5, roadSurfacePaint);

    // 4. Yellow Arterial Highway (Matching top-right curved yellow highway in screenshot)
    final highwayCasingPaint = Paint()
      ..color = const Color(0xFFCA8A04)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final highwaySurfacePaint = Paint()
      ..color = const Color(0xFFFDE047) // Distinct Google Maps highway yellow
      ..strokeWidth = 11
      ..style = PaintingStyle.stroke;

    final highwayPath = Path()
      ..moveTo(-30, 95)
      ..cubicTo(size.width * 0.35, 90, size.width * 0.55, 160, size.width + 40, 240);

    canvas.drawPath(highwayPath, highwayCasingPaint);
    canvas.drawPath(highwayPath, highwaySurfacePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
