import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for Clipboard
import 'package:url_launcher/url_launcher.dart';
import 'navigation_bar.dart'; 
import 'projects.dart'; 
import 'contact_me.dart';

const _primaryOrange = Color(0xFFFF7A2F);
const _darkBlue = Color(0xFF121528);

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

// --- UPDATED UTILITY FUNCTIONS ---

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  // [FIX] externalApplication ensures it opens in a new tab/app correctly
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint('Could not launch $url');
  }
}

// [FIX] Now accepts context for Clipboard fallback
Future<void> _launchEmail(BuildContext context) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'rjestuesta@gmail.com',
    query: 'subject=Inquiry from Portfolio',
  );

  try {
    if (!await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch';
    }
  } catch (e) {
    // Fallback: Copy to clipboard
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

// --- MAIN STATE ---

class _LandingPageState extends State<LandingPage> {
  // 1. Create Keys for scrolling
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _certificationsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey(); 
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // 3. Scroll Logic
  void _scrollToSection(int index) {
    final keys = [_homeKey, _certificationsKey, _skillsKey, _projectsKey, _contactKey];
    if (index >= 0 && index < keys.length) {
      final key = keys[index];
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // NAVIGATION BAR
                      AppNavBar(onNavClick: _scrollToSection),
                      
                      // HERO SECTION (Pass _showCVDialog)
                      Container(key: _homeKey, child: const _HeroSection()),
                      
                      const SizedBox(height: 60),
                      const _ClientLogosRow(),
                      
                      const SizedBox(height: 60),
                      // CERTIFICATIONS
                      Container(
                        key: _certificationsKey, 
                        child: _CertificationsSection(
                          onViewAll: () => _scrollToSection(1), 
                        )
                      ),
                      
                      const SizedBox(height: 60),
                      // ACADEMIC / ACHIEVEMENTS
                      const _ClientsSection(), 
                      
                      const SizedBox(height: 60),
                      // TECH STACK
                      Container(
                         key: _skillsKey, 
                         child: _StatsSection(
                           onSeeProjects: () => _scrollToSection(3),
                         )
                      ), 
                      
                      const SizedBox(height: 60),
                      // PROJECTS
                      Container(key: _projectsKey, child: const _RecentProjectsSection()),
                      
                      const SizedBox(height: 60),
                      // CTA / CONTACT
                      Container(key: _contactKey, child: const _CtaSection()),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
//                                SECTIONS
// ============================================================================

//
// HERO SECTION
//
class _HeroSection extends StatelessWidget {
  const _HeroSection(); // No parameters needed now

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return SizedBox(
      height: isMobile ? null : size.height * 0.63, 
      width: double.infinity,
      child: Stack(
        children: [
          // BACKGROUND LAYERS
          Positioned.fill(child: Container(color: const Color(0xFFFFF8F5))),
          Positioned(
            top: -100, right: -100,
            child: Container(
              width: 500, height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [const Color(0xFFFFD0A8).withOpacity(0.6), const Color(0xFFFFF8F5).withOpacity(0)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0, right: 0,
            child: Container(
              width: 600, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment.bottomRight,
                  radius: 1.2,
                  colors: [const Color(0xFFE0C3FC).withOpacity(0.4), const Color(0xFFFFF8F5).withOpacity(0)],
                ),
              ),
            ),
          ),
          
          // CONTENT LAYER
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.only(top: isMobile ? 40 : 50, left: 20, right: 20),
                  child: isMobile 
                    // removed arguments here
                    ? Column(children: const [_HeroTextContent(), SizedBox(height: 40), _HeroImageContent()])
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                           Expanded(flex: 5, child: _HeroTextContent()), // removed arguments here
                           Expanded(flex: 6, child: _HeroImageContent()),
                        ],
                      ),
                ),
              ),
            ),
          ),

          // BOTTOM FADE
          Positioned(
            bottom: 0, left: 0, right: 0, height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFFFFF8F5).withOpacity(0), Colors.white],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroTextContent extends StatelessWidget {
  const _HeroTextContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hey! I Am', style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800, color: _darkBlue)),
          Text('Rainzle John\nEstuesta', style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w900, color: _darkBlue, height: 1.1, fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            'Senior BS Computer Science student at MSEUF with a passion for crafting '
            'innovative software solutions. Skilled in Python, Flutter, and Machine Learning.', 
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600], height: 1.6, fontSize: 16),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => showContactDialog(context), 
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE85D04),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 8,
                  shadowColor: const Color(0xFFE85D04).withOpacity(0.5),
                ),
                child: const Text("Hire Me", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 24),
               TextButton.icon(
                 // CHANGED: Opens the PDF file directly
                 onPressed: () => _launchURL('assets/CV_Estuesta.pdf'), 
                 icon: const Icon(Icons.description, color: Color(0xFFE85D04)), // Changed icon to document/description
                 label: const Text("View CV", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600))
               )
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroImageContent extends StatelessWidget {
  const _HeroImageContent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550, 
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0, right: 40, left: 40, top: 0,
            child: Image.asset(
              'assets/my_photo.png', 
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            top: 60, right: 0,
            child: _FloatingBadge(
              icon: Icons.emoji_events, iconColor: Colors.amber,
              title: 'BPI DataWave\n3rd Place Winner', delay: 0,
            ),
          ),
          Positioned(
            bottom: 100, left: 0,
            child: _FloatingBadge(
              icon: Icons.emoji_events, iconColor: Colors.blue,
              title: 'InnOlympics 2025\nTop 5 Finalist', delay: 500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final int delay;

  const _FloatingBadge({required this.icon, required this.iconColor, required this.title, this.delay = 0});

  @override
  State<_FloatingBadge> createState() => _FloatingBadgeState();
}

class _FloatingBadgeState extends State<_FloatingBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(offset: Offset(0, 8 * (0.5 - _controller.value)), child: child),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 12))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: widget.iconColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(widget.icon, color: widget.iconColor, size: 28),
            ),
            const SizedBox(width: 12),
            Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w700, color: _darkBlue, height: 1.2)),
          ],
        ),
      ),
    );
  }
}

