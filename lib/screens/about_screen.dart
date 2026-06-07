import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ℹ️ About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Developer Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: AppTheme.primary,
                      // Replace 'assets/images/profile.jpg' with your actual photo
                      backgroundImage: const AssetImage('assets/images/profile.jpg'),
                      onBackgroundImageError: (_, _e) {},
                     //child: const Icon(Icons.person, size: 52, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      
                      'Mohammed Haydar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _infoChip(Icons.badge, 'Student ID: QIU23-0421'),
                    const SizedBox(height: 4),
                    _infoChip(Icons.school, 'Course: Mobile Technology ICT602'),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text(
                      '© 2026 Mohammed Haydar Othman. All rights reserved.',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _launchUrl('https://github.com/YOUR_GITHUB_USERNAME/electricity_bill_estimator'),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.link, color: AppTheme.accent),
                          SizedBox(width: 6),
                          Text(
                            'View App on GitHub',
                            style: TextStyle(
                              color: AppTheme.accent,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Description Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚡ About This App',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'E-Bill Estimator helps you calculate your monthly electricity charges based on TNB\'s tiered block pricing. '
                      'You can track multiple months, apply rebates, save records locally, and manage your billing history.',
                      style: TextStyle(color: AppTheme.textMuted, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // How to Use Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📖 How to Use',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _step('1', 'Select your billing month from the dropdown on the Home screen.'),
                    _step('2', 'Enter the number of electricity units used (1 – 1000 kWh).'),
                    _step('3', 'Drag the slider to set your rebate percentage (0% – 5%).'),
                    _step('4', 'Tap "Calculate" to see your total charges and final cost after rebate.'),
                    _step('5', 'Tap "Save to Database" to store the record.'),
                    _step('6', 'Tap the list icon (top right) to view all saved records.'),
                    _step('7', 'Tap any record to view details, edit, or delete it.'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            // Pricing Reference Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💡 Pricing Blocks (sen/kWh)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _priceRow('1 – 200 kWh', '21.8 sen'),
                    _priceRow('201 – 300 kWh', '33.4 sen'),
                    _priceRow('301 – 600 kWh', '51.6 sen'),
                    _priceRow('601 – 1000 kWh', '54.6 sen'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: AppTheme.accent),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
      ],
    );
  }

  Widget _step(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppTheme.primary,
            child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 11)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: AppTheme.textMuted, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String block, String rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(block, style: const TextStyle(color: AppTheme.textMuted)),
          Text(rate, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primary)),
        ],
      ),
    );
  }
}