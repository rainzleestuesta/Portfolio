import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for Clipboard
import 'package:url_launcher/url_launcher.dart';
import 'navigation_bar.dart'; 
import 'projects.dart'; 
import 'contact_me.dart';
import 'recommendations.dart';

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

// --- MAIN STATE ---

class _LandingPageState extends State<LandingPage> {
  // 1. Create Keys for scrolling
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey(); 
  final GlobalKey _contactKey = GlobalKey();

  // 3. Scroll Logic
  void _scrollToSection(int index) {
    // Keys mapping: 0=Home, 1=Services, 2=Experience, 3=Projects, 4=Skills
    final keys = [_homeKey, _servicesKey, _experienceKey, _projectsKey, _skillsKey];
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
                      // SERVICES
                      Container(key: _servicesKey, child: const _ServicesSection()),
                      
                      const SizedBox(height: 60),
                      // EXPERIENCE
                      Container(key: _experienceKey, child: const _ExperienceSection()),
                      
                      const SizedBox(height: 60),
                      // PROJECTS
                      Container(key: _projectsKey, child: const _RecentProjectsSection()),

                      const SizedBox(height: 60),
                      // TECH STACK
                      Container(
                         key: _skillsKey, 
                         child: _StatsSection(
                           onSeeProjects: () => _scrollToSection(3), // Index 3 is Projects
                         )
                      ), 
                      
                      const SizedBox(height: 60),
                      // ACADEMIC / ACHIEVEMENTS
                      const _ClientsSection(), 
                      
                      const SizedBox(height: 60),
                      // RECOMMENDATIONS
                      const _RecommendationsSection(),

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
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return SizedBox(
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
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.only(top: isMobile ? 40 : 50, left: 20, right: 20),
                child: isMobile
                    ? Column(children: const [_HeroTextContent(), SizedBox(height: 40), _HeroImageContent()])
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center, // Align center to handle larger image
                        children: const [
                          Expanded(flex: 5, child: _HeroTextContent()),
                          Expanded(flex: 6, child: _HeroImageContent()),
                        ],
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
      padding: const EdgeInsets.only(top: 10.0), // Reduced top padding slightly to fit badge
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // (Open for Internship Banner Removed)
          
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
                 onPressed: () => _launchURL('assets/CV_Estuesta_v2.pdf'),
                 icon: const Icon(Icons.description, color: Color(0xFFE85D04)),
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
      // Reduced height to fit CTA directly below
      height: 500, 
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // LAYER 1: The Image
          Positioned(
            bottom: 20, right: 0, left: 0, top: 0,
            child: Image.asset(
              'assets/my_photo_v3.png',
              fit: BoxFit.contain, // Changed from cover to contain to respect width
              alignment: Alignment.bottomCenter,
            ),
          ),

          // LAYER 2: The Gradient Fade (Must match background color 0xFFFFF8F5)
          Positioned(
            bottom: 0, left: 0, right: 0, 
            height: 150, // Taller height = smoother fade
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFFFF8F5).withOpacity(0), // Transparent at top
                    const Color(0xFFFFF8F5), // Solid Cream at bottom (Matches Background)
                  ],
                  stops: const [0.0, 0.8], // Push the solid color down a bit
                ),
              ),
            ),
          ),

          // LAYER 3: The Badges (Now they sit ON TOP of the fade)
          Positioned(
            top: 100, left: 50,
            child: _FloatingBadge(
              icon: Icons.emoji_events, iconColor: Colors.amber,
              title: 'BPI DataWave\n3rd Place', delay: 0,
            ),
          ),
          Positioned(
            bottom: 80, left: 0,
            child: _FloatingBadge(
              icon: Icons.emoji_events, iconColor: Colors.blue,
              title: 'InnOlympics 25\nTop 5 Finalist', delay: 500,
            ),
          ),
          Positioned(
            bottom: 170, right: 0,
            child: _FloatingBadge(
              icon: Icons.emoji_events, iconColor: Colors.red,
              title: 'Context Engineer\nat Open iT, Asia Inc.', delay: 0,
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
        constraints: const BoxConstraints(maxWidth: 220), // ADDED CONSTRAINT FOR OVERFLOW
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              child: Icon(widget.icon, color: widget.iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Flexible(child: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w700, color: _darkBlue, height: 1.2, fontSize: 13))),
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

// Removed Certifications section

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
    final textColumn = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFF7A2F).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A2F).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFFFF7A2F), size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Academic Excellence\n& Recognition', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: _darkBlue, height: 1.2)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('As a Computer Science student at MSEUF, I consistently challenge myself beyond the classroom.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
          const SizedBox(height: 24),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            _BulletText(text: 'Current GWA: 1.28'),
            _BulletText(text: '3rd Place: BPI DataWave 2024 (ML Track)'),
            _BulletText(text: 'Top 5 Finalist: InnOlympics 2025'),
            _BulletText(text: 'Consistent Dean\'s Lister & Academic Scholar'),
          ])
        ],
      ),
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
          const _SkillGroup(icon: Icons.auto_awesome, category: "Workflow & Automation", skills: "Context Engineering • n8n • AI Automation"),
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

