import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymbros/screens/components/likeAnimation.dart';
import 'package:gymbros/screens/socialmedia/commentpage.dart';
import 'package:gymbros/services/authservice.dart';
import 'package:gymbros/services/databaseservice.dart';
import 'package:gymbros/shared/imageUtil.dart';
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
  int commentLen = 0;
  bool isLikeAnimating = false;
  final DatabaseService _db = DatabaseService(uid: AuthService().getUid());

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
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
                  backgroundImage: NetworkImage(widget.snap['profImage'].toString()),
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
                IconButton(
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
                                          onTap: () {},
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ));
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          // Image Body
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
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder:(context) => CommentPage(
                            postID: widget.snap['postID'].toString()
                    )
                    )
                  ),
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
                        style: const TextStyle(color: Colors.black45),
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
                  onTap: () {},
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text('View all 200 comments',
                          style:
                              TextStyle(fontSize: 16, color: Colors.black38))),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        DateFormat.yMMMd().format(
                          widget.snap["datePublished"].toDate(),
                        ),
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black38))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
