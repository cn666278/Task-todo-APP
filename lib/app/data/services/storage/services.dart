import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:youtube_task_app/app/core/utils/keys.dart';

class StorageService extends GetxService{
  late GetStorage _box;
  Future<StorageService> init() async{
    _box = GetStorage();
    // await _box.write(taskKey, []); //show the empty task card when beginning

    //check if we already have data store in our local storage, with the key we defined, we will skip this line:
    //if we don't have any data related to our key(taskKey),we will write the empty list[] to our local storage
    await _box.writeIfNull(taskKey, []); //keep all the current task cards
    return this;
  }

  T read<T>(String key){
    return _box.read(key);
  }

  void write(String key, dynamic value) async{
    await _box.write(key, value);
  }
}