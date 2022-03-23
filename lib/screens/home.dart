import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iostest/designComponents/base_template.dart';
import 'package:iostest/designComponents/space.dart';
import 'package:iostest/extensions/extension_color.dart';
import 'package:iostest/model/task_model.dart';
import 'package:iostest/provider/taskprovider.dart';
import 'package:provider/provider.dart';

import '../designComponents/card_task.dart';
import '../constants.dart';
import 'new_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  double animationDuration = 0.0;

  @override
  void initState() {
    super.initState();
    const int totalDuration = 1500;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: totalDuration));
    _animation= Tween(begin: 0.0,end: 1.0).animate(_animationController);
     _animationController.forward();

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(body: buildBody());
  }

  Widget title_widget() {
    return Text(
      'Welcome Back!',
      style: TextStyle(
          color: kPrimary,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 16),
    );
  }

  Widget subTitleWidget() {
    return Text(
      'Here\'s Update Today',
      style: TextStyle(
          color: kPrimary,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 22),
    );
  }

  Widget buildBody() {
    var height = AppBar().preferredSize.height;
    return Container(
      margin: const EdgeInsets.all(spacing_small),
      child:
          Stack(alignment: Alignment.center, fit: StackFit.expand, children: [
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              title_widget(),
              const VSpace(size: spacing_tiny),
              subTitleWidget(),
              const VSpace(size: spacing_small),
              timeLineWidget(),
              const VSpace(size: spacing_small),
              const VSpace(size: spacing_small),
              _todoItems(),
              const VSpace(size: spacing_small),
            ],
          ),
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0)),
                  color: Colors.pink,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.01),
                        Theme.of(context).scaffoldBackgroundColor
                      ])),
            )),
        Positioned(
            bottom: 40.0,
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewTaskWidget()),
                  );
                },
                child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        color: kPrimary),
                    child: const Text.rich(TextSpan(children: [
                      WidgetSpan(
                          child: Icon(
                        Icons.add,
                        size: 21.0,
                        color: Colors.white,
                      )),
                      TextSpan(
                          text: 'Add Task',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ))
                    ])))))
      ]),
    );
  }

  Future getProjectDetails() async {
    context.select((TaskProvider taskProvider) => taskProvider.getItems());
    var tasks = context.watch<TaskProvider>().taskList;
    return tasks;
  }

  Widget _todoItems() {
    return FadeTransition(
     opacity: _animationController,

      child: FutureBuilder(
          future: getProjectDetails(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return const Center(
                  child: Text('An error occured'),
                );
              } else {
                return AnimatedList(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    initialItemCount: snapshot.data.length,
                    physics: const NeverScrollableScrollPhysics(),
                    // itemCount: snapshot.data.length,
                    itemBuilder: (context, index, animation) {
                      snapshot.data.length;

                      return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: const Offset(0, 0),
                          ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.bounceIn,
                              reverseCurve: Curves.bounceOut)),
                          child: CardTaskWidget(
                            title: snapshot.data[index].title,
                            //date:  DateFormat('dd/MM/yyyy').parse(snapshot.data[index].dateTarget).toString(),
                            time: DateTime.now().toLocal().toString(),
                            cardBackground: HexColor.fromHex(snapshot.data[index].colorCode),
                            status: snapshot.data[index].title,
                            chipItems: ['School', 'Everyday'],
                            onTapDelete: () async {
                              print('Delete this item');

                              await context.read<TaskProvider>().deleteItem(index);
                             await context.read<TaskProvider>().getItems();


                            },
                          ));
                    });
              }
            }
          }),
    );
  }

  Widget timeLineWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(kPrimary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              child: Text('Today')),
        ),
        HSpace(size: spacing_tiny),
        Expanded(
          child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(kPrimary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              child: Text('Upcoming')),
        ),
        HSpace(size: spacing_tiny),
        Expanded(
          child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(kPrimary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              child: Text('Done')),
        ),
      ],
    );
  }
}
