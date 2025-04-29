import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izahs/features/auth/domain/entities/app_user.dart';
import 'package:izahs/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:izahs/features/home/presentation/components/post_tile.dart';
import 'package:izahs/features/post/presentation/cubits/post_cubit.dart';
import 'package:izahs/features/post/presentation/cubits/post_states.dart';
import 'package:izahs/features/profile/presentation/component/bio_box.dart';
import 'package:izahs/features/profile/presentation/component/follow_button.dart';
import 'package:izahs/features/profile/presentation/component/profile_stats.dart';
import 'package:izahs/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:izahs/features/profile/presentation/cubits/profile_states.dart';
import 'package:izahs/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:izahs/features/profile/presentation/pages/follower_page.dart';
import 'package:izahs/responsive/constrained_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // current user
  late AppUser? currentUser = authCubit.currentUser;

  // posts
  int postCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    profileCubit.fetchUserProfile(widget.uid);
    super.initState();
  }

  // follow / unfollow

  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return; // return if profile is not loaded
    }

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    // optimistically update the UI
    setState(() {
      // unfollow
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      }

      // follow
      else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      // revert update if there's an error
      setState(() {
        // unfollow
        if (isFollowing) {
          profileUser.followers.add(currentUser!.uid);
        }

        // follow
        else {
          profileUser.followers.remove(currentUser!.uid);
        }
      });
    });
  }
  // follow / unfollow

  @override
  Widget build(BuildContext context) {
    // is own post
    bool isOwnPost = (widget.uid == currentUser!.uid);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // when loaded
        if (state is ProfileLoaded) {
          // get the loaded user
          final user = state.profileUser;

          return ConstrainedScaffold(
            appBar: AppBar(
              title: Text("${user.name}"),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                if (isOwnPost)
                  IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              user: user,
                            ),
                          )),
                      icon: Icon(Icons.settings))
              ],
            ),
            body: ListView(
              children: [
                Center(
                  child: Text(
                    "${user.email}",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                CachedNetworkImage(
                  imageUrl: user.profileImageUrl,
                  // loading...
                  placeholder: (context, url) =>
                      Center(child: const CircularProgressIndicator()),

                  // error
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  // loaded
                  imageBuilder: (context, imageProvider) => Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),

                // profile stats
                ProfileStats(
                  postCounts: postCount,
                  followerCount: user.followers.length,
                  followingCount: user.following.length,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowerPage(
                        followers: user.followers,
                        following: user.following,
                      ),
                    ),
                  ),
                ),

                // follow button
                if (!isOwnPost)
                  FollowButton(
                      onPressed: followButtonPressed,
                      isFollowing: user.followers.contains(currentUser!.uid)),

                SizedBox(
                  height: 25,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                BioBox(text: user.bio),
                Padding(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    top: 25,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                // lists of posts from this user
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    // posts loaded...
                    if (state is PostsLoaded) {
                      // filter the posts by user id
                      final userPosts = state.posts
                          .where((post) => post.userId == widget.uid)
                          .toList();

                      postCount = userPosts.length;

                      return ListView.builder(
                        itemCount: postCount,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          // get individual post
                          final post = userPosts[index];

                          // return as post tile UI
                          return PostTile(
                            post: post,
                            onDeletePressed: () =>
                                context.read<PostCubit>().deletePost(post.id),
                          );
                        },
                      );
                    }

                    // posts loading...
                    else if (state is PostsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: Text("No posts.."),
                      );
                    }
                  },
                )
              ],
            ),
          );
        }
        // when loading...
        else if (state is ProfileLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Center(
            child: Text("No profile found.."),
          );
        }
      },
    );
  }
}
