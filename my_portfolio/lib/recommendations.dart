// --- DATA MODEL ---

class Recommendation {
  final String name;
  final String role;
  final String text;

  const Recommendation({
    required this.name,
    required this.role,
    required this.text,
  });
}

// SAMPLE DATA - Replace with real ones later!
final List<Recommendation> testimonials = [
  const Recommendation(
    name: "Placeholder 1",
    role: "Sample Role 1",
    text: "Placeholder testimonial text 1",
  ),
  const Recommendation(
    name: "Placeholder 2",
    role: "Sample Role 2",
    text: "Placeholder testimonial text 2",
  ),
  const Recommendation(
    name: "Placeholder 3",
    role: "Sample Role 3",
    text: "Placeholder testimonial text 3",
  ),
];