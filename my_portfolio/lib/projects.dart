class Project {
  final String title;
  final String shortDescription;
  final String fullOverview;
  final String problem;
  final List<String> features;
  final String architectureText;
  final List<String> tools;
  final String myRole;
  final String bannerImage; 
  final String architectureImage;
  final String? projectLink; // Clickable link to project

  Project({
    required this.title,
    required this.shortDescription,
    required this.fullOverview,
    required this.problem,
    required this.features,
    required this.architectureText,
    required this.tools,
    required this.myRole,
    required this.bannerImage,
    required this.architectureImage,
    this.projectLink,
  });
}

// THE DATA (Ensure these filenames match exactly what is in your assets folder!)
final List<Project> myProjects = [
  // 1. PROJECT SBAFN (Existing)
  Project(
    title: "Project SBAFN",
    shortDescription: "Street-based Assessment for Flood-prone Neighborhoods",
    bannerImage: "assets/projects/sbafn_map.png", 
    architectureImage: "assets/projects/sbafn_diagram.png", 
    projectLink: "https://project-sbafn.vercel.app/", 
    fullOverview: "Project SBAFN is an explainable, street-level flood-proneness visualization "
        "and decision-support app for Philippine cities. It visually communicates per-street, "
        "evidence-backed flood insights that planners can act on.",
    problem: "Existing solutions like Project NOAH provide area-based hazard overviews but lack "
        "street-level granularity. Planners needed a way to understand the 'why' behind floods "
        "at a specific street level for effective decision-making.",
    features: [
      "Street-Level Granularity (Green/Yellow/Red scoring)",
      "Explainability (Physical & Topographic indicators)",
      "Scenario Stress-Testing (30/50/100 mm/hr rainfall)",
      "Actionable Insights for LGU planning"
    ],
    architectureText: "The system employs a Hybrid Geo Implementation using YOLOv11 for street-view "
        "object detection (330k+ images) and LightGBM for flood-proneness scoring (Positive-Unlabeled learning). "
        "It integrates raster and vector geodata for a complete risk profile.",
    tools: ["Flutter", "Python", "LightGBM", "YOLOv11", "MapTiler", "Git"],
    myRole: "I was responsible for the Data & Frontend integration. Specifically, I collected the "
        "elevation dataset (DEM), integrated this data into the backend pipeline, helped develop "
        "the frontend UI/UX in Flutter, and applied the model's calculated scores to the visual map interface.",
  ),

  // 2. TAGLISH SENTIMENT ANALYSIS
  Project(
    title: "Taglish Sentiment Analysis",
    shortDescription: "Transformer-based models for Psychological Profiling",
    bannerImage: "assets/projects/sam_banner.png", 
    architectureImage: "assets/projects/sam_diagram.png", 
    projectLink: "https://huggingface.co/tomatosauce-hg/sentiment-analysis-for-psychological-profiling", // Add your project link here
    fullOverview: "Developed the Sentiment Analysis Model (SAM) component for a clinician-assistive "
        "diagnostic support system. This module processes Taglish (Tagalog-English) intake answers "
        "to provide automated affective cues (POS/NEG/NEU) that guide downstream diagnosis.",
    problem: "Clinical intake data is highly sensitive and strictly regulated, making it impossible "
        "to train models on real patient notes. Furthermore, standard NLP models struggle with the "
        "nuances of code-switched Taglish in a clinical context.",
    features: [
      "Synthetic Taglish Sentiment Corpus Generation",
      "Question-Aware Input Processing",
      "Class-Weighted Loss for Imbalanced Data",
      "High Accuracy (0.82 Macro-F1) on Intake Data"
    ],
    architectureText: "The pipeline begins with a Synthetic Taglish Corpus generated from "
        "Psychological Profiler questionnaires. I fine-tuned and benchmarked three transformer architectures: "
        "mBERT, TaglishBERT, and XLM-RoBERTa. The final system uses XLM-R with a custom WeightedTrainer "
        "to handle class imbalance, achieving superior performance on code-switched text.",
    tools: ["Python", "PyTorch", "HuggingFace", "XLM-RoBERTa", "Pandas", "Scikit-learn"],
    myRole: "I led the NLP pipeline development. This involved generating and validating the synthetic "
        "corpus with a licensed psychologist, implementing the training loop with class-weighted cross-entropy loss, "
        "and evaluating model performance. I selected and deployed the final XLM-R model for the RAG pipeline.",
  ),
];
