import 'package:flutter/material.dart';
import '../auth/login_screen.dart'; // pastikan path ini sesuai dengan struktur folder project kamu
import 'profile_screen.dart';
import 'security_screen.dart';
import 'notification_screen.dart';
import 'language_screen.dart';
import 'help_screen.dart';
import 'privacy_policy_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FC),
      appBar: AppBar(
        title: const Text('Pengaturan Akun'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileCard(),
          const SizedBox(height: 24),
          _buildSectionTitle('Akun'),
          _buildSettingTile(Icons.person, 'Profil', 'Lihat dan ubah informasi pribadi', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
          }),
          _buildSettingTile(Icons.lock, 'Keamanan', 'Kelola kata sandi dan keamanan', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityScreen()));
          }),
          _buildSettingTile(Icons.notifications, 'Notifikasi', 'Atur notifikasi yang kamu terima', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
          }),
          _buildSettingTile(Icons.language, 'Bahasa', 'Pilih bahasa aplikasi', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageScreen()));
          }),
          const SizedBox(height: 24),
          _buildSectionTitle('Lainnya'),
          _buildSettingTile(Icons.help_outline, 'Bantuan', 'Butuh bantuan atau pertanyaan?', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()));
          }),
          _buildSettingTile(Icons.privacy_tip_outlined, 'Kebijakan Privasi', 'Pelajari bagaimana data kamu digunakan', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
          }),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildSettingTile(Icons.logout, 'Keluar', 'Keluar dari akun TrackIT', () {
            _showLogoutConfirmation(context);
          }, color: Colors.redAccent, iconBgColor: Colors.red.shade50),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: const CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hilman Syachr',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '41523010199@mercubuana.ac.id',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String subtitle, VoidCallback onTap,
      {Color? color, Color? iconBgColor}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBgColor ?? const Color(0xFFE3F2FD),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color ?? const Color(0xFF1E88E5), size: 22),
        ),
        title: Text(title, style: TextStyle(color: color ?? Colors.black87)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Ya, Keluar'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
