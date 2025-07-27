// import 'package:family_tree/adminpanel/dashboard/presentation/screens/admin_home_screen.dart';
// import 'package:family_tree/adminpanel/auth/cubit/auth_cubit.dart';
// import 'package:family_tree/adminpanel/guestuserdashboard/presentation/screens/guest_user_dash_board.dart';
// import 'package:family_tree/adminpanel/member/presentation/screens/add_family_chain.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController emailController = TextEditingController();
//     final TextEditingController passwordController = TextEditingController();
//     return BlocConsumer<AuthCubit, AuthState>(
//       listener: (context, state) {
//         final user = FirebaseAuth.instance.currentUser?.email.toString();
//         if (state is AuthSucess) {
//           if (user == 'admin@gmail.com') {
//             Navigator.of(
//               context,
//             ).push(MaterialPageRoute(builder: (context) => AdminHomeScreen()));
//           } else {
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (context) => AddFamilyChainScreen()),
//             );
//           }
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           body: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text('Login'),
//               SizedBox(height: 50),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                 child: TextFormField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     label: Text('Enter Email'),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 50),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                 child: TextFormField(
//                   controller: passwordController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     label: Text('Enter Password'),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 50),
//               ElevatedButton(
//                 onPressed: () {
//                   BlocProvider.of<AuthCubit>(
//                     context,
//                   ).login(emailController.text, passwordController.text);
//                 },
//                 child: Text('Login'),
//               ),
//               SizedBox(height: 20),
//               Divider(),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Countinue as '),
//                   InkWell(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => GuestUserDashBoard(),
//                         ),
//                       );
//                     },
//                     child: Text('Guest User'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
// import 'package:family_tree/adminpanel/dashboard/presentation/screens/admin_home_screen.dart';
// import 'package:family_tree/adminpanel/auth/cubit/auth_cubit.dart';
// import 'package:family_tree/adminpanel/guestuserdashboard/presentation/screens/guest_user_dash_board.dart';
// import 'package:family_tree/adminpanel/member/presentation/screens/add_family_chain.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();

//     return BlocConsumer<AuthCubit, AuthState>(
//       listener: (context, state) {
//         final user = FirebaseAuth.instance.currentUser?.email.toString();
//         if (state is AuthSucess) {
//           if (user == 'admin@gmail.com') {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
//             );
//           } else {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const AddFamilyChainScreen()),
//             );
//           }
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: Colors.orange.shade50,
//           body: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 420),
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 8,
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'Login',
//                           style: Theme.of(context).textTheme.headlineSmall
//                               ?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.deepOrange,
//                               ),
//                         ),
//                         const SizedBox(height: 32),

//                         // Email Field
//                         TextFormField(
//                           controller: emailController,
//                           decoration: InputDecoration(
//                             labelText: 'Email',
//                             prefixIcon: const Icon(
//                               Icons.email_outlined,
//                               color: Colors.deepOrange,
//                             ),
//                             filled: true,
//                             fillColor: Colors.orange.shade50,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),

//                         // Password Field
//                         TextFormField(
//                           controller: passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             prefixIcon: const Icon(
//                               Icons.lock_outline,
//                               color: Colors.deepOrange,
//                             ),
//                             filled: true,
//                             fillColor: Colors.orange.shade50,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 30),

//                         // Login Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 48,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               BlocProvider.of<AuthCubit>(context).login(
//                                 emailController.text.trim(),
//                                 passwordController.text.trim(),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.deepOrange,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: const Text(
//                               'Login',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 30),

//                         // Divider
//                         Row(
//                           children: [
//                             const Expanded(child: Divider(thickness: 1)),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                               ),
//                               child: Text(
//                                 'OR',
//                                 style: TextStyle(color: Colors.grey.shade600),
//                               ),
//                             ),
//                             const Expanded(child: Divider(thickness: 1)),
//                           ],
//                         ),
//                         const SizedBox(height: 16),

//                         // Continue as Guest
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     const GuestUserDashBoard(),
//                               ),
//                             );
//                           },
//                           child: const Text(
//                             'Continue as Guest',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 15,
//                               decoration: TextDecoration.underline,
//                               color: Colors.deepOrange,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:family_tree/adminpanel/dashboard/presentation/screens/admin_home_screen.dart';
import 'package:family_tree/adminpanel/auth/cubit/auth_cubit.dart';
import 'package:family_tree/adminpanel/guestuserdashboard/presentation/screens/guest_user_dash_board.dart';
import 'package:family_tree/adminpanel/member/presentation/screens/add_family_chain.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/admob/v1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        final user = FirebaseAuth.instance.currentUser?.email.toString();
        if (state is AuthSucess) {
          if (user == 'admin@gmail.com') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AddFamilyChainScreen()),
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.orange.shade50,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 10,
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.login,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                        ),
                        const SizedBox(height: 32),

                        // Email Field
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.enterEmail,
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.deepOrange,
                            ),
                            filled: true,
                            fillColor: Colors.orange.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password Field with Show/Hide Toggle
                        TextFormField(
                          controller: passwordController,
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.password,
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.deepOrange,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.orange.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<AuthCubit>(context).login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.login,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Divider
                        Row(
                          children: [
                            const Expanded(child: Divider(thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.or,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                            const Expanded(child: Divider(thickness: 1)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Continue as Guest
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const GuestUserDashBoard(),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.continueAsGuest,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              // decoration: TextDecoration.underline,
                              color: Colors.deepOrange,
                            ),
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
      },
    );
  }
}
