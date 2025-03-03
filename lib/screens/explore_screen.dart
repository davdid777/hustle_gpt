import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _Category(
        icon: Icons.shopping_bag_outlined,
        title: 'Sell Items',
        description: 'Turn your unused items into cash',
        color: Colors.orange,
      ),
      _Category(
        icon: Icons.business_center_outlined,
        title: 'Start a Business',
        description: 'Turn your space or skills into a business',
        color: Colors.blue,
      ),
      _Category(
        icon: Icons.handyman_outlined,
        title: 'Freelance Services',
        description: 'Offer your skills and services',
        color: Colors.green,
      ),
      _Category(
        icon: Icons.real_estate_agent_outlined,
        title: 'Real Estate',
        description: 'Monetize your property or space',
        color: Colors.purple,
      ),
      _Category(
        icon: Icons.brush_outlined,
        title: 'Creative Projects',
        description: 'Sell your art and creative work',
        color: Colors.pink,
      ),
      _Category(
        icon: Icons.school_outlined,
        title: 'Teaching & Coaching',
        description: 'Share your knowledge and expertise',
        color: Colors.teal,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore Opportunities',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryCard(category: category);
        },
      ),
    );
  }
}

class _Category {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _Category({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class _CategoryCard extends StatelessWidget {
  final _Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: category.color.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category detail screen
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(category.icon, size: 32, color: category.color),
              ),
              const SizedBox(height: 16),
              Text(
                category.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                category.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
