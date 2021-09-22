import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/layout/home_layout.dart';
import 'package:flutter_shop_app/shared/components/components.dart';
import 'package:flutter_shop_app/shared/components/constants.dart';
import 'package:flutter_shop_app/shared/network/local/cache_helper.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (BuildContext context) => ShopRegisterCubit(),
        child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
          listener: (context, state) {
            if (state is ShopRegisterSuccessState) {
              if (state.loginModel.status) {
                CacheHelper.setData(
                        key: 'token', value: state.loginModel.data.token)
                    .then((value) {
                  token = state.loginModel.data.token;
                  navigateAndFinish(context: context, widget: HomeLayout());
                });
              } else {
                showToast(
                    message: state.loginModel.message,
                    state: ToastStates.ERROR);
              }
            }
          },
          builder: (context, state) {
            var cubit = ShopRegisterCubit.get(context);
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Register now to explore our hot offers',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            controller: nameController,
                            type: TextInputType.text,
                            validtor: (String value) {
                              if (value.isEmpty) return 'Required Field';
                              return null;
                            },
                            label: 'Name',
                            prefixIcon: Icons.person),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validtor: (String value) {
                              if (value.isEmpty) return 'Required Field';
                              return null;
                            },
                            label: 'Email Address',
                            prefixIcon: Icons.email_outlined),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            isPassword: cubit.isPasswordVisible,
                            validtor: (String value) {
                              if (value.isEmpty) return 'Required Field';
                              return null;
                            },
                            label: 'Password',
                            prefixIcon: Icons.lock_open_outlined,
                            suffixIcon: cubit.suffixIcon,
                            onSuffixPressed: () {
                              cubit.changePasswordVisibility();
                            }),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            validtor: (String value) {
                              if (value.isEmpty) return 'Required Field';
                              return null;
                            },
                            label: 'Phone',
                            prefixIcon: Icons.phone),

                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => defaultButton(
                              context: context,
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  cubit.userRegister(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                      name: nameController.text);
                                }
                              },
                              text: 'REGISTER'),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
