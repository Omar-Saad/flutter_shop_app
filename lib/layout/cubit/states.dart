import 'package:flutter_shop_app/models/categories_details_model.dart';
import 'package:flutter_shop_app/models/change_favourites_model.dart';
import 'package:flutter_shop_app/models/favourites_model.dart';
import 'package:flutter_shop_app/models/home_model.dart';
import 'package:flutter_shop_app/models/login_model.dart';
import 'package:flutter_shop_app/models/product_details_model.dart';

abstract class ShopStates {}

class ShopInitialStates extends ShopStates{}

class ShopChangeBottomNavState extends ShopStates{}

class ShopLoadingHomeDataState extends ShopStates{}
class ShopSuccessHomeDataState extends ShopStates{}
class ShopErrorHomeDataState extends ShopStates{
  final String error;

  ShopErrorHomeDataState(this.error);
}

class ShopLoadingCategoriesDataState extends ShopStates{}
class ShopSuccessCategoriesDataState extends ShopStates{}
class ShopErrorCategoriesDataState extends ShopStates{
  final String error;

  ShopErrorCategoriesDataState(this.error);
}

class ShopLoadingChangeFavouritesState extends ShopStates{}
class ShopSuccessChangeFavouritesState extends ShopStates{
  final ChangeFavouritesModel changeFavouritesModel;

  ShopSuccessChangeFavouritesState(this.changeFavouritesModel);

}
class ShopErrorChangeFavouritesState extends ShopStates{
  final String error;

  ShopErrorChangeFavouritesState(this.error);
}

class ShopLoadingGetFavouritesState extends ShopStates{}
class ShopSuccessGetFavouritesState extends ShopStates{
  final FavouritesModel favouritesModel;

  ShopSuccessGetFavouritesState(this.favouritesModel);

}
class ShopErrorGetFavouritesState extends ShopStates{
  final String error;

  ShopErrorGetFavouritesState(this.error);
}

class ShopLoadingGetUserProfileState extends ShopStates{}
class ShopSuccessGetUserProfileState extends ShopStates{
  final ShopLoginModel loginModel;

  ShopSuccessGetUserProfileState(this.loginModel);

}
class ShopErrorGetUserProfileState extends ShopStates{
  final String error;

  ShopErrorGetUserProfileState(this.error);
}

class ShopLoadingUpdateUserProfileState extends ShopStates{}
class ShopSuccessUpdateUserProfileState extends ShopStates{
  final ShopLoginModel loginModel;

  ShopSuccessUpdateUserProfileState(this.loginModel);

}
class ShopErrorUpdateUserProfileState extends ShopStates{
  final String error;

  ShopErrorUpdateUserProfileState(this.error);
}

class ShopLoadingGetProductDetailsState extends ShopStates{}
class ShopSuccessGetProductDetailsState extends ShopStates{
  final ProductDetailsModel productDetailsModel;

  ShopSuccessGetProductDetailsState(this.productDetailsModel);

}
class ShopErrorGetProductDetailsState extends ShopStates{
  final String error;

  ShopErrorGetProductDetailsState(this.error);
}

class SearchLoadingState extends ShopStates {}

class SearchSuccessState extends ShopStates {}

class SearchErrorState extends ShopStates {
  final String error ;

  SearchErrorState(this.error);

}

class ShopLoadingGetCategoriesDetailsState extends ShopStates{}
class ShopSuccessGetCategoriesDetailsState extends ShopStates{
  final CategoriesDetailsModel categoriesDetailsModel;

  ShopSuccessGetCategoriesDetailsState(this.categoriesDetailsModel);

}
class ShopErrorGetCategoriesDetailsState extends ShopStates{
  final String error;

  ShopErrorGetCategoriesDetailsState(this.error);
}
