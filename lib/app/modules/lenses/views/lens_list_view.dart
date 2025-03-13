import 'package:cached_network_image/cached_network_image.dart';
import 'package:camerakit_flutter/lens_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:snapchat_flutter/app/configs/constants.dart';
import 'package:snapchat_flutter/app/configs/theme.dart';
import 'package:snapchat_flutter/app/controllers/camera_controller.dart';

class LensListView extends GetView<CameraKitController> {
  const LensListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Snapchat Lenses',
          style: Get.textTheme.titleLarge?.copyWith(color: AppTheme.darkTextColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkTextColor),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppTheme.darkSurfaceColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }
        
        if (controller.lenses.isEmpty) {
          return _buildEmptyState();
        }
        
        return _LensListContent(lenses: controller.lenses);
      }),
    );
  }
  
  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[700]!,
        highlightColor: Colors.grey[600]!,
        child: ListView.separated(
          itemCount: 5,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) => Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.darkCardColor,
              borderRadius: BorderRadius.circular(Constants.defaultBorderRadius),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_none,
            size: 72,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            Constants.noLensesAvailable,
            style: AppTheme.darkTitleStyle.copyWith(color: Colors.grey[400]),
          ),
          const SizedBox(height: 8),
          Text(
            'Check your group IDs and internet connection.',
            style: AppTheme.darkBodyStyle.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LensListContent extends StatefulWidget {
  final List<Lens> lenses;

  const _LensListContent({required this.lenses});

  @override
  State<_LensListContent> createState() => _LensListContentState();
}

class _LensListContentState extends State<_LensListContent> {
  final List<String> _categories = [
    'All Lenses',
    'Popular',
    'Funny',
    'Seasonal',
    'Artistic'
  ];
  
  String _selectedCategory = 'All Lenses';
  List<Lens> _filteredLenses = [];
  
  @override
  void initState() {
    super.initState();
    _filterLenses();
  }
  
  @override
  void didUpdateWidget(covariant _LensListContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lenses != widget.lenses) {
      _filterLenses();
    }
  }
  
  void _filterLenses() {
    if (_selectedCategory == 'All Lenses') {
      _filteredLenses = widget.lenses;
    } else {
      // In a real app, you'd filter based on lens metadata
      // Here we'll simulate filtering by using modulo for demonstration
      switch (_selectedCategory) {
        case 'Popular':
          _filteredLenses = widget.lenses
              .where((lens) => widget.lenses.indexOf(lens) % 5 == 0)
              .toList();
          break;
        case 'Funny':
          _filteredLenses = widget.lenses
              .where((lens) => widget.lenses.indexOf(lens) % 4 == 1)
              .toList();
          break;
        case 'Seasonal':
          _filteredLenses = widget.lenses
              .where((lens) => widget.lenses.indexOf(lens) % 3 == 2)
              .toList();
          break;
        case 'Artistic':
          _filteredLenses = widget.lenses
              .where((lens) => widget.lenses.indexOf(lens) % 2 == 0)
              .toList();
          break;
        default:
          _filteredLenses = widget.lenses;
      }
    }
  }
  
  void _selectCategory(String category) {
    if (_selectedCategory != category) {
      setState(() {
        _selectedCategory = category;
        _filterLenses();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CameraKitController controller = Get.find<CameraKitController>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Counter and search area
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Text(
                '${_filteredLenses.length} lenses',
                style: AppTheme.darkSubtitleStyle.copyWith(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                _selectedCategory,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        // Lens categories (horizontal scrolling)
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: _categories.map((category) {
              final bool isSelected = _selectedCategory == category;
              return _buildCategoryChip(category, isSelected);
            }).toList(),
          ),
        ),
        
        // Empty state for filtered results
        if (_filteredLenses.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.filter_list_off,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No lenses in this category',
                    style: AppTheme.darkTitleStyle.copyWith(
                      color: Colors.grey[400],
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _selectCategory('All Lenses'),
                    icon: const Icon(Icons.grid_view_rounded),
                    label: const Text('View All Lenses'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        // Lens grid
        if (_filteredLenses.isNotEmpty)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: _filteredLenses.length,
                itemBuilder: (context, index) {
                  final lens = _filteredLenses[index];
                  return _buildLensCard(lens, controller);
                },
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => _selectCategory(label),
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : AppTheme.darkTextColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          backgroundColor: isSelected ? AppTheme.primaryColor : AppTheme.darkCardColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          elevation: isSelected ? 2 : 0,
        ),
      ),
    );
  }
  
  Widget _buildLensCard(Lens lens, CameraKitController controller) {
    return Hero(
      tag: 'lens-${lens.id}',
      child: GestureDetector(
        onTap: () {
          if (lens.id != null && lens.groupId != null) {
            controller.openCameraKitWithSingleLens(lens.id!, lens.groupId!);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.darkCardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Lens thumbnail
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      lens.thumbnail != null && lens.thumbnail!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: lens.thumbnail![0],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[800],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppTheme.primaryColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[800],
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey[800],
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[600],
                              ),
                            ),
                      
                      // Hover effect
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (lens.id != null && lens.groupId != null) {
                              controller.openCameraKitWithSingleLens(lens.id!, lens.groupId!);
                            }
                          },
                          splashColor: AppTheme.primaryColor.withOpacity(0.3),
                          highlightColor: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                      ),
                      
                      // Overlay gradient for text readability
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Lens name
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: const BoxDecoration(
                  color: AppTheme.darkCardColor,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        lens.name ?? 'Unnamed Lens',
                        style: AppTheme.darkBodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.touch_app,
                      color: AppTheme.primaryColor,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}