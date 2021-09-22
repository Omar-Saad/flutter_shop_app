import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/layout/cubit/states.dart';
import 'package:flutter_shop_app/models/categories_details_model.dart';
import 'package:flutter_shop_app/models/categories_model.dart';
import 'package:flutter_shop_app/models/change_favourites_model.dart';
import 'package:flutter_shop_app/models/favourites_model.dart';
import 'package:flutter_shop_app/models/home_model.dart';
import 'package:flutter_shop_app/models/login_model.dart';
import 'package:flutter_shop_app/models/product_details_model.dart';
import 'package:flutter_shop_app/models/search_model.dart';
import 'package:flutter_shop_app/modules/categories/categories_screen.dart';
import 'package:flutter_shop_app/modules/favourites/favourites_screen.dart';
import 'package:flutter_shop_app/modules/home/home_screen.dart';
import 'package:flutter_shop_app/modules/profile/profile_screen.dart';
import 'package:flutter_shop_app/shared/components/constants.dart';
import 'package:flutter_shop_app/shared/network/end_points.dart';
import 'package:flutter_shop_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialStates());

  int currentIndex = 0;
  HomeModel homeModel;
  CategoriesModel categoriesModel;
  Map<int, bool> favourites = {};
  ChangeFavouritesModel changeFavouritesModel;
  FavouritesModel favouritesModel;
  ShopLoginModel loginModel;
  ProductDetailsModel productDetailsModel;
  SearchModel searchModel;
  CategoriesDetailsModel categoriesDetailsModel;

  static ShopCubit get(context) => BlocProvider.of(context);

  List<Widget> bottomScreens = [
    HomeScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    ProfileScreen()
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      pathUrl: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
        favourites.addAll({element.id: element.inFavourite});
        //print(element.inFavourite);
      });
      //  print(homeModel.data.banners[0].image);
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState(error.toString()));
    });
  }

  void getCategoriesData() {
    emit(ShopLoadingCategoriesDataState());

    DioHelper.getData(
      pathUrl: CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesDataState(error.toString()));
    });
  }

  void changeFavourites(int productId) {
    favourites[productId] = !favourites[productId];
    emit(ShopLoadingChangeFavouritesState());
    DioHelper.postData(
      pathUrl: FAVOURITES,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      changeFavouritesModel = ChangeFavouritesModel.fromJson(value.data);
      if (!changeFavouritesModel.status)
        favourites[productId] = !favourites[productId];
      else
        getFavourites();
      emit(ShopSuccessChangeFavouritesState(changeFavouritesModel));
    }).catchError((error) {
      favourites[productId] = !favourites[productId];
      emit(ShopErrorChangeFavouritesState(error));
    });
  }

  void getFavourites() {
    emit(ShopLoadingGetFavouritesState());

    DioHelper.getData(
      pathUrl: FAVOURITES,
      token: token,
    ).then((value) {
      favouritesModel = FavouritesModel.fromJson(value.data);
      favouritesModel.data.data.forEach((element) {
        favourites.addAll({element.product.id : true});
      });
      emit(ShopSuccessGetFavouritesState(favouritesModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavouritesState(error.toString()));
    });
  }

  void getUserProfile() {
    emit(ShopLoadingGetUserProfileState());
    DioHelper.getData(
      pathUrl: PROFILE,
      token: token,
    ).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopSuccessGetUserProfileState(loginModel));
    }).catchError((error) {
      emit(ShopErrorGetUserProfileState(error.toString()));
    });
  }

  void updateProfile({
    @required String name,
    @required String password,
    @required String email,
    @required String phone,

  }) {
    emit(ShopLoadingUpdateUserProfileState());

    DioHelper.putData(pathUrl: UPDATE_PROFILE, data: {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    }, token: token).then((value) {
      ShopLoginModel tempModel = ShopLoginModel.fromJson(value.data);
      if (tempModel.data != null)
        loginModel = tempModel;
      else {
        loginModel.status = tempModel.status;
        loginModel.message = tempModel.message;
      }

      emit(ShopSuccessUpdateUserProfileState(loginModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserProfileState(error.toString()));
    });
  }

  void getProductDetails(int productId) {
    emit(ShopLoadingGetProductDetailsState());
    DioHelper.getData(pathUrl: '$PRODUCT_DETAILS/$productId', token: token)
        .then((value)  {
          productDetailsModel = ProductDetailsModel.fromJson(value.data);
          emit(ShopSuccessGetProductDetailsState(productDetailsModel));
    })
        .catchError((error) {
      emit(ShopErrorGetProductDetailsState(error.toString()));

    });
  }

  void search(String text) {
    emit(SearchLoadingState());
    DioHelper.postData(pathUrl: SEARCH, data: {
      'text':text,
    },token: token)
        .then((value) {
      searchModel = SearchModel.fromJson(value.data);
      searchModel.data.data.forEach((element) {
        favourites.addAll({element.id: element.inFavourite});
        //print(element.inFavourite);
      });
      emit(SearchSuccessState());
    })
        .catchError((error) {
          print(error.toString());
      emit(SearchErrorState(error.toString()));

    });
  }
void getCategoriesDetails(int categoryId){
  emit(ShopLoadingGetCategoriesDetailsState());
  DioHelper.getData(pathUrl: '$CATEGORIES/$categoryId', token: token)
      .then((value)  {
    categoriesDetailsModel = CategoriesDetailsModel.fromJson(value.data);
    categoriesDetailsModel.data.data.forEach((element) {
      favourites.addAll({element.id: element.inFavourite});
      //print(element.inFavourite);
    });
    emit(ShopSuccessGetCategoriesDetailsState(categoriesDetailsModel));
  })
      .catchError((error) {
    emit(ShopErrorGetCategoriesDetailsState(error.toString()));

  });
}
}
