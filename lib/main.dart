import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/bloc_observer.dart';
import 'package:flutter_shop_app/layout/cubit/cubit.dart';
import 'package:flutter_shop_app/layout/home_layout.dart';
import 'package:flutter_shop_app/modules/login/login_screen.dart';
import 'package:flutter_shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:flutter_shop_app/shared/components/constants.dart';
import 'package:flutter_shop_app/shared/cubit/cubit.dart';
import 'package:flutter_shop_app/shared/cubit/states.dart';
import 'package:flutter_shop_app/shared/network/local/cache_helper.dart';
import 'package:flutter_shop_app/shared/network/remote/dio_helper.dart';
import 'package:flutter_shop_app/shared/style/themes.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  DioHelper.init();

  await CacheHelper.init();
  Widget startWidget;
  bool isDark = CacheHelper.getData(key: 'isDark');
  bool isOnBoarding = CacheHelper.getData(key: 'isOnBoarding');
  token = CacheHelper.getData(key: 'token');
  print('token : $token');
  if (isOnBoarding != null) {
    if (token != null)
      startWidget = HomeLayout();
    else
      startWidget = LoginScreen();
  } else
    startWidget = OnBoardingScreen();

  runApp(MyApp(isDark: isDark, startWidget: startWidget));

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final bool isDark;
  final Widget startWidget;

  MyApp({
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()..changeMode(isDark: isDark),
        ),
        BlocProvider(
          create: (context) {
            print('called provider');
            return ShopCubit()
              ..getHomeData()
              ..getCategoriesData()
              ..getFavourites()
              ..getUserProfile();
          }
        )
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop App',
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: startWidget,
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
