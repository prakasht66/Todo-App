import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iostest/helper/task_db.dart';
import 'package:iostest/model/task_model.dart';
import 'package:iostest/provider/taskprovider.dart';
import 'package:iostest/route_name.dart';

import 'package:iostest/screens/home.dart';
import 'package:iostest/screens/new_task.dart';
import 'package:iostest/screens/profile_page.dart';
import 'package:iostest/utils/user_shared_preferences.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Registering the adapter
  Hive.registerAdapter(TaskModelAdapter());

  // Opening the box
  await Hive.openBox('tasks');
  await Hive.openBox('profile');
  TaskDbManger().initDb();
  UserSharedPreference.init();

  runApp(MultiProvider(providers:[
    ChangeNotifierProvider (create: (_) => TaskProvider() ),

  ] , child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(

      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF),backgroundColor: Colors.blueGrey),
      home: const HomePage(),
      routes: {
        newTaskPage : (context) =>  NewTaskWidget(selectedTask: ModalRoute.of(context)?.settings.arguments as TaskModel,),
        profilePage:(context)=> const ProfilePage(),
      } ,
    );
  }
}