class _ClientLogosRow extends StatelessWidget {
  const _ClientLogosRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Connect With Me', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[800])),
        const SizedBox(height: 16),
        Wrap(
          spacing: 32, runSpacing: 16, alignment: WrapAlignment.center,
          children: const [
            _SocialIcon(assetPath: 'assets/linkedin.png', label: 'LinkedIn', url: 'https://www.linkedin.com/in/rainzle-john-estuesta-94b326262/'),
            _SocialIcon(assetPath: 'assets/github.png', label: 'GitHub', url: 'https://github.com/rainzleestuesta'),
            _SocialIcon(assetPath: 'assets/facebook.png', label: 'Facebook', url: 'https://www.facebook.com/rainzleestuesta/'),
            _SocialIcon(assetPath: 'assets/instagram.png', label: 'Instagram', url: 'https://www.instagram.com/rainasianboy__/'),
            _SocialIcon(assetPath: 'assets/huggingface.png', label: 'HuggingFace', url: 'https://huggingface.co/tomatosauce-hg'),
          ],
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final String assetPath;
  final String label;
  final String url;

  const _SocialIcon({required this.assetPath, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 22, backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(assetPath, fit: BoxFit.contain, width: 28, height: 28, errorBuilder: (context, error, stack) => const Icon(Icons.link, size: 20)),
              ),
            ),
            const SizedBox(height: 6),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _CertificationsSection extends StatelessWidget {
  final VoidCallback? onViewAll;
  const _CertificationsSection({this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    if (isMobile) {
      return Column(children: [const _CertificationsList(), const SizedBox(height: 32), _CertificationsDescription(onViewAll: onViewAll)]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: const _CertificationsList()),
        const SizedBox(width: 40),
        Expanded(child: _CertificationsDescription(onViewAll: onViewAll)),
      ],
    );
  }
}

class _CertificationsDescription extends StatelessWidget {
  final VoidCallback? onViewAll;
  const _CertificationsDescription({this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Workshops Attended', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: _darkBlue)),
        const SizedBox(height: 12),
        Text(
          'Technology moves fast, and I make sure to keep up. Beyond my university coursework, I actively participate in workshops ranging from Generative AI to Blockchain development.',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            side: const BorderSide(color: _primaryOrange),
            foregroundColor: _darkBlue,
          ),
          onPressed: onViewAll ?? () {}, 
          child: const Text('View All Credentials'),
        ),
      ],
    );
  }
}

