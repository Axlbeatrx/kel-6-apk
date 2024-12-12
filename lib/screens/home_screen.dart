import 'package:flutter/material.dart';
import '../api/api_service.dart';

class HomeScreen extends StatefulWidget {
  final int userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  late Future<List> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = ApiService.getPosts();
  }

  void addPost() async {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      final response = await ApiService.addPost(
        widget.userId,
        titleController.text,
        contentController.text,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['message'])));

      if (response['message'] == "Post added successfully") {
        setState(() {
          postsFuture = ApiService.getPosts(); // Refresh the posts
        });
        titleController.clear();
        contentController.clear();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Title and content cannot be empty")));
    }
  }

  void editPost(BuildContext context, Map post) async {
    final TextEditingController editTitleController =
        TextEditingController(text: post['title']);
    final TextEditingController editContentController =
        TextEditingController(text: post['content']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Post"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editTitleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: editContentController,
                decoration: InputDecoration(labelText: "Content"),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final response = await ApiService.updatePost(
                  post['id'],
                  widget.userId,
                  editTitleController.text,
                  editContentController.text,
                );

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(response['message'])));

                if (response['message'] == "Post updated successfully") {
                  setState(() {
                    postsFuture = ApiService.getPosts();
                  });
                }
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void deletePost(int postId) async {
    final response = await ApiService.deletePost(postId, widget.userId);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response['message'])));

    if (response['message'] == "Post deleted successfully") {
      setState(() {
        postsFuture = ApiService.getPosts(); // Refresh the posts
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 66, 239),
        elevation: 0,
        title: Center(
          child: Text("Home", style: TextStyle(color: Colors.white)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                margin: EdgeInsets.all(16),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: "Title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: contentController,
                        decoration: InputDecoration(
                          labelText: "Content",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: addPost,
                        child: Text("Add Post"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else {
                    final posts = snapshot.data as List;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post['title'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(post['content']),
                                SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (post['user_id'] == widget.userId) ...[
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () => editPost(
                                              context, post), // Edit post
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () => deletePost(
                                              post['id']), // Delete post
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
