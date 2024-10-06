import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? pickedImage;
  String? userEmail;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    loadProfileImage();
  }

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email;
    });
  }

  Future<void> loadProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        profileImageUrl = userDoc['profileImageUrl'];
      });
    }
  }

  updateProfile() {
    if (pickedImage == null) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select an Image'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'))
              ],
            );
          });
    } else {
      uploadData();
    }
  }

  uploadData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      Reference ref = FirebaseStorage.instance.ref('profile_pictures').child(user.uid);
      UploadTask uploadTask = ref.putFile(pickedImage!);
      TaskSnapshot snapshot = await uploadTask;
      profileImageUrl = await snapshot.ref.getDownloadURL();

      // Save the profile image URL to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'profileImageUrl': profileImageUrl,
      }, SetOptions(merge: true));

      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  showAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick an Image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                ListTile(
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                ),
                ListTile(
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.image),
                  title: const Text('Gallery'),
                )
              ],
            ),
          );
        });
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) {
        return;
      }
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
    } catch (ex) {
      print(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(),
          InkWell(
            onTap: () {
              showAlertBox();
            },
            child: pickedImage != null
                ? CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(pickedImage!),
                  )
                : CircleAvatar(
                    radius: 60,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : null,
                    child: profileImageUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 80,
                          )
                        : null,
                  ),
          ),
          const SizedBox(height: 20),
          Text(
            userEmail ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              updateProfile();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Update Profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}














// this is write code but image is not showng whwn we go back from profile sreen and come back agian to profile screen
//
//import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   File? pickedImage;
//   String? userEmail;
//   String? profileImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//   }

//   void getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     setState(() {
//       userEmail = user?.email;
//     });
//   }

//   updateProfile() {
//     if (pickedImage == null) {
//       return showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Select an Image'),
//               actions: [
//                 TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Ok'))
//               ],
//             );
//           });
//     } else {
//       uploadData();
//     }
//   }

//   uploadData() async {
//     try {
//       Reference ref = FirebaseStorage.instance
//           .ref('profile_pictures')
//           .child(FirebaseAuth.instance.currentUser!.uid);
//       UploadTask uploadTask = ref.putFile(pickedImage!);
//       TaskSnapshot snapshot = await uploadTask;
//       profileImageUrl = await snapshot.ref.getDownloadURL();
//       setState(() {});
//       // Here you can also update the user's profile in Firestore with the image URL if needed
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   showAlertBox() {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Pick an Image'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Divider(),
//                 ListTile(
//                   onTap: () {
//                     pickImage(ImageSource.camera);
//                     Navigator.pop(context);
//                   },
//                   leading: const Icon(Icons.camera_alt),
//                   title: const Text('Camera'),
//                 ),
//                 ListTile(
//                   onTap: () {
//                     pickImage(ImageSource.gallery);
//                     Navigator.pop(context);
//                   },
//                   leading: const Icon(Icons.image),
//                   title: const Text('Gallery'),
//                 )
//               ],
//             ),
//           );
//         });
//   }

//   pickImage(ImageSource imageSource) async {
//     try {
//       final photo = await ImagePicker().pickImage(source: imageSource);
//       if (photo == null) {
//         return;
//       }
//       final tempImage = File(photo.path);
//       setState(() {
//         pickedImage = tempImage;
//       });
//     } catch (ex) {
//       print(ex.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Row(),
//           InkWell(
//             onTap: () {
//               showAlertBox();
//             },
//             child: pickedImage != null
//                 ? CircleAvatar(
//                     radius: 60,
//                     backgroundImage: FileImage(pickedImage!),
//                   )
//                 : CircleAvatar(
//                     radius: 60,
//                     backgroundImage: profileImageUrl != null
//                         ? NetworkImage(profileImageUrl!)
//                         : null,
//                     child: profileImageUrl == null
//                         ? const Icon(
//                             Icons.person,
//                             size: 80,
//                           )
//                         : null,
//                   ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             userEmail ?? '',
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               updateProfile();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blueAccent,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             child: const Text(
//               'Update Profile',
//               style: TextStyle(color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
























//First try from wscube ideo half code until the codition of email passward and pickedimage in video 
//
//import 'dart:io';
// import 'dart:js_interop';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   File? pickedImage;
//   updateProfile() {
//     if (pickedImage == null) {
//       return showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Select an Image'),
//               actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Ok'))],
//             );
//           });
//     }
//     else{
//       // UserCredential? usercredential;
//       uploadData();
//     }
//   }
//   // function for uploading pic 
//   uploadData()async{
// UploadTask uploadTask=FirebaseStorage.instance.ref('profile pictures').child().putFile(pickedImage!);
//   }

//   showAlertBox() {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Pick an Image'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Divider(),
//                 ListTile(
//                   onTap: () {
//                     pickImage(ImageSource.camera);
//                     Navigator.pop(context);
//                   },
//                   leading: const Icon(Icons.camera_alt),
//                   title: const Text('Camera'),
//                 ),
//                 ListTile(
//                   onTap: () {
//                     pickImage(ImageSource.gallery);
//                     Navigator.pop(context);
//                   },
//                   leading: const Icon(Icons.image),
//                   title: const Text('Gallery'),
//                 )
//               ],
//             ),
//           );
//         });
//   }

//   pickImage(ImageSource imageSource) async {
//     try {
//       final photo = await ImagePicker().pickImage(source: imageSource);
//       if (photo == null) {
//         return;
//       }
//       final tempInage = File(photo.path);
//       setState(() {
//         pickedImage = tempInage;
//       });
//     } catch (ex) {
//       print(ex.toString);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Row(),
//           InkWell(
//             onTap: () {
//               showAlertBox();
//             },
//             child: pickedImage != null
//                 ? CircleAvatar(
//                     radius: 80,
//                     backgroundImage: FileImage(pickedImage!),
//                   )
//                 : const CircleAvatar(
//                     radius: 80,
//                     child: Icon(
//                       Icons.person,
//                       size: 80,
//                     ),
//                   ),
//           ),
//           ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blueAccent,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             child: const Text(
//               'Update Profile',
//               style: TextStyle(color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
