import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/layout/cubit/cubit.dart';
import 'package:flutter_shop_app/layout/cubit/states.dart';
import 'package:flutter_shop_app/models/product_model.dart';
import 'package:flutter_shop_app/shared/components/components.dart';
import 'package:flutter_shop_app/shared/style/colors.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsScreen extends StatelessWidget {
   ProductModel productModel;

  ProductDetailsScreen({this.productModel});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessGetProductDetailsState)
          productModel = state.productDetailsModel.data;
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(),
        body: ConditionalBuilder(
          condition: state is! ShopLoadingGetProductDetailsState && productModel!=null,
          builder: (context) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(alignment: AlignmentDirectional.bottomStart, children: [
                  CarouselSlider(
                      items: productModel.images
                          .map((e) => CachedNetworkImage(

                        imageUrl: e.toString(),
                        placeholder:(context, url) =>  buildImagePlaceHolderLoading(width: double.infinity, height: 250.0),
                        errorWidget: (context, url, error) => Icon(Icons.error,),
                        width: double.infinity,
                        // fit: BoxFit.cover,
                      ))
                          .toList(),
                      options: CarouselOptions(
                        height: 250.0,
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(seconds: 1),
                      )),
                  if (productModel.discount != 0)
                    Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          'DISCOUNT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                ]),
                SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${productModel.name}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Text(
                            '${productModel.price}',
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 14.0,
                              color: defaultColor,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          if (productModel.discount != 0)
                            Text(
                              '${productModel.oldPrice}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Spacer(),
                          CircleAvatar(
                            backgroundColor:
                            ShopCubit
                                .get(context)
                                .favourites[productModel.id]
                                ? defaultColor
                                : Colors.grey[400],
                            child: IconButton(
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  ShopCubit.get(context).changeFavourites(productModel.id);
                                }),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        'Product Description',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        '${productModel.description}',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 12.0,),
                      defaultButton(context: context,
                        onPressed: (){},
                        text: 'ADD TO CART',),
                    ],
                  ),
                ),
              ],
            ),
          ),
          fallback: (context) => buildShimmerProductDetailsLoading(),
        ),
      ),
    );
  }
  Widget buildShimmerProductDetailsLoading()=>Shimmer.fromColors(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[400],
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 250.0,
          color: defaultColor,
        ),
        SizedBox(
          height: 12.0,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 20.0,
                    color: defaultColor,
                  ),
                  Spacer(),
                  CircleAvatar(),
                ],
              ),
              SizedBox(height: 16.0,),
              Container(
                width: double.infinity,
                height: 20.0,
                color: defaultColor,
              ),
              SizedBox(height: 10.0,),
              Container(
                width: double.infinity,
                height: 20.0,
                color: defaultColor,
              ),
              SizedBox(height: 5.0,),
              Container(
                width: double.infinity,
                height: 20.0,
                color: defaultColor,
              ),

              SizedBox(height: 5.0,),
              Container(
      width: double.infinity,
      height: 20.0,
      color: defaultColor,
    ),
              SizedBox(height: 5.0,),
              Container(
                width: double.infinity,
                height: 20.0,
                color: defaultColor,
              ),

            ],
          ),
        ),
      ],
    ),
  ),);
}
