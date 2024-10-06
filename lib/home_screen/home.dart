import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:synergistic_task/wdgets/custom_textfield/custom_textfield.dart';
import 'package:synergistic_task/form_screen/form.dart';
import 'package:synergistic_task/service/database.dart';

import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locatonController = TextEditingController();
  Stream<QuerySnapshot>? expenseStream;

  @override
  void initState() {
    super.initState();
    getOnLoad();
  }

  getOnLoad() async {
    expenseStream = await DatabaseMethods().getDetails();
    setState(() {});
  }

  Widget allDetails() {
    return StreamBuilder(
      stream: expenseStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Name: ${ds['Name']}",
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                nameController.text = ds['Name'];
                                ageController.text = ds['Age'];
                                locatonController.text = ds['Location'];

                                editDetails(ds["Id"]);
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.lightBlue,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await DatabaseMethods().deleteDetails(ds["Id"]);
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Text("Amount:    ${ds['Amount']}",
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text("Expense or Income: ${ds['Status']}",
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyForm()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            },
            icon: const Icon(
              Icons.person,
              size: 40,
              color: Colors.blue,
            )),
        title: const Text(
          'HomeScreen',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(child: allDetails()),
          ],
        ),
      ),
    );
  }

// Edit Function
  Future editDetails(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.cancel)),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Edit Form',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                CustomTextfield(hinttext: 'Name', controller: nameController),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Age',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                CustomTextfield(hinttext: 'Age', controller: ageController),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Location',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                CustomTextfield(
                    hinttext: 'Location...', controller: locatonController),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> updateDetails = {
                        "Name": nameController.text,
                        "Age": ageController.text,
                        "Location": locatonController.text,
                        "Id": id,
                      };
                      await DatabaseMethods()
                          .updateDetails(id, updateDetails)
                          .then((value) {
                        Navigator.pop(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ));
}



























// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:myapp/form.dart';
// import 'package:myapp/service/database.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   Stream? expansestream;
//   getontheload()async{
//     expansestream=await DatabaseMethods().getDetails();
//     setState(() {

//     });
//   }
//   @override
//   void initState(){
//     getontheload();
//     super.initState();
//   }
//   Widget allDetails() {
//     return StreamBuilder(
//         stream: expansestream,
//         builder: (context, AsyncSnapshot snapshot) {
//           return snapshot.hasData
//               ? ListView.builder(
//                   itemCount: snapshot.data.docs.length,
//                   itemBuilder: (context, index) {
//                     DocumentSnapshot ds = snapshot.data.docs[index];
//                     return Container(
//                       margin:const EdgeInsets.only(bottom: 10),

//                       child: Material(
//                         elevation: 5,
//                         borderRadius: BorderRadius.circular(20),
//                         child: Container(
//                             padding: const EdgeInsets.all(20),
//                             width: MediaQuery.of(context).size.width,
//                             decoration: const BoxDecoration(
//                               color: Colors.white,
//                             ),
//                             child:  Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Item Name: ${ds['Item Name']}",
//                                     style: const TextStyle(
//                                         color: Colors.blue,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold)),
//                                 Text("Amount:    ${ds['Amount']}",
//                                     style: const TextStyle(
//                                         color: Colors.blue,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold)),
//                                 Text("Expense or Income  ${ds['Status']}",
//                                     style: const TextStyle(
//                                         color: Colors.blue,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold)),
//                               ],
//                             )),
//                       ),
//                     );
//                   })
//               : Container();
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => const MyForm()));
//         },
//         backgroundColor: Colors.blue,
//         child: const Icon(Icons.add),
//       ),
//       appBar: AppBar(
//         title: const Text(
//           'Track your Expanse',
//           style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         child:  Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             children: [

//               Expanded(child: allDetails())
//             // body: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 10),
// //         child: allDetails(),
// //       ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// below is correct code
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:myapp/form.dart';
// import 'package:myapp/service/database.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   Stream<QuerySnapshot>? expansestream;

//   @override
//   void initState() {
//     super.initState();
//     getDetailsStream();
//   }

//   getDetailsStream() async {
//     expansestream = await DatabaseMethods().getDetails();
//     setState(() {});
//   }

//   Widget allDetails() {
//     return StreamBuilder(
//       stream: expansestream,
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return const Center(child: Text("Error loading data"));
//         } else if (snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text("No data available"));
//         } else {
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               DocumentSnapshot ds = snapshot.data!.docs[index];
//               return Material(
//                 elevation: 5,
//                 borderRadius: BorderRadius.circular(20),
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   width: MediaQuery.of(context).size.width,
//                   decoration: const BoxDecoration(color: Colors.white),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
// Text(
//   "Item Name: ${ds['Item Name']}",
//   style: const TextStyle(
//     color: Colors.blue,
//     fontSize: 16,
//     fontWeight: FontWeight.bold,
//   ),
// ),
// Text(
//   "Amount: ${ds['Amount']}",
//   style: const TextStyle(
//     color: Colors.blue,
//     fontSize: 16,
//     fontWeight: FontWeight.bold,
//   ),
// ),
// Text(
//   "Expense/Income: ${ds['Status']}"
//   ,

//   style: const TextStyle(
//     color: Colors.blue,
//     fontSize: 16,
//     fontWeight: FontWeight.bold,
//   ),
// ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const MyForm()),
//           );
//         },
//         backgroundColor: Colors.blue,
//         child: const Icon(Icons.add),
//       ),
//       appBar: AppBar(
//         title: const Text(
//           'Track your Expanse',
//           style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: allDetails(),
//       ),
//     );
//   }
// }