//
// EXPERIENCE SECTION
//
class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience', 
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900, 
            color: Colors.black, // Matching the sleek black requested
            letterSpacing: -0.5,
          )
        ),
        const SizedBox(height: 40),
        const _ExperienceTimeline(),
      ],
    );
  }
}

class _ExperienceTimeline extends StatelessWidget {
  const _ExperienceTimeline();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> experiences = [
      {
        "title": "Context Engineer Intern",
        "company": "Open iT, Asia Inc.",
        "year": "2026",
        "isCurrent": true,
      },
      {
        "title": "BS Computer Science",
        "company": "Manuel S. Enverga University Foundation",
        "year": "2026",
        "isCurrent": false,
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        children: List.generate(experiences.length, (index) {
          final exp = experiences[index];
          final isLast = index == experiences.length - 1;
          return _ExperienceItem(
            title: exp["title"],
            company: exp["company"],
            year: exp["year"],
            isCurrent: exp["isCurrent"] as bool,
            isLast: isLast,
          );
        }),
      ),
    );
  }
}

class _ExperienceItem extends StatelessWidget {
  final String title;
  final String company;
  final String year;
  final bool isCurrent;
  final bool isLast;

  const _ExperienceItem({
    required this.title,
    required this.company,
    required this.year,
    required this.isCurrent,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Indicator Column
          SizedBox(
            width: 30, // Fixed width for vertical alignment
            child: Column(
              children: [
                // The Square Indicator
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: isCurrent ? Colors.black : Colors.white,
                    border: Border.all(
                      color: isCurrent ? Colors.black : Colors.grey.shade300, 
                      width: 2
                    ),
                  ),
                ),
                // The Connecting Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: Colors.grey.shade300,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  )
                else
                  const SizedBox(height: 24), // give some bottom padding to the very last item naturally
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Content Column
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title, 
                          style: const TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.w800, 
                            color: Colors.black,
                            letterSpacing: -0.3,
                          )
                        ),
                        const SizedBox(height: 6),
                        Text(
                          company, 
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w400,
                          )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Year Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA), // Very light grey bg similar to photo
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      year,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// SERVICES SECTION
//
class _ServicesSection extends StatelessWidget {
  const _ServicesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 900;
    
    final services = [
      {
        "title": "End-to-End Workflow Automation",
        "desc": "Streamline your operations by integrating your disparate systems. Using advanced platforms like n8n, I architect workflows that connect your core infrastructure (CRMs, Postgres databases, email) with AI agents to handle lead routing, invoice processing, and automated follow-ups.",
        "icon": Icons.account_tree,
      },
      {
        "title": "Context Engineering & RAG Pipelines",
        "desc": "Unlock the value of your unstructured data. I develop secure Retrieval-Augmented Generation (RAG) pipelines using Python that integrate your proprietary documents into a centralized, queryable AI knowledge base for your employees.",
        "icon": Icons.schema,
      },
      {
        "title": "Machine Learning Data Pipelines",
        "desc": "Leverage your historical data for strategic foresight. I build and deploy end-to-end predictive models designed to optimize your operations, from forecasting inventory demands to identifying churn risks.",
        "icon": Icons.analytics,
      },
      {
        "title": "Custom Cross-Platform Interfaces",
        "desc": "Bridge the gap between complex backend AI and user experience. I build bespoke, intuitive internal applications using Flutter and Dart, providing your team with a custom-tailored environment to interact with your data.",
        "icon": Icons.devices,
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Work with me", 
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900, 
                color: _darkBlue,
                fontSize: 48,
                letterSpacing: -1,
              )
            ),
            if (!isMobile) ...[
              const SizedBox(width: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Text(
                    "Services tailored for modern operations", 
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500)
                  ),
                ),
              )
            ]
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 8),
          Text(
            "Services tailored for modern operations", 
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500)
          ),
        ],
        const SizedBox(height: 48),
        
        // Grid / List
        if (isMobile)
          Column(
            children: services.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: _ServiceCard(
                title: s["title"] as String,
                desc: s["desc"] as String,
                icon: s["icon"] as IconData,
              ),
            )).toList(),
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _ServiceCard(
                      title: services[0]["title"] as String,
                      desc: services[0]["desc"] as String,
                      icon: services[0]["icon"] as IconData,
                    ),
                    const SizedBox(height: 32),
                    _ServiceCard(
                      title: services[2]["title"] as String,
                      desc: services[2]["desc"] as String,
                      icon: services[2]["icon"] as IconData,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  children: [
                    _ServiceCard(
                      title: services[1]["title"] as String,
                      desc: services[1]["desc"] as String,
                      icon: services[1]["icon"] as IconData,
                    ),
                    const SizedBox(height: 32),
                    _ServiceCard(
                      title: services[3]["title"] as String,
                      desc: services[3]["desc"] as String,
                      icon: services[3]["icon"] as IconData,
                    ),
                  ],
                ),
              )
            ],
          )
      ],
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final String title;
  final String desc;
  final IconData icon;

  const _ServiceCard({
    required this.title,
    required this.desc,
    required this.icon,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered ? _primaryOrange.withValues(alpha: 0.5) : Colors.grey.shade200,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered 
                  ? _primaryOrange.withValues(alpha: 0.15) 
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: _isHovered ? 32 : 16,
              offset: Offset(0, _isHovered ? 12 : 8),
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: _primaryOrange, size: 28),
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _darkBlue,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.desc,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.6,
              ),
            )
          ],
        ),
      ),
    );
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
            // [CHANGE] Dark Blue Gradient
            gradient: const LinearGradient(
              colors: [
                Color(0xFF121528), // Your brand Dark Blue
                Color(0xFF232946)  // Slightly lighter navy
              ], 
              begin: Alignment.topLeft, 
              end: Alignment.bottomRight
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: _isHovering 
                ? [BoxShadow(color: const Color(0xFF121528).withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 15))] 
                : [],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(widget.project.bannerImage, fit: BoxFit.cover, errorBuilder: (ctx, _, __) => Center(child: Icon(Icons.broken_image, color: Colors.white.withValues(alpha: 0.5), size: 40))),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(widget.project.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(widget.project.shortDescription, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("View Case Study →", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    if (widget.project.projectLink != null && widget.project.projectLink!.isNotEmpty)
                      GestureDetector(
                        onTap: () => _launchURL(widget.project.projectLink!),
                        child: const Icon(Icons.open_in_new, color: Colors.white, size: 18),
                      ),
                  ],
                ),
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
                    decoration: BoxDecoration(color: const Color(0xFFFF7A2F).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFF7A2F).withValues(alpha: 0.3))),
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
          Text(project.myRole, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), height: 1.5)),
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

