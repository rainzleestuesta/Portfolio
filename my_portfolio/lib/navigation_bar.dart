import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AppNavBar extends StatelessWidget {
  final Function(int index) onNavClick;

  const AppNavBar({super.key, required this.onNavClick});

  // UPDATED: Smart Email Launcher
  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'rjestuesta@gmail.com',
      query: 'subject=Inquiry from Portfolio',
    );

    try {
      // Try to launch the email app
      if (!await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch';
      }
    } catch (e) {
      // FALLBACK: Copy to clipboard if no email client is found
      await Clipboard.setData(const ClipboardData(text: 'rjestuesta@gmail.com'));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email client not found. Address copied to clipboard!'),
            backgroundColor: Color(0xFFE85D04),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      color: Colors.transparent, 
      child: Row(
        children: [
          Text(
            'Rainzle.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: const Color(0xFF121528),
            ),
          ),
          const Spacer(),
          if (!isMobile) ...[
            _NavItem(label: 'Home', onTap: () => onNavClick(0)),
            _NavItem(label: 'Certifications', onTap: () => onNavClick(1)),
            _NavItem(label: 'Skills', onTap: () => onNavClick(2)),
            _NavItem(label: 'Projects', onTap: () => onNavClick(3)),
            const SizedBox(width: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE85D04),
                foregroundColor: Colors.white,
                elevation: 10,
                shadowColor: const Color(0xFFE85D04).withOpacity(0.4),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              // PASS CONTEXT HERE
              onPressed: () => _launchEmail(context), 
              child: const Text(
                "Contact Me",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ] else
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, color: Color(0xFF121528)),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: InkWell(
        onTap: onTap,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4E69),
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}