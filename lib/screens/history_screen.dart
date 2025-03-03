import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual history data
    final historyItems = [
      _HistoryItem(
        image: 'https://picsum.photos/200',
        title: 'Vintage Camera',
        type: 'Item Sale',
        amount: 150.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: _HistoryStatus.completed,
      ),
      _HistoryItem(
        image: 'https://picsum.photos/201',
        title: 'Home Office Setup',
        type: 'Business Idea',
        amount: 500.0,
        date: DateTime.now().subtract(const Duration(days: 5)),
        status: _HistoryStatus.inProgress,
      ),
      _HistoryItem(
        image: 'https://picsum.photos/202',
        title: 'Guitar Lessons',
        type: 'Service',
        amount: 300.0,
        date: DateTime.now().subtract(const Duration(days: 7)),
        status: _HistoryStatus.completed,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Earnings History',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Earnings',
                    value: '\$950.00',
                    icon: Icons.attach_money,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Opportunities',
                    value: '3',
                    icon: Icons.rocket_launch_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                return _HistoryCard(item: historyItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem {
  final String image;
  final String title;
  final String type;
  final double amount;
  final DateTime date;
  final _HistoryStatus status;

  const _HistoryItem({
    required this.image,
    required this.title,
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
  });
}

enum _HistoryStatus { completed, inProgress }

class _HistoryCard extends StatelessWidget {
  final _HistoryItem item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to history detail
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.type,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${item.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatusBadge(status: item.status),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(item.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final _HistoryStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      _HistoryStatus.completed => (
        Theme.of(context).colorScheme.primary,
        'Completed',
      ),
      _HistoryStatus.inProgress => (
        Theme.of(context).colorScheme.secondary,
        'In Progress',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
