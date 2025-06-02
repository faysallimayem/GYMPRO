import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';
import '../widgets/membership_screen_wrapper.dart';
import '../services/coach_service.dart';
import '../models/coach_model.dart';
import '../chat_screen/chat_screen.dart';

class CoachProfileScreen extends StatefulWidget {
  final int coachId;
  final int gymId;
  
  const CoachProfileScreen({
    super.key,
    required this.coachId,
    required this.gymId,
  });

  @override
  State<CoachProfileScreen> createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends State<CoachProfileScreen> {
  bool isLoading = true;
  String? error;
  Coach? coach;

  @override
  void initState() {
    super.initState();
    _loadCoachData();
  }

  Future<void> _loadCoachData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final coachService = CoachService();
      final coaches = await coachService.getCoachesByGymId(widget.gymId);
      Coach? coachData;
      try {
        coachData = coaches.firstWhere((c) => c.id == widget.coachId);
      } catch (_) {
        coachData = null;
      }
      if (coachData == null) {
        setState(() {
          error = 'Coach not found in this gym.';
          isLoading = false;
        });
      } else {
        setState(() {
          coach = coachData;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to load coach information: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MembershipScreenWrapper(
      featureName: "Coaches",
      showBlurredPreview: true,
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: AppBar(
          title: Text("Coach Profile"),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: coach != null ? FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  coach: coach!,
                ),
              ),
            );
          },
          backgroundColor: theme.colorScheme.primary,
          child: Icon(Icons.chat, color: Colors.white),
        ) : null,
        body: SafeArea(
          child: SizedBox(
            width: double.maxFinite,
            child: isLoading 
              ? Center(child: CircularProgressIndicator())
              : error != null
                ? _buildErrorWidget()
                : coach != null
                  ? _buildCoachProfile()
                  : Center(child: Text("No coach information available")),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48.h),
          SizedBox(height: 16.h),
          Text(
            error ?? "An error occurred",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _loadCoachData,
            child: Text("Try Again"),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildUserCameraStack(context),
          Padding(
            padding: EdgeInsets.all(16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coach?.fullName ?? "Coach",
                  style: theme.textTheme.headlineLarge,
                ),
                SizedBox(height: 32.h),
                Text(
                  "Personal Information",
                  style: CustomTextStyles.headlineSmallWorkSansSemiBold,
                ),
                SizedBox(height: 12.h),
                _buildInfoCard(
                  title: "Email",
                  value: coach?.email ?? "Not available",
                ),
                if (coach?.specialization != null) ...[
                  SizedBox(height: 12.h),
                  _buildInfoCard(
                    title: "Specialization",
                    value: coach!.specialization!,
                  ),
                ],
                if (coach?.experience != null) ...[
                  SizedBox(height: 12.h),
                  _buildInfoCard(
                    title: "Experience",
                    value: "${coach!.experience} years",
                  ),
                ],
                if (coach?.bio != null) ...[
                  SizedBox(height: 24.h),
                  Text(
                    "Bio",
                    style: CustomTextStyles.headlineSmallWorkSansSemiBold,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(16.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: Text(coach!.bio!),
                  ),
                ],
                if (coach?.certifications != null && coach!.certifications!.isNotEmpty) ...[
                  SizedBox(height: 24.h),
                  Text(
                    "Certifications",
                    style: CustomTextStyles.headlineSmallWorkSansSemiBold,
                  ),
                  SizedBox(height: 8.h),
                  ...coach!.certifications!.map((cert) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: theme.colorScheme.primary),
                        SizedBox(width: 8.h),
                        Expanded(child: Text(cert)),
                      ],
                    ),
                  )).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String value}) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.h),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  /// Section widgets
  Widget _buildUserCameraStack(BuildContext context) {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
      ),
      child: coach?.photoUrl != null && coach!.photoUrl!.isNotEmpty
        ? Image.network(
            coach!.photoUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
          )
        : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100.h,
            width: 100.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                coach != null
                  ? coach!.firstName.isNotEmpty && coach!.lastName.isNotEmpty
                    ? "${coach!.firstName[0]}${coach!.lastName[0]}"
                    : "C"
                  : "C",
                style: TextStyle(
                  fontSize: 40.h,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
