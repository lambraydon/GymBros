import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostView extends StatelessWidget {
  final snap;
  const PostView({
    Key? key,
    required this.snap,
  }) : super(key: key);

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
                  backgroundImage: NetworkImage(
                      'https://plus.unsplash.com/premium_photo-1679635697694-4ab045eb0af6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1171&q=80'),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snap["username"],
                          style: TextStyle(
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
                              )
                      );
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          // Image Body
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(snap["postUrl"],
              fit: BoxFit.cover,
            ),
          ),
          // Like and Comment Bar
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.comment_outlined,
                  )
              ),
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
                Text("${snap["likes"].length} likes"),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 8
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black45),
                      children: [
                        TextSpan(
                          text: snap["username"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: " ${snap["description"]}",
                        )
                      ]
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        'View all 200 comments',
                    style: const TextStyle(fontSize: 16, color: Colors.black38))
                  ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        DateFormat.yMMMd().format(
                            snap["datePublished"].toDate(),
                        ),
                        style: const TextStyle(fontSize: 16, color: Colors.black38)
                )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
