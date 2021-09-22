import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/layout/cubit/cubit.dart';
import 'package:flutter_shop_app/layout/cubit/states.dart';
import 'package:flutter_shop_app/models/categories_model.dart';
import 'package:flutter_shop_app/modules/categories_details/categories_details_screen.dart';
import 'package:flutter_shop_app/shared/components/components.dart';
import 'package:flutter_shop_app/shared/style/colors.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      builder: (context, state) {
        return ConditionalBuilder(
            condition: ShopCubit.get(context).categoriesModel != null,
            builder: (context) =>  Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildCategoriesItem(
                      ShopCubit.get(context).categoriesModel.data.data[index],context),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20.0,
                  ),
                  itemCount:
                  ShopCubit.get(context).categoriesModel.data.data.length),
            ),
        fallback:(context) =>  buildShimmerLoading(),);
      },
      listener: (context, state) {},
    );
  }

  Widget buildCategoriesItem(DataModel model ,context) => InkWell(
    child: Stack(
          children: [
            CachedNetworkImage(
            //  image: NetworkCachedNetworkImage(model.image),
              imageUrl: model.image,
              height: 120.0,
              width: double.infinity,
              fit: BoxFit.cover,

            ),
            Container(
              alignment: AlignmentDirectional.center,
              width: double.infinity,
              height: 120.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                model.name,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24.0),
              ),
            )
          ],
        ),
    onTap: (){
      ShopCubit.get(context).getCategoriesDetails(model.id);
      navigate(context: context, widget: CategoriesDetailsScreen());
    },
  );

  Widget buildShimmerLoading() => Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[400],
        child: ListView.separated(
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: defaultColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
            separatorBuilder: (context, index) => SizedBox(
                  height: 16.0,
                ),
            itemCount: 4),
      );
}
