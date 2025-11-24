import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(width: 290, child: AboutSidebar()),
                      SizedBox(width: 24),
                      Expanded(child: MainContent()),
                    ],
                  );
                } else {
                  return const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AboutSidebar(),
                        SizedBox(height: 24),
                        MainContent(),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// ========== LEFT SIDEBAR ==========

class AboutSidebar extends StatelessWidget {
  const AboutSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const accentBlue = Color(0xFF0F6ACF);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "ABOUT ME" with blue vertical indicator
            Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: accentBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ABOUT ME',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Avatar + name
            Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFFE4EBF9),
                  child: Icon(
                    Icons.person,
                    size: 44,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '[Your Name Here]',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Aspiring Data Scientist | ML Engineer',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const _SectionTitle('Skills'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                SkillChip(label: 'Python'),
                SkillChip(label: 'SQL'),
                SkillChip(label: 'Machine Learning'),
                SkillChip(label: 'Problem Solving'),
                SkillChip(label: 'Communication'),
              ],
            ),
            const SizedBox(height: 22),

            const _SectionTitle('Tools & Tech'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: const [
                ToolLabel('Tableau'),
                ToolLabel('TensorFlow'),
                ToolLabel('pandas'),
              ],
            ),
            const SizedBox(height: 24),

            const _SectionTitle('Contact Info'),
            const SizedBox(height: 10),
            Row(
              children: const [
                ContactIcon(
                  icon: Icons.business_center_outlined,
                  tooltip: 'LinkedIn',
                ),
                SizedBox(width: 10),
                ContactIcon(
                  icon: Icons.code,
                  tooltip: 'GitHub',
                ),
                SizedBox(width: 10),
                ContactIcon(
                  icon: Icons.email_outlined,
                  tooltip: 'Email',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        color: Colors.grey[600],
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;
  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade300),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

class ToolLabel extends StatelessWidget {
  final String text;
  const ToolLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: Colors.grey[800],
          ),
    );
  }
}

class ContactIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  const ContactIcon({super.key, required this.icon, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    const accentBlue = Color(0xFF0F6ACF);
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFE4EBF9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: accentBlue,
        ),
      ),
    );
  }
}

/// ========== MAIN CONTENT (RIGHT SIDE) ==========

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const accentBlue = Color(0xFF0F6ACF);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            children: const [
                              TextSpan(text: 'WELCOME TO MY '),
                              TextSpan(
                                text: 'DATA INSIGHT HUB.',
                                style: TextStyle(
                                  color: accentBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right side: simple "..." menu mimic
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.5),
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'PROJECT SHOWCASE',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),

          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount;

              if (constraints.maxWidth >= 1050) {
                crossAxisCount = 3; // desktop: 3 cards in a row
              } else if (constraints.maxWidth >= 700) {
                crossAxisCount = 2; // tablet: 2 in a row
              } else {
                crossAxisCount = 1; // mobile: stacked
              }

              return GridView.count(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.6, // tweak this if you want them taller/shorter
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ProjectCard(
                    title: 'Project 1: Churn Prediction',
                    description: 'Problem solved & key features summary...',
                    chartType: ProjectChartType.bar,
                  ),
                  ProjectCard(
                    title: 'Project 2: Churn Prediction',
                    description: 'Problem solved & key features summary...',
                    chartType: ProjectChartType.horizontalBar,
                  ),
                  ProjectCard(
                    title: 'Project 3: Scatter Prediction',
                    description: 'Problem solved & key features summary...',
                    chartType: ProjectChartType.scatter,
                  ),
                  ProjectCard(
                    title: 'Project 4: Scatter Prediction',
                    description: 'Problem solved & key features summary...',
                    chartType: ProjectChartType.scatter,
                  ),
                ],
              );
            },
          ),
const SizedBox(height: 28),
        ],
      ),
    );
  }
}

/// ========== PROJECT CARD ==========

enum ProjectChartType { bar, horizontalBar, scatter }

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final ProjectChartType chartType;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const accentBlue = Color(0xFF0F6ACF);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(child: _buildChartIcon(chartType)),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: accentBlue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // TODO: navigate to details
                },
                child: const Text(
                  'View Analysis',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartIcon(ProjectChartType type) {
    switch (type) {
      case ProjectChartType.bar:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            _Bar(height: 18),
            SizedBox(width: 4),
            _Bar(height: 28),
            SizedBox(width: 4),
            _Bar(height: 38),
            SizedBox(width: 4),
            _Bar(height: 26),
          ],
        );
      case ProjectChartType.horizontalBar:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _HBar(width: 60),
            SizedBox(height: 4),
            _HBar(width: 90),
            SizedBox(height: 4),
            _HBar(width: 45),
          ],
        );
      case ProjectChartType.scatter:
        return SizedBox(
          width: 80,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: const [
              _Dot(offset: Offset(-18, 4)),
              _Dot(offset: Offset(-4, -6)),
              _Dot(offset: Offset(8, 0)),
              _Dot(offset: Offset(18, -10)),
            ],
          ),
        );
    }
  }
}

class _Bar extends StatelessWidget {
  final double height;
  const _Bar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF0F6ACF),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _HBar extends StatelessWidget {
  final double width;
  const _HBar({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF0F6ACF),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Offset offset;
  const _Dot({required this.offset});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFF0F6ACF),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
