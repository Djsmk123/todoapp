import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todoapp/editcontroller.dart';
final _fireStore = FirebaseFirestore.instance;
class ControllerState extends GetxController {
 Rx<TextEditingController> newTaskController=TextEditingController().obs;
 var textController= Get.put(EditContoller());
 var taskList=<Widget>[].obs;
 var isMobile=false.obs;
 var width=1366.obs;
 addList({text,isEdit,isSave,index}){
  return Padding(padding: isMobile.value?const EdgeInsets.all(8):EdgeInsets.fromLTRB(width.value*0.1, 20, width.value*0.08 , 20),
   child: Material(
    elevation: 10,
    color: Colors.white,
    shadowColor: Colors.black,
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
     height: 60,
     child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Row(
         children: [
           IconButton(icon: const Icon(FontAwesomeIcons.checkCircle,
            size: 20,
           ),
            onPressed: (){
            if(textController.addController[int.parse(index)-1].text.isEmpty || textController.addController[int.parse(index)-1]==text)
             {
              textController.isEditText[int.parse(index)-1]=false;
             }
            else {
             _fireStore.collection('task').doc('task$index').update({
              "taskname": textController.addController[int.parse(index) - 1].text
             });
             Get.snackbar(
              "Saved",
              "Successfully Edit",
              icon: const Icon(FontAwesomeIcons.checkCircle, color: Colors.white),
              snackPosition: SnackPosition.BOTTOM,
             );
            }
            },
           ),
           Obx(
             ()=>SizedBox(
              width: 220,
              child: textController.isEditText[int.parse(index)-1]?Obx(
                  ()=>TextField(
                 controller:  textController.addController[int.parse(index)-1],
                ),
              ):Text(text,overflow: TextOverflow.ellipsis,style: const TextStyle(
               fontSize: 20,
               fontWeight: FontWeight.w300,
              ),
              ),
             ),
           ),
         ],
       ),
       Row(
        children: [
         IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(FontAwesomeIcons.edit, size: 20,), onPressed: () {
          textController.isEditText[int.parse(index)-1]?textController.isEditText[int.parse(index)-1]=false:textController.isEditText[int.parse(index)-1]=true;
         },
         ),
         IconButton(
          icon: const Icon(FontAwesomeIcons.trashAlt,size: 20,), onPressed: () {
          _fireStore.collection('task').doc('task$index').delete();
         },
         ),
        ],
       )
      ],
     ),
    ),
   ),
  );
 }
}
