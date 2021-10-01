import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:todoapp/controller.dart';
import 'package:todoapp/editcontroller.dart';
final _fireStore = FirebaseFirestore.instance;
// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  var controller = Get.put(ControllerState());
  var textController= Get.put(EditContoller());
  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.width>480?controller.isMobile.value=false:controller.isMobile.value=true;
    controller.width.value=MediaQuery.of(context).size.width.toInt();
    return Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20.0),
    child: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    ),
    ),
    body: SingleChildScrollView(
    child:Center(
    child: Obx(
      ()=> Column(
      children: [
      const Text("TO DO App",style: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 40,
      color: Color(0XFF101010),
      ),
      ),
       const SizedBox(height: 20,),
      Padding(
      padding:  controller.isMobile.value?const EdgeInsets.all(10): EdgeInsets.fromLTRB(controller.width.value.toDouble()*0.1, 20, controller.width.value.toDouble()*0.08, 20),
      child: Row(
      mainAxisAlignment:MainAxisAlignment.spaceBetween,
      children: [
      ConstrainedBox(
      constraints: const BoxConstraints.tightFor(
      height:60,
      ),
      child:SizedBox(
      width: controller.width.value.toDouble()*0.7,
      child: Material(
      elevation: 10,
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Obx(
          ()=>TextFormField(
            controller: controller.newTaskController(),
        decoration: InputDecoration(
        isDense: true,
        enabledBorder:OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white),
        gapPadding: 20,
        ),
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white),
        gapPadding: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(
        horizontal: 20, vertical: 20),
        hintText: 'Type Something here...',
        hintStyle: const TextStyle(
        fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        )
        ),
        ),
      ),
      ),
      ),
      ),
      SizedBox(
      height:50,
      child:FloatingActionButton(
        onPressed: (){
            var index=(controller.taskList.length+1).toString();
            _fireStore.collection('task').doc('task$index').set({"taskname":controller.newTaskController().text,"time":Timestamp.now()});
            controller.newTaskController().clear();
          },
        backgroundColor: Colors.black,
        elevation: 10,
        child:  const Icon(Icons.add,
        color: Colors.white,
        size:40,
        ),
        ),
      ),
      ],

      ),
      ),
      buildGetBuilder(),
      ],
      ),
    ),
    )
    ),
    );
    }
// To Stream List of task from Firebase Firestore
  GetBuilder<ControllerState> buildGetBuilder() {
    return GetBuilder<ControllerState>(builder: (controller){
    return StreamBuilder<QuerySnapshot>(
    stream: _fireStore.collection('task').orderBy('time',descending: true).snapshots(),
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return const Center(
    child: CircularProgressIndicator(
    backgroundColor: Colors.lightBlueAccent,
    ),
    );
    }
    final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
    controller.taskList.clear();
    textController.isEditText.clear();
    textController.addController.clear();
    for (var items in documents) {
      var index=items.id.split("task");
      controller.taskList.add(controller.addList(text: items['taskname'],isEdit: false,isSave: false,index: index[1]));
    textController.isEditText.add(false);
    textController.addController.add(TextEditingController());
    }
    return ListView(
      shrinkWrap: true,
      children: controller.taskList,
    );
    }
    );
    }
    );
  }
  }
