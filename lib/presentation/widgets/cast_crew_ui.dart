import 'package:flutter/material.dart';

import '../../data/models/cast_crew_model.dart';

class CastCrewUi extends StatelessWidget {
  final Cast cast;

  const CastCrewUi({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: ClipOval(
                child: cast.profilePath != null
                    ? Image.network(
                  "https://image.tmdb.org/t/p/w185${cast.profilePath}",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover, // or BoxFit.contain for centered without crop
                )
                    : Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text(
            cast.originalName?? "No name found",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              overflow: TextOverflow.ellipsis
            ),
          ),
          SizedBox(height: 5,),
          Text(
            cast.character?? "No name found",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
