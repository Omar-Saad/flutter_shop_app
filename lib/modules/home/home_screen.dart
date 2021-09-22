import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/layout/cubit/cubit.dart';
import 'package:flutter_shop_app/layout/cubit/states.dart';
import 'package:flutter_shop_app/models/categories_model.dart';
import 'package:flutter_shop_app/models/home_model.dart';
import 'package:flutter_shop_app/models/product_model.dart';
import 'package:flutter_shop_app/modules/categories_details/categories_details_screen.dart';
import 'package:flutter_shop_app/modules/product_details/product_details_screen.dart';
import 'package:flutter_shop_app/shared/components/components.dart';
import 'package:flutter_shop_app/shared/style/colors.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(builder: (context, state) {
      return ConditionalBuilder(
           condition:
        ShopCubit
              .get(context)
              .homeModel != null &&
              ShopCubit
                  .get(context)
                  .categoriesModel != null,
          builder: (context) =>
              productsBuilder(ShopCubit
                  .get(context)
                  .homeModel,
                  ShopCubit
                      .get(context)
                      .categoriesModel, context),
          fallback: (context) =>
              buildShimmerLoading()
     //   Center(child: CircularProgressIndicator()),
      );
    }, listener: (context, state) {
      if (state is ShopSuccessChangeFavouritesState) {
        if (!state.changeFavouritesModel.status) {
          showToast(
              message: state.changeFavouritesModel.message,
              state: ToastStates.ERROR);
        }
      }
    });
  }

  Widget productsBuilder(HomeModel model, CategoriesModel categoriesModel,
      BuildContext context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
                items: model.data.banners
                    .map((e) =>
                    CachedNetworkImage(
                      placeholder:(context, url) =>  buildImagePlaceHolderLoading(width: double.infinity, height: 250.0),
                      errorWidget: (context, url, error) => Icon(Icons.error,),
                      width: double.infinity, imageUrl: e.image,
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
            SizedBox(
              height: 10.0,
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w800),
                  ),
                  Container(
                    height: 100.0,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            buildCategoriesItem(
                                categoriesModel.data.data[index],context),
                        separatorBuilder: (context, index) =>
                            SizedBox(
                              width: 5.0,
                            ),
                        itemCount: categoriesModel.data.data.length),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Best Selling',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 1.5,
                mainAxisSpacing: 1.5,
                crossAxisCount: 2,
                childAspectRatio: 1.0 / 1.58,
                
                children: List.generate(
                    model.data.products.length,
                        (index) =>
                        buildProductGridItem(
                            model.data.products[index], context)),
              ),
            ),
          ],
        ),
      );

  Widget buildProductGridItem(ProductModel model, context) =>
      InkWell(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    CachedNetworkImage(

                      imageUrl: model.image,
                      placeholder:(context, url) =>  buildImagePlaceHolderLoading(width: double.infinity, height: 200.0),
                      errorWidget: (context, url, error) => Icon(Icons.error,),
                      width: double.infinity,
                      height: 200.0,
                      //fit: BoxFit.cover,
                    ),
                    if (model.discount != 0)
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Flex(
                  direction: Axis.horizontal,
                  children:[
                    Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            '${model.name}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            )
                          ),
                          height: 36.0,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${model.price}',
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: 14.0,
                                color: defaultColor,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            if (model.discount != 0)
                              Text(
                                '${model.oldPrice}',
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
                                  .favourites[model.id]
                                  ? defaultColor
                                  : Colors.grey[400],
                              child: IconButton(
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    ShopCubit.get(context).changeFavourites(model.id);
                                  }),
                            )
                          ],
                        ),
                        
                        
                      ],
                    ),
                  ),],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          navigate(context: context, widget: ProductDetailsScreen(productModel: model,));
        },
      );

  Widget buildCategoriesItem(DataModel model,context) =>
      InkWell(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CachedNetworkImage(
            //  image: NetworkImage(model.image),
              imageUrl: model.image,
              placeholder:(context, url) =>  buildImagePlaceHolderLoading(width: 160.0, height: 160.0),
              errorWidget: (context, url, error) => Icon(Icons.error,),
              width: 160.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            Container(
                width: 160.0,
                height: 100.0,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Text(
                  model.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0),
                )),
          ],
        ),
        onTap: (){
          ShopCubit.get(context).getCategoriesDetails(model.id);
          navigate(context: context, widget: CategoriesDetailsScreen());
        },
      );

  Widget buildShimmerLoading() =>
      SingleChildScrollView(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[400],
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250.0,
                color: defaultColor,
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                   Container(width: 150.0,height: 30.0,color: defaultColor,),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 100.0,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              Container(
                              //  color: defaultColor,
                                  width: 160.0,
                                  height: 100.0,
                                  alignment: AlignmentDirectional.center,
                                  decoration: BoxDecoration(
                                      color: defaultColor,
                                      borderRadius: BorderRadius.circular(12.0)),
                              ),
                          separatorBuilder: (context, index) =>
                              SizedBox(
                                width: 5.0,
                              ),
                          itemCount: 5),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(width: 150.0,height: 30.0,color: defaultColor,),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: 120.0,
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 1.5,
                        mainAxisSpacing: 1.5,
                        crossAxisCount: 2,
                        childAspectRatio: 1.0 / 1.58,

                        children: List.generate(
                            8,
                                (index) =>
                                    Container(
                                      color: defaultColor,
                                      width: 200.0,
                                      height: 120.0,
                                    ),
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );


}
