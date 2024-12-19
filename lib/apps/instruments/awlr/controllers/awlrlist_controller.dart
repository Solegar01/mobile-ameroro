import 'package:get/get.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/models/awlrlist_model.dart';
import 'package:mobile_ameroro_app/apps/instruments/awlr/repository/awlr_repository.dart';
import 'package:mobile_ameroro_app/apps/widgets/custom_toast.dart';

class AwlrListController extends GetxController with StateMixin {
  final AwlrRepository repository;
  AwlrListController(this.repository);
  RxList<AwlrListModel> listModel = RxList.empty(growable: true);
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    await getAwlrList();
    super.onInit();
  }

  getAwlrList() async {
    change(null, status: RxStatus.loading());
    try {
      listModel.clear();
      await repository.getAwlrList().then((values) {
        if (values.isNotEmpty) {
          for (var val in values) {
            listModel.add(val);
          }
        }
      });
      change(null, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
      msgToast(e.toString());
    }
  }
}
