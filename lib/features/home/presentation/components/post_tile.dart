import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izahs/features/auth/domain/entities/app_user.dart';
import 'package:izahs/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:izahs/features/post/domain/entities/comment.dart';
import 'package:izahs/features/post/presentation/cubits/post_cubit.dart';
import 'package:izahs/features/post/presentation/cubits/post_states.dart';
import 'package:izahs/features/profile/domain/entities/profile_user.dart';
import 'package:izahs/features/profile/presentation/cubits/profile_cubit.dart';

import '../../../post/domain/entities/post.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;
  const PostTile(
      {super.key, required this.post, required this.onDeletePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;

  // current user
  AppUser? currenUser;

  // post user
  ProfileUser? postUser;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getCurrentUser();
  //   fetchPostUser();
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentUser();
      fetchPostUser();
    });
  }

  void toggleLikePost() {
    if (currenUser == null) return;

    final isLiked = widget.post.likes.contains(currenUser!.uid);

    // Optimistic update
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currenUser!.uid);
      } else {
        widget.post.likes.add(currenUser!.uid);
      }
    });

    postCubit
        .toggleLikePost(widget.post.id, currenUser!.uid)
        .catchError((error) {
      // Revert optimistic update
      if (mounted) {
        setState(() {
          if (isLiked) {
            widget.post.likes.add(currenUser!.uid);
          } else {
            widget.post.likes.remove(currenUser!.uid);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $error")),
        );
      }
    });
  }

  void getCurrentUser() {
    if (mounted) {
      final authCubit = context.read<AuthCubit>();
      setState(() {
        currenUser = authCubit.currentUser;
        isOwnPost =
            (currenUser != null && widget.post.userId == currenUser!.uid);
      });
    }
  }

  // void getCurrentUser() {
  //   final authCubit = context.read<AuthCubit>();
  //   currenUser = authCubit.currentUser;
  //   isOwnPost = (widget.post.userId == currenUser!.uid);
  // }

  // void fetchPostUser() async {
  //   final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);

  //   if (fetchedUser != null) {
  //     setState(() {
  //       postUser = fetchedUser;
  //     });
  //   }
  // }

  void fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);

    if (fetchedUser != null && mounted) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  // comment text controller
  final commentTextController = TextEditingController();

  // open comment page
  void openCommentPage() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CommentPage(postId: widget.post.id),
    //   ),
    // );
  }
  // show comment option
  // void showCommentOption() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Add Comment"),
  //         content: TextField(
  //           controller: commentTextController,
  //           decoration: InputDecoration(hintText: "Enter your comment"),
  //         ),
  //         actions: [
  //           // cancel button
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text('cancel'),
  //           ),

  //           // add comment button
  //           TextButton(
  //             onPressed: () {
  //               // add comment
  //               // postCubit.addComment(widget.post.id, commentTextController.text);
  //               addComment();
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('add'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void showCommentOption() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Comment"),
          content: TextField(
            controller: commentTextController,
            decoration: InputDecoration(hintText: "Enter your comment"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'),
            ),
            TextButton(
              onPressed: () {
                if (mounted) {
                  addComment();
                  Navigator.of(context).pop();
                }
              },
              child: Text('add'),
            ),
          ],
        );
      },
    );
  }

  // void addComment() {
  //   // create a new comment
  //   final newComment = Comment(
  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //     postId: widget.post.id,
  //     userId: widget.post.userId,
  //     userName: widget.post.userName,
  //     text: commentTextController.text,
  //     timestamp: DateTime.now(),
  //   );

  //   // add commnet using cubit
  //   if (commentTextController.text.isNotEmpty) {
  //     postCubit.addComment(widget.post.id, newComment).then((_) {
  //       // clear text field
  //       commentTextController.clear();
  //       // show success message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Comment added successfully"),
  //         ),
  //       );
  //     }).catchError((error) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Error: $error"),
  //         ),
  //       );
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Comment cannot be empty"),
  //       ),
  //     );
  //   }
  // }

  void addComment() {
    if (!mounted) return; // Check if widget is still mounted

    if (commentTextController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Comment cannot be empty")),
        );
      }
      return;
    }

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currenUser?.uid ?? '', // Handle null user case
      userName: currenUser?.name ?? 'Anonymous',
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    postCubit.addComment(widget.post.id, newComment).then((_) {
      if (mounted) {
        commentTextController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Comment added successfully")),
        );
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $error")),
        );
      }
    });
  }

  // show option for deletion
  void showOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Post?"),
          actions: [
            // cancel button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'),
            ),

            // delete buttom
            TextButton(
              onPressed: () {
                widget.onDeletePressed!();
                Navigator.of(context).pop();
              },
              child: Text('delete'),
            ),
          ],
        );
      },
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // profile pic
                GestureDetector(
                  onTap: () {
                    // open profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          uid: widget.post.userId,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      postUser?.profileImageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: postUser!.profileImageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Icon(Icons.person),
                      SizedBox(
                        width: 10,
                      ),
                      // name
                      Text(
                        widget.post.userName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),

                // delete button
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOption,
                    child: Icon(Icons.delete),
                  )
              ],
            ),
          ),

          // image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              height: 430,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          // buttons -> like, commet, timestamp
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // like button

                SizedBox(
                  width: 30,
                  child: Row(
                    children: [
                      // In your build method, replace the like button with:
                      GestureDetector(
                        onTap: currenUser != null ? toggleLikePost : null,
                        child: Icon(
                          currenUser != null &&
                                  widget.post.likes.contains(currenUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: currenUser != null &&
                                  widget.post.likes.contains(currenUser!.uid)
                              ? Colors.red
                              : Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: toggleLikePost,
                      //   child: Icon(
                      //     widget.post.likes.contains(currenUser!.uid)
                      //         ? Icons.favorite_border
                      //         : Icons.favorite,
                      //     color: widget.post.likes.contains(currenUser!.uid)
                      //         ? Colors.red
                      //         : Theme.of(context).colorScheme.inversePrimary,
                      //   ),
                      // ),
                    ],
                  ),
                ),

                Text(
                  widget.post.likes.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),

                // comment button
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: GestureDetector(
                    onTap: showCommentOption,
                    child: Icon(Icons.comment),
                  ),
                ),
                Text(widget.post.comments.length.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                    )),

                Spacer(),

                // timestamp
                // Text(widget.post.timestamp.toString()),

                Text(
                  _formatTimeAgo(widget.post.timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // CAAPTION

          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                //username
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),

                // text
                Expanded(
                  child: Text(
                    widget.post.text,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // // COMMENTS SECTION
          // BlocBuilder<PostCubit, PostState>(
          //   builder: (context, state) {
          //     // loaded
          //     if (state is PostsLoaded) {
          //       // final individual post
          //       final post = state.posts
          //           .firstWhere((post) => (post.id == widget.post.id));

          //       if (post.comments.isNotEmpty) {
          //         // how many comments to show

          //         int showCommentCount = post.comments.length;

          //         // comment section
          //         return ListView.builder(
          //           itemCount: showCommentCount,
          //           itemBuilder: (context, index) {
          //             // get individual comment
          //             final comment = post.comments[index];

          //             // comment tile

          //             return Padding(
          //               padding: const EdgeInsets.only(left: 20.0),
          //               child: Row(
          //                 children: [
          //                   // name
          //                   Text(
          //                     comment.userName,
          //                     style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),

          //                   SizedBox(
          //                     width: 10,
          //                   ),

          //                   // comment text
          //                   Text(comment.text),
          //                 ],
          //               ),
          //             );
          //           },
          //         );
          //       }
          //     }

          //     // loading...
          //     if (state is PostsLoading) {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }

          //     // error state
          //     else if (state is PostsError) {
          //       return Center(
          //         child: Text(state.message),
          //       );
          //     }

          //     //  else {
          //     //   return Center(
          //     //     child: Text("Something went wrong...."),
          //     //   );
          //     // }
          //   },
          // ),

          // COMMENTS SECTION
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              String _formatTimeAgo(DateTime date) {
                final now = DateTime.now();
                final difference = now.difference(date);

                if (difference.inDays > 365) {
                  return '${(difference.inDays / 365).floor()}y ago';
                } else if (difference.inDays > 30) {
                  return '${(difference.inDays / 30).floor()}mo ago';
                } else if (difference.inDays > 0) {
                  return '${difference.inDays}d ago';
                } else if (difference.inHours > 0) {
                  return '${difference.inHours}h ago';
                } else if (difference.inMinutes > 0) {
                  return '${difference.inMinutes}m ago';
                }
                return 'Just now';
              }

              // Handle all possible states explicitly
              if (state is PostsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is PostsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        "Failed to load comments",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () =>
                            context.read<PostCubit>().fetchAllPosts(),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              if (state is PostsLoaded) {
                try {
                  // Safely find the post
                  final post = state.posts.firstWhere(
                    (post) => post.id == widget.post.id,
                    orElse: () =>
                        widget.post, // Fallback to widget.post if not found
                  );

                  if (post.comments.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "No comments yet",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    );
                  }

                  return ListView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // For nested ListView
                    shrinkWrap: true,
                    itemCount: post.comments.length,
                    itemBuilder: (context, index) {
                      final comment = post.comments[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // User name
                                Text(
                                  comment.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Timestamp
                                Text(
                                  _formatTimeAgo(comment.timestamp),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Comment text
                            Text(comment.text),
                          ],
                        ),
                      );
                    },
                  );
                } catch (e) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.warning_amber, size: 40),
                        const SizedBox(height: 8),
                        const Text(
                          "Something went wrong",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          e.toString(),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () =>
                              context.read<PostCubit>().fetchAllPosts(),
                          child: const Text("Try again"),
                        ),
                      ],
                    ),
                  );
                }
              }

              // Default fallback
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
