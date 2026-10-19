import 'package:flutter/material.dart';

class RouteMapView extends StatelessWidget {
  final VoidCallback? onRecenter;

  const RouteMapView({
    super.key,
    this.onRecenter,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // 1. Map Canvas with Road Networks, Highways, and Black Route Polyline
        Positioned.fill(
          child: CustomPaint(
            painter: _RouteMapCanvasPainter(),
          ),
        ),

        // 2. City Labels: Miyapur
        Positioned(
          top: 130,
          left: 45,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Miyapur',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'మియాపూర్',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),

        // 3. City Labels: Serilingampalle
        Positioned(
          top: 185,
          left: 8,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Serilingampalle\n(M)',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                  height: 1.15,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'శేరిలింగంపల్లి',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),

        // 4. Yellow Auto Icon on the Highway near Pickup
        Positioned(
          top: 165,
          left: size.width * 0.30,
          child: Container(
            width: 22,
            height: 26,
            decoration: BoxDecoration(
              color: const Color(0xFF047857),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFFBBF24), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.electric_rickshaw_rounded,
                color: Color(0xFFFBBF24),
                size: 14,
              ),
            ),
          ),
        ),

        // 5. Origin Point: Green Concentric Ring & Blue User Dot (Matching screenshot)
        Positioned(
          top: 162,
          left: size.width * 0.39,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green Concentric Pickup Ring
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF10B981), width: 3.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              // Blue User GPS Dot
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2563EB),
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 6. Area Label: MADHAPUR
        Positioned(
          top: 250,
          left: size.width * 0.30,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'MADHAPUR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF475569),
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'మాదాపూర్',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),

        // 7. Destination Red Pin Marker with letter "D" (Matching screenshot)
        Positioned(
          top: 256,
          left: size.width * 0.58,
          child: SizedBox(
            width: 28,
            height: 38,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Red pin circle
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'D',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Pin pointer triangle
                Positioned(
                  bottom: 5,
                  child: CustomPaint(
                    size: const Size(10, 8),
                    painter: _PinTrianglePainter(color: const Color(0xFFEF4444)),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 8. Area Label: Nanakramguda
        Positioned(
          top: 305,
          left: 40,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nanakramguda',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF475569),
                ),
              ),
              Text(
                'నానాక్రంగూడ',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),

        // 9. Area Label: Hyderabad (bold prominent label near bottom of map)
        Positioned(
          top: 310,
          left: size.width * 0.58,
          child: const Text(
            'Hyderabad',
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
        ),

        // 10. Recenter GPS Button on the Right
        Positioned(
          top: 220,
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
                width: 44,
                height: 44,
                child: Center(
                  child: Icon(
                    Icons.my_location_rounded,
                    color: Color(0xFF1E293B),
                    size: 21,
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

class _PinTrianglePainter extends CustomPainter {
  final Color color;
  _PinTrianglePainter({required this.color});

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

class _RouteMapCanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Base map background (Clean light Google Maps tone)
    final bgPaint = Paint()..color = const Color(0xFFF3F4F6);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. City patches / blocks
    final blockPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(20, 80, 140, 100), const Radius.circular(8)),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(180, 110, 160, 90), const Radius.circular(8)),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(40, 220, 180, 120), const Radius.circular(8)),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(240, 240, 150, 100), const Radius.circular(8)),
      blockPaint,
    );

    // 3. Minor local roads (White with light grey borders)
    final roadBorderPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final roadSurfacePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Road A: Miyapur connecting road
    final roadA = Path()
      ..moveTo(-20, 140)
      ..lineTo(size.width * 0.45, 120)
      ..lineTo(size.width + 20, 100);
    canvas.drawPath(roadA, roadBorderPaint);
    canvas.drawPath(roadA, roadSurfacePaint);

    // Road B: Madhapur to Gachibowli connection
    final roadB = Path()
      ..moveTo(20, 310)
      ..lineTo(size.width * 0.55, 270)
      ..lineTo(size.width + 20, 250);
    canvas.drawPath(roadB, roadBorderPaint);
    canvas.drawPath(roadB, roadSurfacePaint);

    // 4. Yellow Arterial Highway (Google Maps yellow with orange casing)
    final highwayCasing = Paint()
      ..color = const Color(0xFFEAB308)
      ..strokeWidth = 11
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final highwaySurface = Paint()
      ..color = const Color(0xFFFDE047)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Highway 1: Main Mumbai Highway via Miyapur
    final hw1 = Path()
      ..moveTo(-20, 175)
      ..cubicTo(size.width * 0.3, 175, size.width * 0.5, 200, size.width * 0.72, 300)
      ..lineTo(size.width + 30, 360);
    canvas.drawPath(hw1, highwayCasing);
    canvas.drawPath(hw1, highwaySurface);

    // Highway 2: Arterial heading north-east
    final hw2 = Path()
      ..moveTo(size.width * 0.72, 300)
      ..cubicTo(size.width * 0.76, 200, size.width * 0.85, 120, size.width * 0.95, -20);
    canvas.drawPath(hw2, highwayCasing);
    canvas.drawPath(hw2, highwaySurface);

    // 5. Black Solid Route Polyline (Matching the exact route line in screenshot)
    final routePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 5.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final routePath = Path()
      ..moveTo(size.width * 0.40, 190) // Start at Origin (Green/Blue dot)
      ..lineTo(size.width * 0.38, 205)
      ..lineTo(size.width * 0.37, 222)
      ..lineTo(size.width * 0.42, 225)
      ..lineTo(size.width * 0.52, 225)
      ..lineTo(size.width * 0.54, 235)
      ..lineTo(size.width * 0.60, 275); // End at Destination (Red Pin D)

    canvas.drawPath(routePath, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
