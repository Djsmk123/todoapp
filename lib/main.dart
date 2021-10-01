import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todoapp/home_screen.dart';
void main()
async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
 await Firebase.initializeApp();
  runApp(const Todo());

}
class Todo extends StatelessWidget {
  const Todo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      title: 'T0-D0 App',
      debugShowCheckedModeBanner: false,
      home:HomeScreen(),
    );
  }
}

