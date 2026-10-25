import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MaintenanceDialog extends StatefulWidget {
  const MaintenanceDialog({
    super.key,
    this.onRetry,
    this.estimatedTime,
    this.supportPhone,
  });

  final VoidCallback? onRetry;
  final String? estimatedTime;
  final String? supportPhone;

  static const Color primary = Color(0xFF00BCD4); // Cyan
  static const Color primaryDark = Color(0xFF0097A7);
  static const Color primarySoft = Color(0xFFE0F7FA);

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onRetry,
    String? estimatedTime,
    String? supportPhone,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'maintenance',
      barrierColor: Colors.black.withOpacity(0.55),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => MaintenanceDialog(
        onRetry: onRetry,
        estimatedTime: estimatedTime,
        supportPhone: supportPhone,
      ),
      transitionBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );
  }

  @override
  State<MaintenanceDialog> createState() => _MaintenanceDialogState();
}

class _MaintenanceDialogState extends State<MaintenanceDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    try {
      await launchUrl(uri);
    } catch (_) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: MaintenanceDialog.primary.withOpacity(0.25),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Header(pulse: _pulse),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'التطبيق تحت الصيانة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF12313A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'نقوم حالياً بتحسين تطبيق طلعات لنقدّم لك تجربة أفضل. نعتذر عن أي إزعاج وسنعود قريباً.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              height: 1.7,
                              color: Colors.blueGrey.shade600,
                            ),
                          ),
                          if (widget.estimatedTime != null) ...[
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: MaintenanceDialog.primarySoft,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.schedule_rounded,
                                    size: 20,
                                    color: MaintenanceDialog.primaryDark,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'الوقت المتوقع: ',
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      color: MaintenanceDialog.primaryDark,
                                    ),
                                  ),
                                  Text(
                                    widget.estimatedTime!,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: MaintenanceDialog.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (widget.onRetry != null) ...[
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: widget.onRetry,
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text(
                                  'تحديث الحالة',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MaintenanceDialog.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (widget.supportPhone != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              'للمساعدة تواصل معنا',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.5,
                                color: Colors.blueGrey.shade400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextButton.icon(
                              onPressed: () => _call(widget.supportPhone!),
                              icon: const Icon(Icons.phone_rounded, size: 18),
                              label: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  widget.supportPhone!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: MaintenanceDialog.primaryDark,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.pulse});

  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MaintenanceDialog.primary, MaintenanceDialog.primaryDark],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: -40, right: -30, child: _circle(130, 0.10)),
          Positioned(bottom: -50, left: -30, child: _circle(150, 0.08)),
          AnimatedBuilder(
            animation: pulse,
            builder: (_, __) {
              final t = pulse.value;
              final t2 = (t + 0.5) % 1;
              return Stack(
                alignment: Alignment.center,
                children: [
                  _ring(96 + 60 * t, (1 - t) * 0.35),
                  _ring(96 + 60 * t2, (1 - t2) * 0.35),
                ],
              );
            },
          ),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.build_circle_rounded,
              size: 58,
              color: MaintenanceDialog.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(opacity),
    ),
  );

  Widget _ring(double size, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.white.withOpacity(opacity.clamp(0.0, 1.0)),
        width: 2,
      ),
    ),
  );
}
