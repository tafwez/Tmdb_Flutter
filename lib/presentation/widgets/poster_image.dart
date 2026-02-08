import 'package:flutter/material.dart';

class PosterImage extends StatelessWidget {
  final String? posterPath;
  final double width;
  final double height;
  final String heroTag;

  final double borderRadius;
  final bool showBorder;
  final double borderWidth;
  final Color? borderColor;

  const PosterImage({
    super.key,
    required this.posterPath,
    required this.width,
    required this.height,
    required this.heroTag,
    this.borderRadius = 4,
    this.showBorder = true,
    this.borderWidth = 1,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return Hero(
      tag: heroTag,
      child: Container(
        width: width,
        height: height,
        padding: showBorder ? const EdgeInsets.all(2) : EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: showBorder
              ? Border.all(
                  width: borderWidth,
                  color: borderColor ?? Theme.of(context).dividerColor,
                )
              : null,
        ),
        child: posterPath != null
            ? Image.network(
                'https://image.tmdb.org/t/p/w500$posterPath',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _loadingPlaceholder(width, height, loadingProgress);
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder(context, width, height);
                },
              )
            : _buildPlaceholder(context, width, height),
      ),
    );
  }
}

Widget _buildPlaceholder(BuildContext context, double width, double height) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(color: Colors.grey[300]),
    child: const Icon(Icons.movie, size: 48),
  );
}

Widget _loadingPlaceholder (double width,double height, ImageChunkEvent loadingProgress,){
 return Container(
    height: width,
    width: height,
    decoration: BoxDecoration(color: Colors.grey[300]),
    child: Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        value:
        loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!
            : null,
      ),
    ),
  );
}
