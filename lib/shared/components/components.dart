
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_app/layout/cubit/cubit.dart';
import 'package:flutter_shop_app/models/product_model.dart';
import 'package:flutter_shop_app/modules/product_details/product_details_screen.dart';
import 'package:flutter_shop_app/shared/style/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';


void navigate({
  @required context,
  @required widget
}){
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => widget));
}

void navigateAndFinish({
  @required context,
  @required widget
}){
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget),
          (route) => false);
}


Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  @required Function validtor,
  @required String label,
  @required IconData prefixIcon,
  Function onTap = null,
  Function onFieldSubmitted = null,
  IconData suffixIcon = null,
  Function onSuffixPressed = null,
  bool isPassword = false,
  bool isReadOnly = false,

})=>TextFormField(
  controller: controller,
  validator: validtor,
  keyboardType: type,
  onTap: onTap,
  onFieldSubmitted: onFieldSubmitted,
  obscureText: isPassword,
  readOnly: isReadOnly,
  decoration: InputDecoration(
    labelText: label,
    border: OutlineInputBorder(),
    prefixIcon: Icon(prefixIcon),
    suffixIcon: suffixIcon !=null ? IconButton(
      icon: Icon(suffixIcon),
      onPressed: onSuffixPressed,
    ):null,
  ),
);

Widget defaultButton({
  @required context,
  @required Function onPressed,
  @required String text,
  Color color = defaultColor,
  double radius = 3,
  double width = double.infinity,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: onPressed,
        height: 50.0,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Text(
          text,
        style: TextStyle(
          color: Colors.white,
        ),
        ),
      ),
    );

Widget defaultTextButton(
    @required String text,
    @required Function onPressed,
    )=>TextButton(
    onPressed: onPressed,
    child: Text(text),);

void showToast({
  @required String message,
  @required ToastStates state
})=>  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates {SUCCESS,ERROR,WARNING}

Color chooseToastColor(ToastStates state){
  Color color;
  switch(state){
    case ToastStates.SUCCESS:
      color= Colors.green;
      break;
    case ToastStates.ERROR:
      color= Colors.red;
      break;
    case ToastStates.WARNING:
      color= Colors.yellow;
      break;
    default : 
      color = Colors.grey;
  }
  return color;
}

Widget buildListProductItem(context, ProductModel model) => InkWell(
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      height: 120.0,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              CachedNetworkImage(
                imageUrl: model.image,
                placeholder:(context, url) =>  buildImagePlaceHolderLoading(width: 120.0, height: 120.0),
                errorWidget: (context, url, error) => Icon(Icons.error,),
                width: 120.0,
                height: 120.0,
                //fit: BoxFit.cover,
              ),
              if (model.discount != 0 && model.oldPrice!=null)
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
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      '${model.price??''}',
                      style: TextStyle(
                        color: defaultColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    if (model.discount != 0 &&model.oldPrice!=null)
                      Text(
                        '${model.oldPrice??''}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    Spacer(),
                    CircleAvatar(
                      backgroundColor:
                      ShopCubit.get(context).favourites[model.id]
                          ? defaultColor
                          : Colors.grey[400],
                      child: IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            ShopCubit.get(context)
                                .changeFavourites(model.id);
                          }),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
  onTap: (){
    ShopCubit.get(context).getProductDetails(model.id);
    navigate(context: context, widget: ProductDetailsScreen());
  },
);


Widget buildListShimmerLoading() => Shimmer.fromColors(
  baseColor: Colors.grey[300],
  highlightColor: Colors.grey[400],
  child: ListView.separated(
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 120.0,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 120.0,
                height: 120.0,
                color: defaultColor,
              ),
              SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150.0,
                      height: 20.0,
                      color: defaultColor,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 60.0,
                          height: 20.0,
                          color: defaultColor,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          width: 30.0,
                          height: 20.0,
                          color: defaultColor,
                        ),
                        Spacer(),
                        CircleAvatar(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      separatorBuilder: (context, index) =>  Padding(
        padding: const EdgeInsetsDirectional.only(start: 20.0),
        child: Container(
          width: double.infinity,
          height: 2.0,
          color: Colors.grey[300],
        ),
      ),
      itemCount: 4),
);

Widget buildImagePlaceHolderLoading (
{
  @required double width,
  @required double height,
}
    )=>Shimmer.fromColors(
  baseColor: Colors.grey[300],
  highlightColor: Colors.grey[400],
child: Container(width: width,height: height,color: defaultColor,),);