//
// RECOMMENDATIONS SECTION
//
class _RecommendationsSection extends StatelessWidget {
  const _RecommendationsSection();

  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => const _SubmitRecommendationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Testimonials', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: _darkBlue)),
                const SizedBox(height: 12),
                Text('Kind words from people I\'ve worked with.', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
              ],
            ),
            if (!isMobile)
              OutlinedButton.icon(
                onPressed: () => _showSubmitDialog(context),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text("Write a Recommendation"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryOrange,
                  side: const BorderSide(color: _primaryOrange),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 32),

        // Content
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: testimonials.length,
            separatorBuilder: (_, __) => const SizedBox(width: 24),
            itemBuilder: (context, index) => _TestimonialCard(data: testimonials[index]),
          ),
        ),

        // Mobile Button (shown below list instead of header)
        if (isMobile) ...[
          const SizedBox(height: 32),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => _showSubmitDialog(context),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text("Write a Recommendation"),
              style: OutlinedButton.styleFrom(
                foregroundColor: _primaryOrange,
                side: const BorderSide(color: _primaryOrange),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final Recommendation data;
  const _TestimonialCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote Icon
          const Icon(Icons.format_quote_rounded, color: Color(0xFFFFD0A8), size: 40),
          const SizedBox(height: 12),
          // Text
          Expanded(
            child: Text(
              '"${data.text}"',
              style: const TextStyle(color: Color(0xFF4A4A4A), height: 1.5, fontStyle: FontStyle.italic),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Author Info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: _darkBlue,
                child: Text(data.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name, style: const TextStyle(fontWeight: FontWeight.bold, color: _darkBlue, fontSize: 14)),
                    Text(data.role, style: TextStyle(color: Colors.grey[600], fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// DIALOG TO SUBMIT RECOMMENDATION
class _SubmitRecommendationDialog extends StatefulWidget {
  const _SubmitRecommendationDialog();

  @override
  State<_SubmitRecommendationDialog> createState() => _SubmitRecommendationDialogState();
}

class _SubmitRecommendationDialogState extends State<_SubmitRecommendationDialog> {
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _submit() async {
    final String name = _nameController.text;
    final String role = _roleController.text;
    final String message = _messageController.text;
    
    final String body = "Name: $name\nRole: $role\n\nReview:\n$message";
    final String encodedBody = Uri.encodeComponent(body);
    
    final String gmailUrl = "https://mail.google.com/mail/?view=cm&fs=1&to=rjestuesta@gmail.com&su=Portfolio%20Testimonial&body=$encodedBody";
    
    try {
      await _launchURL(gmailUrl);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      // Fallback: Copy to clipboard
      await Clipboard.setData(const ClipboardData(text: 'rjestuesta@gmail.com'));
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email client not found. Address copied to clipboard!"),
            backgroundColor: Color(0xFFE85D04),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Write a Recommendation", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _darkBlue)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 24),
            _buildTextField("Name", _nameController),
            const SizedBox(height: 16),
            _buildTextField("Role (e.g., Senior Data Analyst)", _roleController),
            const SizedBox(height: 16),
            _buildTextField("Message", _messageController, maxLines: 4),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Submit via Email", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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