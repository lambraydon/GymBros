import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/components/like_animation.dart';
import 'package:gymbros/screens/components/workout_tile_static.dart';
import 'package:gymbros/screens/home/view_profile.dart';
import 'package:gymbros/screens/socialmedia/comment_page.dart';
import 'package:gymbros/screens/workoutTracker/history_log.dart';
import 'package:gymbros/screens/workoutTracker/workout.dart';
import 'package:gymbros/services/auth_service.dart';
import 'package:gymbros/services/database_service.dart';
import 'package:gymbros/shared/image_util.dart';
import 'package:intl/intl.dart';

class PostView extends StatefulWidget {
  final snap;
  const PostView({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int _page = 0;
  String? selectedUser;
  late PageController pageController;
  int commentLen = 0;
  bool isLikeAnimating = false;
  final DatabaseService _db = DatabaseService(uid: AuthService().getUid());

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
    pageController = PageController();
  }

  void goToHistoryLog(Workout workout) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HistoryLog(
                  workout: workout,
                )));
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  deletePost(String postId) async {
    try {
      await _db.deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<String>? taggedUsers = (widget.snap['taggedUser'] as List)
        .map((item) => item as String)
        .toList();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //Header with Profile Pic + UserName
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      NetworkImage(widget.snap['profImage'].toString()),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap["username"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                (taggedUsers!.isNotEmpty)
                    ? Expanded(
                        child: DropdownButton<String>(
                            hint: const Text(
                              "tagged users",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            isExpanded: false,
                            value: selectedUser,
                            items: taggedUsers.map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            onChanged: (String? newVal) {}),
                      )
                    : const SizedBox(),
                widget.snap['uid'] == _db.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shrinkWrap: true,
                                      children: [
                                        'Delete',
                                      ]
                                          .map(
                                            (e) => InkWell(
                                              onTap: () {
                                                deletePost(widget.snap['postId']
                                                    .toString());
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ));
                        },
                        icon: const Icon(Icons.more_vert))
                    : IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shrinkWrap: true,
                                      children: [
                                        'View Profile',
                                      ]
                                          .map(
                                            (e) => InkWell(
                                              onTap: () => Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewProfile(
                                                              uid: widget
                                                                  .snap['uid']
                                                                  .toString()))),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ));
                        },
                        icon: const Icon(Icons.more_vert))
              ],
            ),
          ),
          // Image Body
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              physics: const ScrollPhysics(),
              children: [
                GestureDetector(
                  onDoubleTap: () async {
                    _db.likePost(
                      widget.snap['postId'].toString(),
                      _db.uid,
                      widget.snap['likes'],
                    );
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(alignment: Alignment.center, children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: double.infinity,
                      child: Image.network(
                        widget.snap["postUrl"],
                        fit: BoxFit.cover,
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        duration: const Duration(
                          milliseconds: 400,
                        ),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: WorkoutTileStatic(
                      workout: Workout.fromJson(widget.snap['workout'])),
                ),
              ],
            ),
          ),

          // Like and Comment Bar
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  _db.likePost(
                    widget.snap['postId'].toString(),
                    _db.uid,
                    widget.snap['likes'],
                  );
                },
                icon: widget.snap['likes'].contains(_db.uid)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border,
                      ),
              ),
              IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentPage(
                          postID: widget.snap['postId'].toString()))),
                  icon: const Icon(
                    Icons.comment_outlined,
                  )),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.snap["likes"].length} likes"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: widget.snap["username"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: " ${widget.snap["description"]}",
                          )
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentPage(
                          postID: widget.snap['postId'].toString()))),
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: (commentLen > 0)
                          ? Text('View all $commentLen comments',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black38))
                          : const Text("no comments yet... post one here!")
                  )
                      ,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                            DateFormat.yMMMd().format(
                              widget.snap["datePublished"].toDate(),
                            ),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black38)))

              ],
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
