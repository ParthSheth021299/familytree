// import 'dart:ui';
// import 'package:family_tree/adminpanel/dashboard/presentation/screens/admin_home_screen.dart';
// import 'package:family_tree/adminpanel/guestuserdashboard/presentation/screens/guest_user_dash_board.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeIn;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );
//     _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _controller.forward();

//     checkLoginStatus();
//   }

//   Future<void> checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isAdminLoggedIn = prefs.getBool('isAdminLoggedIn') ?? false;
//     await Future.delayed(const Duration(seconds: 3));
//     if (!mounted) return;
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (_) => isAdminLoggedIn
//             ? const AdminHomeScreen()
//             : const GuestUserDashBoard(),
//       ),
//       (route) => false,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Orange Gradient Background
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFFFA726), Color(0xFFF57C00)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),

//           // Wave Shape
//           // Positioned(
//           //   bottom: 0,
//           //   left: 0,
//           //   right: 0,
//           //   child: ClipPath(
//           //     clipper: BottomWaveClipper(),
//           //     child: Container(
//           //       height: 120,
//           //       color: Colors.white.withOpacity(0.15),
//           //     ),
//           //   ),
//           // ),

//           // Content with Fade-in animation
//           Center(
//             child: FadeTransition(
//               opacity: _fadeIn,
//               child: GlassmorphicPanel(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 4),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.white.withOpacity(0.3),
//                             blurRadius: 20,
//                             spreadRadius: 4,
//                           ),
//                         ],
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(100),
//                         child: Image.asset(
//                           'assets/images/namaste.jpg',
//                           width: 140,
//                           height: 140,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     const Text(
//                       "Jai Hatkesh",
//                       style: TextStyle(
//                         fontSize: 44,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         // letterSpacing: 1.2,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Your family, organized.",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.white70,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//                     // const CircularProgressIndicator(
//                     //   color: Colors.white,
//                     //   strokeWidth: 3,
//                     // ),
//                     // SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Wave Clipper
// class BottomWaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0, 0);
//     path.lineTo(0, size.height * 0.6);
//     path.quadraticBezierTo(
//       size.width * 0.25,
//       size.height,
//       size.width * 0.5,
//       size.height * 0.8,
//     );
//     path.quadraticBezierTo(
//       size.width * 0.75,
//       size.height * 0.6,
//       size.width,
//       size.height * 0.8,
//     );
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }

// // Glassmorphism Container
// class GlassmorphicPanel extends StatelessWidget {
//   final Widget child;
//   const GlassmorphicPanel({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 32),
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.3)),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//           child: child,
//         ),
//       ),
//     );
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:family_tree/adminpanel/dashboard/presentation/screens/admin_home_screen.dart';
import 'package:family_tree/adminpanel/guestuserdashboard/presentation/screens/guest_user_dash_board.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isAdminLoggedIn = prefs.getBool('isAdminLoggedIn') ?? false;
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => isAdminLoggedIn
            ? const AdminHomeScreen()
            : const GuestUserDashBoard(),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFA726),
                  Color(0xFFF57C00),
                  Color(0xFFFF7043),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Content with Fade-in animation
          Center(
            child: FadeTransition(
              opacity: _fadeIn,
              child: GlassmorphicPanel(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo with glowing effect
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.orangeAccent, Colors.deepOrange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.6),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/namaste.jpg',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // App title
                    Text(
                      "Jai Hatkesh",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Tagline
                    Text(
                      "Your family, beautifully organized",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Loader
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Glassmorphism Container
class GlassmorphicPanel extends StatelessWidget {
  final Widget child;
  const GlassmorphicPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: child,
        ),
      ),
    );
  }
}
