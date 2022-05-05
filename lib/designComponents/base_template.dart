import 'package:flutter/material.dart';
import 'package:iostest/constants.dart';
import 'package:iostest/designComponents/space.dart';
import 'package:iostest/extensions/extension_color.dart';

import '../designComponents/card_task.dart';


class BaseWidget extends StatefulWidget {
  const BaseWidget(
      {Key? key,
      this.leadingIcon,
      this.trailingIcon,
      this.titleWidget,
      this.titleText,
      this.body,
      this.bodyTitleWidget, this.rightIconPressed})
      : super(key: key);
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? titleWidget;
  final String? titleText;
  final bool? removeAllSpacing = false;
  final Widget? body;
  final Widget? bodyTitleWidget;
  final VoidCallback? rightIconPressed;

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: HexColor.fromHex('#53798a'),
        backgroundColor: Colors.transparent,

        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: spacing_small),
          child: widget.leadingIcon ??
              CircleAvatar(
                radius: 30,
                child: const Icon(
                  Icons.widgets_outlined,
                  color: Colors.white,
                ),
                backgroundColor: kPrimary,
              ),
        ),
        title: widget.titleWidget ??
            Text(
              widget.titleText ?? 'Task Toast',
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){widget.rightIconPressed!.call();},
              child: CircleAvatar(

                child: widget.trailingIcon ?? Image.asset('assets/images/profile.png'),
                    //  const Icon(
                    //
                    //   Icons.account_circle,
                    //    size: 30,
                    // ),
                foregroundColor: kPrimary,
                backgroundColor: Colors.white,
                radius: 30,
              ),
            ),
          )
        ],
      ),
      body: widget.body ?? buildBody(),
    );
  }

  Widget buildBody() {
    var height = AppBar().preferredSize.height;
    return Container(
      margin: const EdgeInsets.all(spacing_small),
      child: Stack(alignment: Alignment.center, children: [
        SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // SizedBox(
              //   height: height,
              // ),
              //  const VSpace(size: spacing_xx_large),
              widget.titleWidget ?? title_widget(),
              const VSpace(size: spacing_tiny),
              subTitleWidget(),
              const VSpace(size: spacing_small),
              timeLineWidget(),
              const VSpace(size: spacing_small),
              // const CardTaskWidget(
              //   title: 'Test',
              //   date: '17 oct 2022',
              //   time: '8:00',
              //   cardBackground: Colors.yellow,
              //   status: 'Added',
              //  // chipItems: ['School', 'Everyday'],
              // ),
              // const VSpace(size: spacing_small),
              // const CardTaskWidget(
              //   title: 'dagfgfadg',
              //   date: '17 oct 2022',
              //   time: '8:00',
              //   cardBackground: Colors.cyan,
              //   status: 'Added',
              //   //chipItems: ['School', 'Everyday'],
              // ),
              // const VSpace(size: spacing_small),
              // const CardTaskWidget(
              //   title: 'dfadfgfagfdag',
              //   date: '17 oct 2022',
              //   time: '8:00',
              //   cardBackground: Colors.pink,
              //   status: 'Added',
              //   //chipItems: ['School', 'Everyday'],
              // ),
              // const VSpace(size: spacing_small),
              // const CardTaskWidget(
              //   title: 'gadfgdfdgadg',
              //   date: '17 oct 2022',
              //   time: '8:00',
              //   cardBackground: Colors.deepPurpleAccent,
              //   status: 'Added',
              //   //chipItems: ['School', 'Everyday'],
              // ),
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),topRight: Radius.circular(5.0)),
                  color: Colors.pink,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.01),
                        Theme.of(context)
                            .scaffoldBackgroundColor

                      ])),
            )),
        Positioned(
            bottom: 40.0,

              child: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(24.0),color: kPrimary),
                  child: const Text.rich(TextSpan(children: [

                    WidgetSpan(child: Icon(Icons.add,size: 21.0,color: Colors.white,)),
                    TextSpan(text: 'Add Task',style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.w500,))

                  ]))),
            )
      ]),
    );
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
