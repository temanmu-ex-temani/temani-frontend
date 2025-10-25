import 'dart:math';

class AffirmationService {
  static final List<String> _affirmations = [
    'Kamu lebih dari yang kamu kira! Setiap hari adalah kesempatan baru untuk tumbuh dan berkembang.',
    'Kamu memiliki kekuatan untuk mengatasi segala rintangan yang menghadang di depan.',
    'Percayalah pada dirimu sendiri, kamu mampu mencapai apapun yang kamu impikan.',
    'Setiap langkah kecil membawa kamu lebih dekat ke tujuan yang kamu inginkan.',
    'Kamu layak mendapatkan kebahagiaan dan kesuksesan dalam hidup ini.',
    'Hari ini adalah hari yang penuh dengan kemungkinan dan peluang baru.',
    'Kamu adalah pribadi yang kuat dan berharga, jangan pernah meragukan dirimu sendiri.',
    'Setiap tantangan adalah kesempatan untuk belajar dan menjadi lebih baik.',
    'Kamu memiliki potensi yang tak terbatas di dalam dirimu, wujudkan impianmu!',
    'Kesuksesan dimulai dari keyakinan pada diri sendiri dan tekad yang kuat.',
  ];

  static String getRandomAffirmation() {
    final random = Random();
    final index = random.nextInt(_affirmations.length);
    return _affirmations[index];
  }

  static List<String> getAllAffirmations() {
    return List.from(_affirmations);
  }
}
