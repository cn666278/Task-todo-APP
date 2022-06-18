
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:youtube_task_app/app/data/models/task.dart';
import 'package:youtube_task_app/app/modules/home/controller.dart';
import 'package:youtube_task_app/app/core/utils/extensions.dart';
import 'package:youtube_task_app/app/modules/home/widgets/add_card.dart';
import 'package:youtube_task_app/app/modules/home/widgets/add_dialog.dart';
import 'package:youtube_task_app/app/modules/home/widgets/task_card.dart';
import 'package:youtube_task_app/app/modules/report/view.dart';

import '../../core/values/colors.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () => IndexedStack(
            index: controller.tabIndex.value,
            children: [
              SafeArea(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0.wp), //wp form extension.dart
                      child: Text(
                        "My List",
                        style: TextStyle(
                          fontSize: 24.0.sp,  //sp form extension.dart
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Obx(
                          () => GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            ...controller.tasks
                                .map((element) => LongPressDraggable( //添加task card长按拖动功能
                                    data: element,
                                    onDragStarted: () => controller.changeDeleting(true),
                                    onDraggableCanceled: (_,__) => controller.changeDeleting(false),
                                    onDragEnd: (_) => controller.changeDeleting(false),
                                    feedback: Opacity(
                                      opacity: 0.8,
                                      child: TaskCard(task: element),
                                    ),
                                    child: TaskCard(task: element)))
                                .toList(),
                          AddCard()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ReportPage(),
            ],
        ),
      ),
      floatingActionButton: DragTarget<Task>(builder: (_,__,___){  // _,__,___为匿名化
          return Obx(
                () => FloatingActionButton(
                  backgroundColor: controller.deleting.value ? Colors.red : blue,
                  onPressed: () {
                    if(controller.tasks.isNotEmpty){
                      Get.to(() => AddDialog(),transition: Transition.downToUp);
                    } else { // show this when task type is empty
                      EasyLoading.showInfo('Please create your task type');
                    }
                  },
                  // add button on bottom-right, when you drag the task card, it will become a delete button
                  child: Icon(controller.deleting.value ? Icons.delete : Icons.add),
            ),
          );
        },
        onAccept: (Task task){
          controller.deleteTask(task);
          EasyLoading.showSuccess('Delete Success');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(
              () => BottomNavigationBar(
                onTap: (int index) => controller.changeTabIndex(index),
                currentIndex: controller.tabIndex.value,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Padding(
                      padding: EdgeInsets.only(right: 15.0.wp),
                      child: const Icon(
                        Icons.apps,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Report',
                    icon: Padding(
                      padding: EdgeInsets.only(left: 15.0.wp),
                      child: const Icon(
                        Icons.data_usage,
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
