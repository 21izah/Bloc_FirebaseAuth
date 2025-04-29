import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izahs/features/auth/domain/entities/app_user.dart';
import 'package:izahs/features/auth/presentation/components/my_text_fields.dart';
import 'package:izahs/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:izahs/features/post/domain/entities/comment.dart';
import 'package:izahs/features/post/presentation/components/comment_tile.dart';
import 'package:izahs/features/post/presentation/cubits/post_cubit.dart';
import 'package:izahs/features/post/presentation/cubits/post_states.dart';
import 'package:izahs/features/profile/domain/entities/profile_user.dart';
import 'package:izahs/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:izahs/features/profile/presentation/pages/profile_page.dart';

import '../../../post/domain/entities/post.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currenUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currenUser!.uid);
  }

  void fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);

    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  // likes

  // user tapped like button
  void toggleLikePost() {
    // current like status
    final isLiked = widget.post.likes.contains(currenUser!.uid);

    // optimistically like & update UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currenUser!.uid);
      } else {
        widget.post.likes.add(currenUser!.uid);
      }
    });

    // update like
    postCubit
        .toggleLikePost(widget.post.id, currenUser!.uid)
        .catchError((error) {
      // if there is an error, revert back to original values
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currenUser!.uid); // revert unlike
        } else {
          widget.post.likes.remove(currenUser!.uid); // revert like
        }
      });
    });
  }

  // likes

  // comment text controller
  final commentController = TextEditingController();

  void openCommetBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextFields(
                controller: commentController,
                hintText: "Type a comment",
                obsureText: false,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  addComment();
                  Navigator.of(context).pop();
                },
                child: Text("Add Comment"),
              )
            ],
          ),
        );
      },
    );
  }

  // open comment box -> user wants to type a new comment
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add a new comment"),
          content: MyTextFields(
              controller: commentController,
              hintText: "Type a comment",
              obsureText: false),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                addComment();
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void addComment() {
    if (commentController.text.isNotEmpty && currenUser != null && mounted) {
      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: widget.post.id,
        userId: currenUser!.uid,
        userName: currenUser!.name ?? 'Anonymous',
        text: commentController.text,
        timestamp: DateTime.now(),
      );

      postCubit.addComment(widget.post.id, newComment).then((_) {
        if (mounted) {
          commentController.clear();
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
  }

  // void addComment() {
  //   // create a new comment
  //   final newComment = Comment(
  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //     postId: widget.post.id,
  //     userId: currenUser!.uid,
  //     userName: currenUser!.name,
  //     text: commentController.text,
  //     timestamp: DateTime.now(),
  //   );

  //   // add comment using cubit
  //   if (commentController.text.isNotEmpty) {
  //     postCubit.addComment(widget.post.id, newComment);
  //   }
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    uid: widget.post.userId,
                  ),
                )),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // profile pic
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: postUser!.profileImageUrl,
                          imageBuilder: (context, imageProvider) => Container(
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // like button
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: widget.post.likes.contains(currenUser!.uid)
                            ? Icon(Icons.favorite)
                            : Icon(
                                Icons.favorite_border,
                                color:
                                    widget.post.likes.contains(currenUser!.uid)
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                              ),
                      ),
                      SizedBox(
                        width: 5,
                      ),

                      // like count
                      Text(
                        widget.post.likes.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // comment button
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(
                    Icons.comment,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                SizedBox(
                  width: 5,
                ),

                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),

                Spacer(),

                // timestamp
                Text(
                  widget.post.timestamp.toString(),
                )
              ],
            ),
          ),

          // CAPTION
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20,
            ),
            child: Row(
              children: [
                // username
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // text
                Text(widget.post.text),
              ],
            ),
          ),

          // COMMENT SECTION
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              // loaded
              if (state is PostsLoaded) {
                // final individual post
                final post = state.posts
                    .firstWhere((post) => (post.id == widget.post.id));

                if (post.comments.isNotEmpty) {
                  // how many comments to show
                  int showCommentCount = post.comments.length;

                  // comment section
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: showCommentCount,
                    itemBuilder: (context, index) {
                      // get individual comment
                      final comment = post.comments[index];

                      // commet tile UI
                      return CommentTile(comment: comment);
                    },
                  );
                }
              }

              // loading ...
              if (state is PostsLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // error
              else if (state is PostsError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