class _CertificationsList extends StatelessWidget {
  const _CertificationsList();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: const [
          _CertificateTile(title: 'PJDSC 2025 Hybrid Workshop', organization: 'UP Data Science Society', icon: Icons.analytics, assetPath: 'assets/certs/pjdsc_2025.png'),
          SizedBox(height: 12),
          _CertificateTile(title: 'Startup Primer & Ideation', organization: 'Enverga Innovation Challenge', icon: Icons.lightbulb, assetPath: 'assets/certs/innovation_challenge.png'),
          SizedBox(height: 12),
          _CertificateTile(title: 'Rev Up: Startup Roadshow', organization: 'UPLB ICONS & MSEUF', icon: Icons.rocket_launch, assetPath: 'assets/certs/rev_up_2025.png'),
          SizedBox(height: 12),
          _CertificateTile(title: 'Tech Nexus 2024', organization: 'Campus DEVCON', icon: Icons.hub, assetPath: 'assets/certs/tech_nexus_2024.png'),
        ],
      ),
    );
  }
}

class _CertificateTile extends StatefulWidget {
  final String title;
  final String organization;
  final IconData icon;
  final String assetPath;
  final bool isHighlighted;

  const _CertificateTile({super.key, required this.title, required this.organization, required this.icon, required this.assetPath, this.isHighlighted = false});

  @override
  State<_CertificateTile> createState() => _CertificateTileState();
}

class _CertificateTileState extends State<_CertificateTile> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = _isHovering ? const Color(0xFFFFEFE4) : (widget.isHighlighted ? const Color(0xFFFFF7F1) : Colors.white);
    final borderColor = _isHovering ? const Color(0xFFFF7A2F) : (widget.isHighlighted ? const Color(0xFFFF7A2F).withOpacity(0.3) : Colors.grey.withOpacity(0.15));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(16),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(widget.assetPath, fit: BoxFit.contain, errorBuilder: (ctx, _, __) => Container(padding: const EdgeInsets.all(40), color: Colors.white, child: const Icon(Icons.broken_image))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(backgroundColor: Colors.black54, radius: 18, child: IconButton(icon: const Icon(Icons.close, size: 20, color: Colors.white), onPressed: () => Navigator.of(context).pop())),
                  ),
                ],
              ),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor, width: _isHovering ? 1.5 : 1.0)),
          child: Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Icon(widget.icon, color: const Color(0xFFFF7A2F), size: 24)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700), maxLines: 2), Text(widget.organization, style: theme.textTheme.bodySmall)])),
              Icon(Icons.visibility_outlined, color: _isHovering ? const Color(0xFFFF7A2F) : Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  const _ImageCarousel();
  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final List<String> _images = ['assets/awards/photo1.png', 'assets/awards/photo2.png', 'assets/awards/photo3.png', 'assets/awards/photo4.png'];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    final next = (_currentPage + 1) % _images.length;
    _controller.animateToPage(next, duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _images.length,
              onPageChanged: (idx) => setState(() => _currentPage = idx),
              itemBuilder: (context, index) {
                return Image.asset(_images[index], fit: BoxFit.cover, width: double.infinity, height: double.infinity, errorBuilder: (ctx, _, __) => const Center(child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50)));
              },
            ),
            Positioned(
              bottom: 0, left: 0, right: 0, height: 80,
              child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.6)]))),
            ),
            Positioned(
              bottom: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_images.length, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300), margin: const EdgeInsets.symmetric(horizontal: 4), height: 8, width: isActive ? 24 : 8,
                    decoration: BoxDecoration(color: isActive ? const Color(0xFFFF7A2F) : Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(4)),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientsSection extends StatelessWidget {
  const _ClientsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 900;
    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Academic Excellence\n& Recognition', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: _darkBlue)),
        const SizedBox(height: 12),
        Text('As a Computer Science student at MSEUF, I consistently challenge myself beyond the classroom.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
        const SizedBox(height: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          _BulletText(text: '3rd Place: BPI DataWave 2024 (ML Track)'),
          _BulletText(text: 'Top 5 Finalist: InnOlympics 2025'),
          _BulletText(text: 'Consistent Dean\'s Lister & Academic Scholar'),
        ])
      ],
    );
    if (isMobile) return Column(children: [textColumn, const SizedBox(height: 32), const _ImageCarousel()]);
    return Row(children: [Expanded(child: textColumn), const SizedBox(width: 40), const Expanded(child: _ImageCarousel())]);
  }
}

