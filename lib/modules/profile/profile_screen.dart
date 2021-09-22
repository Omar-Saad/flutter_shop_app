import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/layout/cubit/cubit.dart';
import 'package:flutter_shop_app/layout/cubit/states.dart';
import 'package:flutter_shop_app/models/login_model.dart';
import 'package:flutter_shop_app/modules/login/login_screen.dart';
import 'package:flutter_shop_app/shared/components/components.dart';
import 'package:flutter_shop_app/shared/network/local/cache_helper.dart';
import 'package:flutter_shop_app/shared/style/colors.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).loginModel != null &&
              state is! ShopLoadingGetUserProfileState ,
          builder: (context) {
            ShopLoginModel loginModel = ShopCubit.get(context).loginModel;

             nameController.text = loginModel.data.name??'';
             emailController.text = loginModel.data.email??'';
             phoneController.text = loginModel.data.phone??'';
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40.0,
                            backgroundImage: CachedNetworkImageProvider(loginModel.data.image,),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loginModel.data.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: 22.0,
                                    ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'points : ${loginModel.data.points}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontSize: 14.0,
                                        ),
                                  ),
                                  SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(
                                    'credit : ${loginModel.data.credit}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontSize: 14.0,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      if(state is ShopLoadingUpdateUserProfileState)
                        LinearProgressIndicator(),
                      if(state is! ShopLoadingUpdateUserProfileState)
                        Container(
                        width: double.infinity,
                        height: 2.0,
                        color: defaultColor.shade300,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultFormField(
                          controller: nameController,
                          type: TextInputType.text,
                          validtor: (String value) {
                            if (value.isEmpty) {
                              return 'Required Field';
                            }
                            return null;
                          },
                          label: 'Name',
                          prefixIcon: Icons.person),
                      SizedBox(
                        height: 16.0,
                      ),
                      defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validtor: (String value) {
                            if (value.isEmpty) {
                              return 'Required Field';
                            }
                            return null;
                          },
                          label: 'Email',
                          prefixIcon: Icons.email),
                      SizedBox(
                        height: 16.0,
                      ),
                      defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          validtor: (String value) {
                            if (value.isEmpty) {
                              return 'Required Field';
                            }
                            return null;
                          },
                          label: 'Password',
                          isPassword: true,
                          prefixIcon: Icons.lock),
                      SizedBox(
                        height: 16.0,
                      ),
                      defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validtor: (String value) {
                            if (value.isEmpty) {
                              return 'Required Field';
                            }
                            return null;
                          },
                          label: 'Phone',
                          prefixIcon: Icons.phone),
                      SizedBox(
                        height: 16.0,
                      ),
                      defaultButton(
                          context: context,
                          onPressed: () {
                            if(formKey.currentState.validate()) {
                              ShopCubit.get(context).updateProfile(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text);
                            }
                          },
                          text: 'UPDATE PROFILE'),
                      SizedBox(
                        height: 16.0,
                      ),
                      defaultButton(
                          context: context,
                          onPressed: () {
                            signOut(context);
                          },
                          text: 'LOGOUT'),
                    ],
                  ),
                ),
              ),
            );
          },
          fallback: (context) => buildShimmerLoadind(),
        );
      },
      listener: (context, state) {
        if(state is ShopSuccessUpdateUserProfileState){
          if(!state.loginModel.status){
            showToast(message: state.loginModel.message, state: ToastStates.ERROR);

          }
        }
      },
    );
  }

  void signOut(context) {
    CacheHelper.removeData(key: 'token').then((value) {
      navigateAndFinish(context: context, widget: LoginScreen());
    });
  }

  Widget buildShimmerLoadind() => Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[400],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180.0,
                        height: 15.0,
                        color: defaultColor,
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 50.0,
                            height: 10.0,
                            color: defaultColor,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Container(
                            width: 50.0,
                            height: 10.0,
                            color: defaultColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                width: double.infinity,
                height: 2.0,
                color: defaultColor.shade300,
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                color: defaultColor,
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                color: defaultColor,
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                color: defaultColor,
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                color: defaultColor,
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                width: double.infinity,
                height: 50.0,
                color: defaultColor,
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                width: double.infinity,
                height: 60.0,
                color: defaultColor,
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                width: double.infinity,
                height: 60.0,
                color: defaultColor,
              ),
            ],
          ),
        ),
      );
}
