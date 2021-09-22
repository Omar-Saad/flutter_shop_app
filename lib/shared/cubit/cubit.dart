import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/shared/cubit/states.dart';
import 'package:flutter_shop_app/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  //switch between light and dark mode
  bool isDark = true;
  void changeMode({bool isDark}) {
    if (isDark != null) {
      this.isDark = isDark;
      emit(AppChangeModeState());
    }
    else {
      //change current app mode and save it in sharedpref
      this.isDark = !this.isDark;
      CacheHelper.setData(key: 'isDark', value: this.isDark).then((value) {
        emit(AppChangeModeState());
      }).catchError((onError) {

      });
    }
  }
}