class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [const Icon(Icons.check_circle, size: 18, color: _primaryOrange), const SizedBox(width: 8), Text(text, style: Theme.of(context).textTheme.bodyMedium)]),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final VoidCallback? onSeeProjects;
  const _StatsSection({this.onSeeProjects});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final theme = Theme.of(context);

    final techCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(colors: [Color(0xFF121528), Color(0xFF232946)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: const Color(0xFF121528).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Technical Proficiency', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),
          const _SkillGroup(icon: Icons.code, category: "Languages", skills: "Python • Dart • Java • C++"),
          const Divider(color: Colors.white12, height: 32),
          const _SkillGroup(icon: Icons.psychology, category: "AI & Data Science", skills: "TensorFlow • Pandas • Scikit-Learn • HuggingFace"),
          const Divider(color: Colors.white12, height: 32),
          const _SkillGroup(icon: Icons.layers, category: "App Dev & Tools", skills: "Flutter • Firebase • Git • MySQL"),
        ],
      ),
    );

    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tools & Technologies', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: _darkBlue)),
        const SizedBox(height: 12),
        Text('A robust arsenal for building intelligent applications.', style: theme.textTheme.titleMedium?.copyWith(color: _primaryOrange, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        Text('My workflow bridges the gap between raw data and end-user experience. I use Python and TensorFlow to build predictive models, and then bring them to life with Flutter.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700], height: 1.6)),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: _primaryOrange, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          onPressed: onSeeProjects ?? () {},
          icon: const Icon(Icons.work_outline, color: Colors.white),
          label: const Text("See Them in Action", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );

    if (isMobile) return Column(children: [techCard, const SizedBox(height: 32), textColumn]);
    return Row(children: [Expanded(flex: 5, child: techCard), const SizedBox(width: 50), Expanded(flex: 6, child: textColumn)]);
  }
}

class _SkillGroup extends StatelessWidget {
  final IconData icon;
  final String category;
  final String skills;
  const _SkillGroup({required this.icon, required this.category, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: _primaryOrange, size: 24)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 6),
          Text(skills, style: TextStyle(color: Colors.white.withOpacity(0.6), height: 1.4, fontSize: 14)),
        ])),
      ],
    );
  }
}

