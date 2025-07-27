import 'package:family_tree/adminpanel/auth/cubit/auth_cubit.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TempIdScreen extends StatefulWidget {
  const TempIdScreen({super.key});

  @override
  State<TempIdScreen> createState() => _TempIdScreenState();
}

class _TempIdScreenState extends State<TempIdScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Handle success/failure messages here if needed
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            // title: const Text('Create Temporary ID'),
            // centerTitle: true,
            // elevation: 2,
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.temporaryAccess,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.enterEmailAndPassword,
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      /// Email
                      Text(AppLocalizations.of(context)!.email),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.enterEmail,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.emailValidation;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      /// Password
                      Text(AppLocalizations.of(context)!.password),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.enterPassword,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return AppLocalizations.of(
                              context,
                            )!.passwordValidation;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      ElevatedButton.icon(
                        icon: const Icon(Icons.person_add_alt),
                        label: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            AppLocalizations.of(context)!.temporaryUser,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<AuthCubit>(context).createTemp(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
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
