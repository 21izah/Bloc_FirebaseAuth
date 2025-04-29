import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izahs/features/home/presentation/components/my_drawer.dart';
import 'package:izahs/features/home/presentation/components/post_tile.dart';
import 'package:izahs/features/post/presentation/cubits/post_cubit.dart';
import 'package:izahs/features/post/presentation/cubits/post_states.dart';
import 'package:izahs/responsive/constrained_scaffold.dart';

import '../../../post/presentation/pages/uplaod_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PostCubit postCubit;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postCubit = context.read<PostCubit>();
    fetchAllPosts();
  }

  Future<void> fetchAllPosts() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await postCubit.fetchAllPosts();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postCubit.deletePost(postId);
      await fetchAllPosts();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete post: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Text("Home"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadingPostPage(),
                  )),
              icon: Icon(Icons.add))
        ],
      ),
      drawer: MyDrawer02(),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is PostsLoaded) {
            final allPosts = state.posts;
            if (allPosts.isEmpty) {
              return const Center(child: Text('No posts available'));
            }
            return RefreshIndicator(
              onRefresh: fetchAllPosts,
              child: ListView.builder(
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  final post = allPosts[index];
                  return PostTile(
                    post: post,
                    onDeletePressed: () => deletePost(post.id),
                  );
                },
              ),
            );
          }
          if (state is PostsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
