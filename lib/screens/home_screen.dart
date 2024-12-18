import 'package:flutter/material.dart';
import '../api/api_service.dart';

class HomeScreen extends StatefulWidget {
  final int userId; // ID user yang sedang login
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  HomeScreen({
    required this.userId,
    required this.isDarkMode,
    required this.toggleTheme,
  });

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
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: widget.toggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addPost,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Add Post'),
            ),
            const SizedBox(height: 20),
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
                        final isOwner = post['user_id'] == widget.userId;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(post['title']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post['content']),
                                Text(
                                  "by: ${post['author']}", // Ambil 'author' dari respons API
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12),
                                ), // Tambahkan username
                              ],
                            ),
                            trailing: isOwner
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () =>
                                            editPost(context, post),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => deletePost(post['id']),
                                      ),
                                    ],
                                  )
                                : null, // Sembunyikan tombol jika bukan pemilik
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
