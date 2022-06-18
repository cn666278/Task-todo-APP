import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:youtube_task_app/app/core/utils/extensions.dart';
import 'package:youtube_task_app/app/modules/home/controller.dart';
import 'package:youtube_task_app/app/widgets/icons.dart';

import '../../../core/values/colors.dart';
import '../../../data/models/task.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var squareWidth = Get.width - 12.0.wp;
    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      child: InkWell( //添加摁扭动效InkWell
        onTap: () async {
          await Get.defaultDialog(
            titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
            radius: 5,
            title: 'Task Type',
            content: Form(
              key: homeCtrl.formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                    child: TextFormField(
                      controller: homeCtrl.editCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                      ),
                      validator: (value){
                        if(value == null || value.trim().isEmpty) {
                          //如果task title输入为空则提示
                          return "Please enter your title";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                    /* Wrap为task type 下的图标 */
                    child: Wrap(
                      spacing: 2.0.wp, //调整图标间隔
                      children: icons.map((e) => Obx(() {
                        final index = icons.indexOf(e);
                        return ChoiceChip(
                          selectedColor: Colors.grey[200],
                          pressElevation: 0,
                          backgroundColor: Colors.white,
                          label: e,
                          selected: homeCtrl.chipIndex.value == index,
                          onSelected: (bool selected){
                            homeCtrl.chipIndex.value =
                                selected ? index : 0; //点击list title选中图标后赋值index，否则赋值0
                          },
                        );
                      })).toList(),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      minimumSize: const Size(100, 40), //confirm 摁扭大小
                    ),
                      onPressed: () {
                        if(homeCtrl.formKey.currentState!.validate()){
                          int icon = icons[homeCtrl.chipIndex.value].icon!.codePoint;
                          String color = icons[homeCtrl.chipIndex.value].color!.toHex();
                          var task = Task(
                            title: homeCtrl.editCtrl.text,
                            icon: icon,
                            color: color,
                          );
                          Get.back();
                          homeCtrl.addTask(task)
                              ? EasyLoading.showSuccess("Create success")
                              : EasyLoading.showError("Duplicated Task"); //we don't allow to add the same task card
                        }
                      },
                      child: const Text("Confirm"),
                  ),
                ],
              ),
            ),
          );
          homeCtrl.editCtrl.clear();
          homeCtrl.changeChipIndex(0); //自动关闭页面当点击task type 窗口之外时
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [8, 4],
          child: Center(
            child: Icon(
              Icons.add,
              size: 10.0.wp,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
