import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hustle_gpt/providers/analysis_provider.dart';
import 'package:hustle_gpt/screens/camera_screen.dart';
import 'package:hustle_gpt/screens/processing_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({super.key, required this.cameras});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (Platform.isIOS) {
      final photosStatus = await Permission.photos.status;
      if (photosStatus.isDenied) {
        await Permission.photos.request();
      }
    }

    final cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      await Permission.camera.request();
    }

    setState(() {
      _hasPermission = true;
    });
  }

  Future<void> _takePicture() async {
    if (widget.cameras.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No camera available')));
      return;
    }

    if (!_hasPermission) {
      await _checkPermissions();
      if (!_hasPermission) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera and photo library permissions are required'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: widget.cameras.first),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (!_hasPermission) {
      await _checkPermissions();
      if (!_hasPermission) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo library permission is required'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProcessingScreen(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      _Category(
        title: 'Snap & Sell',
        subtitle: '15 min',
        color: Theme.of(context).colorScheme.primary,
        onTap: _takePicture,
      ),
      _Category(
        title: 'Business Idea',
        subtitle: '12 min',
        color: Theme.of(context).colorScheme.secondary,
        onTap: _pickImage,
      ),
      _Category(
        title: 'Monetize Hobby',
        subtitle: '10 min',
        color: Theme.of(context).colorScheme.tertiary,
        onTap: _takePicture,
      ),
      _Category(
        title: 'Hidden Value',
        subtitle: '8 min',
        color: Theme.of(context).colorScheme.primary,
        onTap: _pickImage,
      ),
      _Category(
        title: 'Skills to Money',
        subtitle: '20 min',
        color: Theme.of(context).colorScheme.secondary,
        onTap: _takePicture,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello, David 👋',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) =>
                          _CategoryCard(category: categories[index]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Special for you',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('See all'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _RecommendationCard(
                          title: 'Morning Gratitude',
                          subtitle: '5 min • Morning',
                          color: Theme.of(context).colorScheme.primary,
                          onTap: _takePicture,
                        ),
                        const SizedBox(height: 16),
                        _RecommendationCard(
                          title: 'Serenity Before Sleep',
                          subtitle: '10 min • Evening',
                          color: Theme.of(context).colorScheme.secondary,
                          onTap: _pickImage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Category {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _Category({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}

class _CategoryCard extends StatelessWidget {
  final _Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        color: category.color.withOpacity(0.1),
        child: InkWell(
          onTap: category.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.play_arrow_rounded, color: category.color),
                ),
                const Spacer(),
                Text(
                  category.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: category.color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: category.color.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RecommendationCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onBackground.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
