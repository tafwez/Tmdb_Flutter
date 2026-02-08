import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/core/cubits/main_cubit/main_cubit.dart';
import 'package:tmdb_app/core/cubits/main_cubit/state.dart';
import 'package:tmdb_app/core/helper/service_locator.dart';
import 'package:tmdb_app/data/models/celebrities_model.dart';
import 'package:tmdb_app/presentation/widgets/celebrities_item.dart';

class CelebritiesScreen extends StatefulWidget {
  const CelebritiesScreen({super.key});

  @override
  State<CelebritiesScreen> createState() => _CelebritiesScreenState();
}

class _CelebritiesScreenState extends State<CelebritiesScreen> {
  late final MainCubit _getCelebrities;
  int firstPage = 1;

  @override
  void initState() {
    _getCelebrities = getIt<MainCubit>()
      ..getCelebrities(firstPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _getCelebrities.getCelebrities(firstPage);
        },
        child: BlocBuilder<MainCubit, ApiState<dynamic>>(
          bloc: _getCelebrities,
          builder: (context, state) {
            // Handle loading state
            if (state is ApiLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Handle error state
            if (state is ApiError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    ElevatedButton(
                      onPressed: () => _getCelebrities.getCelebrities(firstPage),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Handle loaded state
            if (state is ApiLoaded) {
              return CelebritiesItem(
                title: "Popular",
                celebritiesModel: state.data as CelebritiesModel,
                seeAllRoute: 'celebrities_see_all',
                seeAllExtra: {
                  'title': 'Popular Celebrities',
                  'category': 'popular',
                  'mediaType': 'person',
                },
              );
            }

            // Default/empty state
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}
