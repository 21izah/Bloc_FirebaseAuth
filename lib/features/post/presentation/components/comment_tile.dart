import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izahs/features/auth/domain/entities/app_user.dart';
import 'package:izahs/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:izahs/features/post/presentation/cubits/post_cubit.dart';

import '../../domain/entities/comment.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  // current user
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.uid);
  }

  // show option for deletion
  void showOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Comment?"),
          actions: [
            // cancel button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'),
            ),

            // delete buttom
            TextButton(
              onPressed: () {
                context.read<PostCubit>().deleteComment(
                    widget.comment.postId, widget.comment.id as Comment);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // name
          Text(
            widget.comment.userName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(
            width: 10,
          ),

          // comment text
          Text(widget.comment.text),

          Spacer(),

          // delete button
          if (isOwnPost)
            GestureDetector(
              onTap: showOption,
              child: Icon(
                Icons.more_horiz,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
        ],
      ),
    );
  }
}
