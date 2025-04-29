import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izahs/features/post/domain/entities/comment.dart';
import 'package:izahs/features/post/presentation/cubits/post_states.dart';
import 'package:izahs/features/storage/domain/storage_repo.dart';

import '../../domain/entities/post.dart';
import '../../domain/repos/post_repo.dart';
import 'dart:io';
import 'dart:typed_data';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;
  PostCubit({required this.postRepo, required this.storageRepo})
      : super(PostsInitial());

  // create a new post

  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;

    try {
      // handle image upload for mobile platforms (using file path)
      if (imagePath != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }
      // handle image upload for web platforms (using file bytes)
      else if (imageBytes != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      // give iamge Url to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      // create post in the backend
      postRepo.createPost(newPost);

      // refetch all posts
      fetchAllPosts();
    } catch (e) {
      print(e);
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // feetech all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      print(e);
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // delete a post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      print(e);
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
      fetchAllPosts();
    } catch (e) {
      print(e);
      emit(PostsError("Error to toggle like: $e"));
    }
  }

  // add a comment to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to add comment: $e"));
    }
  }

  // delete comment from a post
  Future<void> deleteComment(String postId, Comment comment) async {
    try {
      await postRepo.deleteComment(postId, comment as String);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to delete comment: $e"));
    }
  }
}
