
import 'package:get/get.dart';
import 'package:youtube_task_app/app/data/providers/task/provider.dart';
import 'package:youtube_task_app/app/data/services/storage/repository.dart';
import 'package:youtube_task_app/app/modules/home/controller.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(
      taskRepository: TaskRepository(
        taskProvider: TaskProvider(),
      ),
    ));
  }
}