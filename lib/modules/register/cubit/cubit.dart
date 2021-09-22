import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/models/login_model.dart';
import 'package:flutter_shop_app/modules/login/cubit/states.dart';
import 'package:flutter_shop_app/modules/register/cubit/states.dart';
import 'package:flutter_shop_app/shared/network/end_points.dart';
import 'package:flutter_shop_app/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>{
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  ShopLoginModel loginModel;

  static ShopRegisterCubit get (context)=> BlocProvider.of(context);

  void userRegister({
    @required String name,
  @required String email,
    @required String password,
    @required String phone,

  }){
    emit(ShopRegisterLoadingState());

    DioHelper.postData(
       pathUrl: REGISTER,
       data: {
         'name': name,
         'email': email,
         'password': password,
         'phone': phone,

       }).then((value) {
    //     print(value.data);
         loginModel = ShopLoginModel.fromJson(value.data);
    //     print('daata ${loginModel.message}');

         emit(ShopRegisterSuccessState(loginModel));
       }).catchError((error){
     print(email.toString());
     emit(ShopRegisterErrorState(error));
   });
  }

  //to change visibility of text form field password
  bool isPasswordVisible = true;
  IconData suffixIcon = Icons.visibility_outlined;
  void changePasswordVisibility(){
    isPasswordVisible = !isPasswordVisible;

    suffixIcon = isPasswordVisible ?
    Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(ShopChangeRegisterPasswordVisibilityState());
  }

}