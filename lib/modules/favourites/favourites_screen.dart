import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/layout/cubit/cubit.dart';
import 'package:flutter_shop_app/layout/cubit/states.dart';
import 'package:flutter_shop_app/shared/components/components.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        builder: (context, state) {
          return ConditionalBuilder(
              builder: (BuildContext context) =>
                  ConditionalBuilder(condition: ShopCubit.get(context).favouritesModel.data.data.length!=0,
                    builder: (context) => ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => buildListProductItem(
                          context,
                          ShopCubit.get(context)
                              .favouritesModel
                              .data
                              .data[index]
                              .product),
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20.0),
                        child: Container(
                          width: double.infinity,
                          height: 2.0,
                          color: Colors.grey[300],
                        ),
                      ),

                      itemCount:
                      ShopCubit.get(context).favouritesModel.data.data.length),
                  fallback: (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite , color: Colors.grey,size: 50.0,),
                        SizedBox(height: 5.0,),
                        Text('You didn\'t add any favourites yet',style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 1,
                        ),),
                      ],
                    ),
                  ),),
              condition:
              (state is! ShopLoadingGetFavouritesState && ShopCubit.get(context).favouritesModel!=null),
              fallback: (context) =>
                  buildListShimmerLoading() // Center(child: CircularProgressIndicator()),
              );
        },
        listener: (context, state) {});
  }


}


