

import 'package:flutter/material.dart';


class TmdbRatingRow extends StatelessWidget {
  final double voteAverage; // 6.8
  final int voteCount; // 424
  final double starSize;

  const TmdbRatingRow({
    super.key,
    required this.voteAverage,
    required this.voteCount,
    this.starSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ***** stars (out of 5 visually)
        Row(
          children: List.generate(5, (index) {
            final ratingOutOf5 = voteAverage / 2;

            if (index + 1 <= ratingOutOf5) {
              return Icon(Icons.star,
                  size: starSize, color: Colors.amber);
            } else if (index + 0.5 <= ratingOutOf5) {
              return Icon(Icons.star_half,
                  size: starSize, color: Colors.amber);
            } else {
              return Icon(Icons.star_border,
                  size: starSize, color: Colors.amber);
            }
          }),
        ),

        const SizedBox(width: 5),

        // (424)
        Text(
          '($voteCount)',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
        ),

        const SizedBox(width: 20),

        // ★ 6.8
        Icon(Icons.star, size: starSize, color: Colors.amber),
        const SizedBox(width: 2),
        Text(
          voteAverage.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

