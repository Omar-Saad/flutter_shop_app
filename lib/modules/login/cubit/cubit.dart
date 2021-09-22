import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/models/login_model.dart';
import 'package:flutter_shop_app/modules/login/cubit/states.dart';
import 'package:flutter_shop_app/shared/network/end_points.dart';
import 'package:flutter_shop_app/shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>{
  ShopLoginCubit() : super(ShopLoginInitialState());

  ShopLoginModel loginModel;

  static ShopLoginCubit get (context)=> BlocProvider.of(context);

  void userLogin({
  @required String email,
    @required String password,
}){
    emit(ShopLoginLoadingState());

    DioHelper.postData(
       pathUrl: LOGIN,
       data: {
         'email': email,
         'password': password,
       }).then((value) {
         print(value.data);
         loginModel = ShopLoginModel.fromJson(value.data);
         print('daata ${loginModel.message}');


         emit(ShopLoginSuccessState(loginModel));
       }).catchError((error){
     print(email.toString());
     emit(ShopLoginErrorState(error));
   });
  }

  //to change visibility of text form field password
  bool isPasswordVisible = true;
  IconData suffixIcon = Icons.visibility_outlined;
  void changePasswordVisibility(){
    isPasswordVisible = !isPasswordVisible;

    suffixIcon = isPasswordVisible ?
    Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(ShopChangePasswordVisibilityState());
  }

}