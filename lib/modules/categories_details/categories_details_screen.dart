import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/layout/cubit/cubit.dart';
import 'package:flutter_shop_app/layout/cubit/states.dart';
import 'package:flutter_shop_app/shared/components/components.dart';

class CategoriesDetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit , ShopStates>(
     builder: (context, state) {
       return   Scaffold(
         appBar: AppBar(),
         body:  ConditionalBuilder(
           builder: (context) => ListView.separated(
               physics: BouncingScrollPhysics(),
               itemBuilder: (context, index) => buildListProductItem(
                   context,
                   ShopCubit.get(context)
                       .categoriesDetailsModel.data.data[index]),
               separatorBuilder: (context, index) => Padding(
                 padding: const EdgeInsetsDirectional.only(start: 20.0),
                 child: Container(
                   width: double.infinity,
                   height: 2.0,
                   color: Colors.grey[300],
                 ),
               ),

               itemCount:
               ShopCubit.get(context).categoriesDetailsModel.data.data.length),
           condition: ShopCubit.get(context).categoriesDetailsModel!=null
           && state is! ShopLoadingGetCategoriesDetailsState,
           fallback: (context) => buildListShimmerLoading(),

         ),
       );
     },
      listener: (context, state) {

      },
    );
  }
}
