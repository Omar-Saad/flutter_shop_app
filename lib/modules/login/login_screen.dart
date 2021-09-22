import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/layout/home_layout.dart';
import 'package:flutter_shop_app/modules/login/cubit/cubit.dart';
import 'package:flutter_shop_app/modules/login/cubit/states.dart';
import 'package:flutter_shop_app/modules/register/register_screen.dart';
import 'package:flutter_shop_app/shared/components/components.dart';
import 'package:flutter_shop_app/shared/components/constants.dart';
import 'package:flutter_shop_app/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (BuildContext context) => ShopLoginCubit(),
        child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
          listener: (context, state) {
            if (state is ShopLoginSuccessState) {
              if (state.loginModel.status) {
                CacheHelper.setData(key: 'token', value: state.loginModel.data.token).then((value) {
                  token = state.loginModel.data.token;
                  navigateAndFinish(context: context, widget: HomeLayout());
                });
              }
              else {
                showToast(
                    message: state.loginModel.message,
                    state: ToastStates.ERROR);
              }
            }
          },
          builder: (context, state) {
            var cubit = ShopLoginCubit.get(context);
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
                          'Welcome Back!',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Login now to explore our hot offers',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        SizedBox(
                          height: 30.0,
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
                            onFieldSubmitted: (value) {
                              cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            },
                            prefixIcon: Icons.lock_open_outlined,
                            suffixIcon: cubit.suffixIcon,
                            onSuffixPressed: () {
                              cubit.changePasswordVisibility();
                            }),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                              context: context,
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  cubit.userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: 'LOGIN'),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account ?'),
                            defaultTextButton('REGISTER', () {
                              navigate(context: context, widget: RegisterScreen());
                            }),
                          ],
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
