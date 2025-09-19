import 'package:family_tree/adminpanel/member/cubit/visibilityCubit/visibility_cubit.dart';
import 'package:family_tree/adminpanel/member/cubit/visibilityCubit/visibility_state.dart';
import 'package:family_tree/adminpanel/member/model/visibility_model.dart';
import 'package:family_tree/adminpanel/utils/age_calculate.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberDetailScreen extends StatefulWidget {
  final String name;
  final String location;
  final String phoneNumber;
  final String bloodGroup;
  final bool isAlive;
  final String dob;
  final String email;
  final String gender;

  const MemberDetailScreen({
    super.key,
    required this.name,
    required this.location,
    required this.phoneNumber,
    required this.bloodGroup,
    required this.isAlive,
    required this.dob,
    required this.email,
    required this.gender,
  });

  // Color scheme
  static const Color orangePrimary = Color(0xFFFFA726);
  static const Color orangeLight = Color(0xFFFFB74D);
  static const Color orangeAccent = Color(0xFFFF9800);
  static const Color amber = Color(0xFFFFC107);
  static const Color deepOrange = Color(0xFFFF5722);
  static const Color warmGray = Color(0xFFF5F5F5);

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  @override
  void initState() {
    super.initState();

    // fetch from Firestore
    context.read<VisibilityCubit>().fetchVisibility();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisibilityCubit, VisibilityState>(
      builder: (context, visibilityState) {
        final visibility = visibilityState.visibility;
        return Scaffold(
          backgroundColor: MemberDetailScreen.warmGray,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: MemberDetailScreen.orangePrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              AppLocalizations.of(context)!.memberDetails,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header Card
                _buildProfileHeader(context),
                const SizedBox(height: 20),

                // Contact Information
                _buildSectionTitle(
                  AppLocalizations.of(context)!.contactInformation,
                ),
                const SizedBox(height: 12),
                _buildContactInfo(context, visibility),
                const SizedBox(height: 24),

                // Personal Information
                _buildSectionTitle(
                  AppLocalizations.of(context)!.personalInformation,
                ),
                const SizedBox(height: 12),
                _buildPersonalInfo(context),
                const SizedBox(height: 24),

                // Medical Information
                _buildSectionTitle(
                  AppLocalizations.of(context)!.medicalInformation,
                ),
                const SizedBox(height: 12),
                _buildMedicalInfo(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MemberDetailScreen.orangePrimary,
            MemberDetailScreen.orangeLight,
            MemberDetailScreen.amber,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: MemberDetailScreen.orangePrimary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Image with Status
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 30,

                    backgroundImage: AssetImage(
                      widget.gender == 'male'
                          ? 'assets/images/male.png'
                          : 'assets/images/female.png',
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name and Relationship
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),

            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isAlive
                    ? Colors.green
                    : const Color(0xFF424242), // Dark gray for deceased
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isAlive ? Colors.green : Colors.grey.shade600,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.isAlive
                        ? Icons.health_and_safety
                        : Icons.sentiment_very_dissatisfied,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.isAlive
                        ? AppLocalizations.of(context)!.living
                        : AppLocalizations.of(context)!.passedAway,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, VisibilityModel? visibility) {
    return Column(
      children: [
        if (visibility?.showContact == true) ...[
          _buildInfoCard(
            icon: Icons.phone,
            label: AppLocalizations.of(context)!.phone,
            value: widget.phoneNumber,
            iconColor: MemberDetailScreen.orangePrimary,
          ),
        ],

        const SizedBox(height: 12),
        if (visibility?.showEmail == true) ...[
          _buildInfoCard(
            icon: Icons.email,
            label: AppLocalizations.of(context)!.email,
            value: widget.email,
            iconColor: MemberDetailScreen.orangeAccent,
          ),
        ],

        const SizedBox(height: 12),
        if (visibility?.showLocation == true) ...[
          _buildInfoCard(
            icon: Icons.location_on,
            label: AppLocalizations.of(context)!.location,
            value: widget.location,
            iconColor: MemberDetailScreen.deepOrange,
          ),
        ],
      ],
    );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.cake,
                label: AppLocalizations.of(context)!.age,
                value: widget.dob.isEmpty
                    ? '\n'
                    : '${calculateAgeFromString(widget.dob)} ${AppLocalizations.of(context)!.years}\n',
                iconColor: MemberDetailScreen.orangePrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.calendar_today,
                label: AppLocalizations.of(context)!.birthDate,
                value: '${widget.dob}\n',
                iconColor: MemberDetailScreen.orangeAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // _buildInfoCard(
        //   icon: Icons.work,
        //   label: 'Occupation',
        //   value: 'Software Engineer',
        //   iconColor: amber,
        // ),
      ],
    );
  }

  Widget _buildMedicalInfo(BuildContext context) {
    return Column(
      children: [
        _buildInfoCard(
          icon: Icons.bloodtype,
          label: AppLocalizations.of(context)!.bloodGroup,
          value: widget.bloodGroup,
          iconColor: MemberDetailScreen.deepOrange,
        ),
        const SizedBox(height: 12),
        // _buildInfoCard(
        //   icon: Icons.favorite,
        //   label: 'Health Status',
        //   value: 'Healthy',
        //   iconColor: Colors.green,
        // ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
