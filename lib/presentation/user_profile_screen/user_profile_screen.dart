import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/profile_edit_modal_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _biometricEnabled = true;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _twoFactorEnabled = false;

  final List<Map<String, dynamic>> _userData = [
    {
      "id": 1,
      "name": "John Smith",
      "email": "john.smith@email.com",
      "phone": "+1 (555) 123-4567",
      "avatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "currency": "USD",
      "language": "English",
      "joinDate": "January 2023"
    }
  ];

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Change Profile Photo',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            _buildImageOption('Take Photo', 'camera_alt', () {
              Navigator.pop(context);
              _showSuccessToast('Camera opened');
            }),
            _buildImageOption('Choose from Library', 'photo_library', () {
              Navigator.pop(context);
              _showSuccessToast('Gallery opened');
            }),
            _buildImageOption('Remove Photo', 'delete', () {
              Navigator.pop(context);
              _showSuccessToast('Profile photo removed');
            }),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void _showEditProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ProfileEditModalWidget(
        userData: _userData.first,
        onSave: (name, email) {
          setState(() {
            (_userData.first)['name'] = name;
            (_userData.first)['email'] = email;
          });
          _showSuccessToast('Profile updated successfully');
        },
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to logout? You will need to sign in again.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/splash-screen');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Account',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.error,
          ),
        ),
        content: Text(
          'This action cannot be undone. All your data will be permanently deleted.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessToast('Account deletion initiated');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSuccessToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  Future<void> _refreshProfile() async {
    await Future.delayed(Duration(seconds: 1));
    _showSuccessToast('Profile data refreshed');
  }

  @override
  Widget build(BuildContext context) {
    final user = _userData.first;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showEditProfileModal,
            icon: CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),

              // Profile Header
              ProfileHeaderWidget(
                userData: user,
                onAvatarTap: _showImagePickerOptions,
                onEditTap: _showEditProfileModal,
              ),

              SizedBox(height: 4.h),

              // Account Information Section
              SettingsSectionWidget(
                title: 'Account Information',
                items: [
                  {
                    'icon': 'person',
                    'title': 'Full Name',
                    'subtitle': user['name'],
                    'onTap': _showEditProfileModal,
                  },
                  {
                    'icon': 'email',
                    'title': 'Email Address',
                    'subtitle': user['email'],
                    'onTap': _showEditProfileModal,
                  },
                  {
                    'icon': 'phone',
                    'title': 'Phone Number',
                    'subtitle': user['phone'],
                    'onTap': () =>
                        _showSuccessToast('Phone number settings opened'),
                  },
                ],
              ),

              SizedBox(height: 3.h),

              // Security Settings Section
              SettingsSectionWidget(
                title: 'Security Settings',
                items: [
                  {
                    'icon': 'fingerprint',
                    'title': 'Biometric Login',
                    'subtitle': _biometricEnabled ? 'Enabled' : 'Disabled',
                    'hasSwitch': true,
                    'switchValue': _biometricEnabled,
                    'onSwitchChanged': (value) {
                      setState(() {
                        _biometricEnabled = value;
                      });
                      _showSuccessToast(
                          'Biometric login ${value ? 'enabled' : 'disabled'}');
                    },
                  },
                  {
                    'icon': 'lock',
                    'title': 'Change PIN',
                    'subtitle': 'Update your security PIN',
                    'onTap': () =>
                        _showSuccessToast('PIN change screen opened'),
                  },
                  {
                    'icon': 'security',
                    'title': 'Two-Factor Authentication',
                    'subtitle': _twoFactorEnabled ? 'Enabled' : 'Disabled',
                    'hasSwitch': true,
                    'switchValue': _twoFactorEnabled,
                    'onSwitchChanged': (value) {
                      setState(() {
                        _twoFactorEnabled = value;
                      });
                      _showSuccessToast(
                          'Two-factor authentication ${value ? 'enabled' : 'disabled'}');
                    },
                  },
                ],
              ),

              SizedBox(height: 3.h),

              // App Preferences Section
              SettingsSectionWidget(
                title: 'App Preferences',
                items: [
                  {
                    'icon': 'notifications',
                    'title': 'Notifications',
                    'subtitle': _notificationsEnabled ? 'Enabled' : 'Disabled',
                    'hasSwitch': true,
                    'switchValue': _notificationsEnabled,
                    'onSwitchChanged': (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      _showSuccessToast(
                          'Notifications ${value ? 'enabled' : 'disabled'}');
                    },
                  },
                  {
                    'icon': 'attach_money',
                    'title': 'Currency',
                    'subtitle': user['currency'],
                    'onTap': () =>
                        _showSuccessToast('Currency settings opened'),
                  },
                  {
                    'icon': 'language',
                    'title': 'Language',
                    'subtitle': user['language'],
                    'onTap': () =>
                        _showSuccessToast('Language settings opened'),
                  },
                  {
                    'icon': 'dark_mode',
                    'title': 'Dark Mode',
                    'subtitle': _darkModeEnabled ? 'Enabled' : 'Disabled',
                    'hasSwitch': true,
                    'switchValue': _darkModeEnabled,
                    'onSwitchChanged': (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                      _showSuccessToast(
                          'Dark mode ${value ? 'enabled' : 'disabled'}');
                    },
                  },
                ],
              ),

              SizedBox(height: 4.h),

              // Logout Button
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                child: ElevatedButton(
                  onPressed: _showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Delete Account Button
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                child: OutlinedButton(
                  onPressed: _showDeleteAccountDialog,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.error,
                      width: 1.5,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Delete Account',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              // Legal Links Section
              SettingsSectionWidget(
                title: 'Legal & Support',
                items: [
                  {
                    'icon': 'description',
                    'title': 'Terms of Service',
                    'subtitle': 'Read our terms and conditions',
                    'onTap': () => _showSuccessToast('Terms of Service opened'),
                  },
                  {
                    'icon': 'privacy_tip',
                    'title': 'Privacy Policy',
                    'subtitle': 'Learn about data protection',
                    'onTap': () => _showSuccessToast('Privacy Policy opened'),
                  },
                  {
                    'icon': 'help',
                    'title': 'Support',
                    'subtitle': 'Get help and contact us',
                    'onTap': () => _showSuccessToast('Support center opened'),
                  },
                ],
              ),

              SizedBox(height: 3.h),

              // Version Information
              Center(
                child: Column(
                  children: [
                    Text(
                      'Budget Tracker',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Version 1.0.0',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Member since ${user['joinDate']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
