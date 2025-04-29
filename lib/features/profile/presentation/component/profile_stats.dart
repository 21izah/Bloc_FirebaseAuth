import 'package:flutter/material.dart';

/*

PROFILE STATS 

This will be displayed on all profile pages 
--------------------------------------------------------------

Display 
- Number of posts\
- Number of followers
- Number of following


*/

class ProfileStats extends StatelessWidget {
  final int postCounts;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;
  const ProfileStats({
    super.key,
    required this.postCounts,
    required this.followerCount,
    required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // text style for count
    var textStyleForCount = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    // text style for text
    var textStyleForText = TextStyle(
      fontSize: 20,
      color: Theme.of(context).colorScheme.primary,
    );
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          // posts
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  postCounts.toString(),
                  style: textStyleForCount,
                ),
                Text(
                  "Posts",
                  style: textStyleForText,
                ),
              ],
            ),
          ),

          // followers
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followerCount.toString(),
                  style: textStyleForCount,
                ),
                Text(
                  "Followers",
                  style: textStyleForText,
                ),
              ],
            ),
          ),

          // following
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followingCount.toString(),
                  style: textStyleForCount,
                ),
                Text(
                  "Following",
                  style: textStyleForText,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
