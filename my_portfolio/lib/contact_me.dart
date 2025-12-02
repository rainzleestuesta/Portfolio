import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:url_launcher/url_launcher.dart';

void showContactDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Get in Touch",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF121528),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "I'm always open to discussing new projects, creative ideas or opportunities to be part of your visions.",
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 24),
            
            // OPTION 1: COPY EMAIL (The most reliable)
            _ContactOption(
              icon: Icons.copy,
              color: const Color(0xFF121528),
              title: "Copy Email",
              subtitle: "rjestuesta@gmail.com",
              onTap: () async {
                await Clipboard.setData(const ClipboardData(text: 'rjestuesta@gmail.com'));
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email copied to clipboard!'),
                      backgroundColor: Color(0xFFE85D04),
                    ),
                  );
                }
              },
            ),
            
            const SizedBox(height: 12),

            // OPTION 2: OPEN GMAIL (Great for web users)
            _ContactOption(
              icon: Icons.mail_outline,
              color: const Color(0xFFE85D04),
              title: "Compose in Gmail",
              subtitle: "Open directly in browser",
              onTap: () async {
                // This URL forces Gmail web interface to open a compose window
                final Uri gmailUrl = Uri.parse(
                  'https://mail.google.com/mail/?view=cm&fs=1&to=rjestuesta@gmail.com&su=Inquiry from Portfolio'
                );
                if (!await launchUrl(gmailUrl, mode: LaunchMode.externalApplication)) {
                  debugPrint('Could not launch Gmail');
                }
              },
            ),

            const SizedBox(height: 12),

            // OPTION 3: DEFAULT MAIL APP
            _ContactOption(
              icon: Icons.email,
              color: Colors.blueAccent,
              title: "Default Mail App",
              subtitle: "Open system email client",
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'rjestuesta@gmail.com',
                  query: 'subject=Inquiry from Portfolio',
                );
                if (!await launchUrl(emailLaunchUri)) {
                  debugPrint('Could not launch mailto');
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}

// Helper Widget for the options
class _ContactOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactOption({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}