class _RecentProjectsSection extends StatelessWidget {
  const _RecentProjectsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Featured Projects', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: _darkBlue)),
        const SizedBox(height: 24),
        if (isMobile)
          Column(children: myProjects.map((p) => Padding(padding: const EdgeInsets.only(bottom: 20), child: _ProjectCard(project: p))).toList())
        else
          SizedBox(
            height: 400,
            child: ListView.separated(
              scrollDirection: Axis.horizontal, itemCount: myProjects.length,
              separatorBuilder: (_, __) => const SizedBox(width: 24),
              itemBuilder: (context, index) => SizedBox(width: 350, child: _ProjectCard(project: myProjects[index])),
            ),
          ),
      ],
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Project project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovering = false;

  void _showProjectDetails(BuildContext context) {
    showDialog(context: context, barrierColor: Colors.black87, builder: (context) => _ProjectDetailDialog(project: widget.project));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showProjectDetails(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..translate(0.0, _isHovering ? -10.0 : 0.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF3B46F1), Color(0xFF6A2AE0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(30),
            boxShadow: _isHovering ? [BoxShadow(color: const Color(0xFF3B46F1).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 15))] : [],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(widget.project.bannerImage, fit: BoxFit.cover, errorBuilder: (ctx, _, __) => Center(child: Icon(Icons.broken_image, color: Colors.white.withOpacity(0.5), size: 40))),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(widget.project.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(widget.project.shortDescription, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                const Text("View Case Study →", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectDetailDialog extends StatelessWidget {
  final Project project;
  const _ProjectDetailDialog({required this.project});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    return Dialog(
      backgroundColor: Colors.transparent, insetPadding: EdgeInsets.all(isMobile ? 16 : 40),
      child: Container(
        width: 1000, constraints: BoxConstraints(maxHeight: size.height * 0.9),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(project.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: _darkBlue)),
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
              ]),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    height: 300, width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        project.bannerImage, 
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, _, __) => const Center(
                          child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.broken_image, size: 40, color: Colors.grey), SizedBox(height: 8), Text("Banner not found", style: TextStyle(color: Colors.grey))]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(spacing: 8, runSpacing: 8, children: project.tools.map((tool) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFFF7A2F).withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFF7A2F).withOpacity(0.3))),
                    child: Text(tool, style: const TextStyle(color: Color(0xFFE85D04), fontWeight: FontWeight.w600, fontSize: 12)),
                  )).toList()),
                  const SizedBox(height: 32),
                  if (!isMobile)
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: _buildLeftColumn(context)), const SizedBox(width: 40), Expanded(flex: 2, child: _buildRightColumn(context))])
                  else
                    Column(children: [_buildLeftColumn(context), const SizedBox(height: 32), _buildRightColumn(context)]),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: "Overview & Problem"),
        Text("${project.fullOverview}\n\n${project.problem}", style: const TextStyle(color: Colors.black87, height: 1.6)),
        const SizedBox(height: 32),
        const _SectionTitle(title: "System Architecture & Methods"),
        Text(project.architectureText, style: const TextStyle(color: Colors.black87, height: 1.6)),
        const SizedBox(height: 24),
        Container(
          width: double.infinity, constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(project.architectureImage, fit: BoxFit.contain, errorBuilder: (ctx, _, __) => const Padding(padding: EdgeInsets.all(20), child: Text("Diagram not found. Check assets/projects/ path."))),
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF121528), borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.person, color: Color(0xFFFF7A2F)), SizedBox(width: 10), Text("My Role", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))]),
          const SizedBox(height: 12),
          Text(project.myRole, style: TextStyle(color: Colors.white.withOpacity(0.9), height: 1.5)),
        ]),
      ),
      const SizedBox(height: 32),
      const _SectionTitle(title: "Key Features"),
      ...project.features.map((f) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.check_circle, color: Color(0xFFFF7A2F), size: 18), const SizedBox(width: 8),
        Expanded(child: Text(f, style: const TextStyle(fontWeight: FontWeight.w500))),
      ]))),
    ]);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w800,
        color: _darkBlue,
      ),
    );
  }
}

class _CtaSection extends StatelessWidget {
  const _CtaSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 800;

    final left = Text('Ready To Get\nStarted?', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: _darkBlue));
    final right = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('You know about me, let\'s talk about you.', style: theme.textTheme.bodyMedium),
      const SizedBox(height: 12),
      FilledButton(
        style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF7A2F), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        // [FIXED] Pass context
        onPressed: () => showContactDialog(context), 
        child: const Text('Shoot Message'),
      ),
    ]);

    if (isMobile) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [left, const SizedBox(height: 24), right]);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: left), Expanded(child: right)]);
  }
}