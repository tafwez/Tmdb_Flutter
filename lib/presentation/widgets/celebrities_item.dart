import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tmdb_app/data/models/celebrities_model.dart';

class CelebritiesItem extends StatelessWidget {
  final String title;
  final CelebritiesModel celebritiesModel;
  final String seeAllRoute;
  final Map<String, dynamic> seeAllExtra;

  const CelebritiesItem({
    super.key,
    required this.title,
    required this.celebritiesModel,
    required this.seeAllRoute,
    required this.seeAllExtra,
  });

  @override
  Widget build(BuildContext context) {
    List<Result> result = celebritiesModel.results;


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title, style: Theme.of(context).textTheme.titleMedium),
                ),
                Row(
                  children: [
                    TextButton(
                      child: Text(
                        "See All",
                      ),
                      onPressed: () {},
                    ),
                    const Icon(Icons.navigate_next),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10,),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio:0.65,
              ),
              itemCount: result.length,
              itemBuilder: (context, index) {
                final celebrity = result[index];
                final popularity = (celebrity.popularity ?? 0) /2;
                final rating = popularity.clamp(0, 5);
                return Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                    side: BorderSide(color: Theme.of(context).dividerColor)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: SizedBox(
                          height: 185,
                          width: double.infinity,
                          child: celebrity.profileImageOriginal != null
                              ? Image.network(
                            celebrity.profileImageOriginal!,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.person, size: 40),
                          ),
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        celebrity.name ?? "Unknown",
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            celebrity.knownFor.isNotEmpty
                                ?  celebrity.knownFor.first.title ?? celebrity.knownFor.first.name ?? ""
                                : celebrity.knownForDepartment ?? "",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 4,),
                          Text(
                            "| ⭐ ${rating.toStringAsFixed(1)}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),

                        ],
                      ),
                      SizedBox(height: 2,),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}