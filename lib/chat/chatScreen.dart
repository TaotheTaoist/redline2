// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   final String currentUserID;
//   final String matchedUserID;

//   ChatScreen({required this.currentUserID, required this.matchedUserID});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController messageController = TextEditingController();
//   String chatRoomID = '';

//   @override
//   void initState() {
//     super.initState();
//     // Generate or fetch chat room ID
//     chatRoomID = getChatRoomID(widget.currentUserID, widget.matchedUserID);
//   }

//   String getChatRoomID(String user1, String user2) {
//     return user1.hashCode <= user2.hashCode ? '$user1-$user2' : '$user2-$user1';
//   }

//   // Send message function
//   void sendMessage(String messageText) {
//     if (messageText.isNotEmpty) {
//       FirebaseFirestore.instance
//           .collection('ChatRooms')
//           .doc(chatRoomID)
//           .collection('messages')
//           .add({
//         'senderId': widget.currentUserID,
//         'text': messageText,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with ${widget.matchedUserID}'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('ChatRooms')
//                   .doc(chatRoomID)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     var message = snapshot.data!.docs[index];
//                     bool isSender = message['senderId'] == widget.currentUserID;

//                     return ListTile(
//                       title: Align(
//                         alignment: isSender
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: isSender ? Colors.blue : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(message['text']),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     sendMessage(messageController.text);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images from gallery or camera

class ChatScreen extends StatefulWidget {
  final String currentUserID;
  final String matchedUserID;

  ChatScreen({required this.currentUserID, required this.matchedUserID});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  String chatRoomID = '';
  File? imageFile;

  @override
  void initState() {
    super.initState();
    chatRoomID = getChatRoomID(widget.currentUserID, widget.matchedUserID);
  }

  String getChatRoomID(String user1, String user2) {
    return user1.hashCode <= user2.hashCode ? '$user1-$user2' : '$user2-$user1';
  }

  // Send message function (text)
  void sendMessage(String messageText) {
    if (messageText.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomID)
          .collection('messages')
          .add({
        'senderId': widget.currentUserID,
        'text': messageText,
        'imageUrl': null, // No image URL when sending text
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
    }
  }

  // Send image message
  Future<void> sendImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('chatImages/$fileName');
    UploadTask uploadTask = storageReference.putFile(imageFile);

    // Wait for the upload to complete
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String imageUrl = await snapshot.ref.getDownloadURL();

    // Store image message in Firestore
    FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomID)
        .collection('messages')
        .add({
      'senderId': widget.currentUserID,
      'text': '', // No text when sending an image
      'imageUrl': imageUrl, // Save the image URL
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      await sendImage(imageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.matchedUserID}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('ChatRooms')
                  .doc(chatRoomID)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  reverse: true, // Messages appear from the bottom upwards
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    bool isSender = message['senderId'] == widget.currentUserID;
                    bool isTextMessage =
                        message['text'] != null && message['text'] != '';
                    bool isImageMessage = message['imageUrl'] != null &&
                        message['imageUrl'] != '';

                    return Align(
                      alignment: isSender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: isSender
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (isTextMessage)
                              Text(
                                message['text'],
                                style: TextStyle(
                                  color: isSender ? Colors.white : Colors.black,
                                ),
                              ),
                            if (isImageMessage)
                              Image.network(
                                message['imageUrl'],
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            const SizedBox(height: 4),
                            Text(
                              message['timestamp'] != null
                                  ? (message['timestamp'] as Timestamp)
                                      .toDate()
                                      .toString()
                                  : '',
                              style: TextStyle(
                                color:
                                    isSender ? Colors.white54 : Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed:
                      pickImage, // Pick an image when the button is pressed
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
