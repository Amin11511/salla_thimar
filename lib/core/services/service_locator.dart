import 'package:get_it/get_it.dart';

import '../../features/shared/controller/countries/cubit.dart';
import '../../features/shared/controller/upload_attachment/attachment_cubit.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void init() {
    sl.registerFactory(() => CountriesCubit());
    sl.registerFactory(() => UploadAttachmentCubit());
  }
}
