import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/core/utils/component.dart';
import 'package:news/features/home/presentation/controllers/cubit/home_cubit.dart';
import 'package:news/features/home/presentation/controllers/cubit/home_state.dart';
import 'dart:async'; // Added for debouncing

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final TextEditingController searchController = TextEditingController();
  Timer? _debounce; // For debouncing search

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        final cubit = NewsCubit.get(context);
        final list = cubit.search;

        return Scaffold(
          appBar: AppBar(title: const Text('Search'), centerTitle: true),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: defaultFormField(
                  controller: searchController,
                  type: TextInputType.text,
                  onChange: (value) {
                    // Debounce search to avoid excessive API calls
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      if (value.isNotEmpty) {
                        cubit.getSearch(value: value);
                      }
                    });
                  },
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Search must not be empty';
                    }
                    return null;
                  },
                  label: 'Search',
                  prefix: Icons.search,
                ),
              ),
              Expanded(
                child: _buildContent(state, list),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(NewsState state, List<Map<String, dynamic>> list) {
    if (state is NewsGetSearchLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NewsGetSearchSuccessState) {
      if (list.isEmpty) {
        return const Center(child: Text('No articles found'));
      }
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: list.length, // Dynamic itemCount based on list length
        itemBuilder: (context, index) => buildArticleItemSearch(
              Article.fromJson(list[index]),
            key: ValueKey(list[index]['url'] ?? index)),
      );
    } else if (state is NewsGetSearchErrorState) {
      return Center(child: Text('Error: ${state.error}'));
    }
    return const Center(child: Text('Enter a search query'));
  }
}

Widget buildArticleItemSearch(Article article, {Key? key}) {
  return Card(
    key: key,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image widget with fixed size and error handling
          SizedBox(
            width: 100,
            height: 100,
            child: article.urlToImage != null
                ? Image.network(
                    article.urlToImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  )
                : const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
          ),
          const SizedBox(width: 12.0),
          // Title and description in a column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                Text(
                  article.description ?? 'No description',
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class Article {
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage; // Added for image URL

  Article({
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'], // Added for image URL
    );
  }
}