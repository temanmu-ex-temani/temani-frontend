import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'journal_card.dart';

class JournalList extends StatelessWidget {
  const JournalList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mockJournals = [
      {
        'title': 'Hari yang sangat menarik',
        'content':
            'Hari ini saya pergi ke gunung naik sepeda roda tiga, ternyata...',
        'date': 'Rabu, 2 Juli 2025',
      },
      {
        'title': 'Hari yang sangat menarik',
        'content':
            'Hari ini saya pergi ke gunung naik sepeda roda tiga, ternyata...',
        'date': 'Rabu, 2 Juli 2025',
      },
      {
        'title': 'Hari yang sangat menarik',
        'content':
            'Hari ini saya pergi ke gunung naik sepeda roda tiga, ternyata...',
        'date': 'Rabu, 2 Juli 2025',
      },
      {
        'title': 'Hari yang sangat menarik',
        'content':
            'Hari ini saya pergi ke gunung naik sepeda roda tiga, ternyata...',
        'date': 'Rabu, 2 Juli 2025',
      },
    ];

    return ListView.separated(
      itemCount: mockJournals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final journal = mockJournals[index];
        return JournalCard(
          title: journal['title']!,
          content: journal['content']!,
          date: journal['date']!,
        );
      },
    );
  }
}
