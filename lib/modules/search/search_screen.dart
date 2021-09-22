import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shop_app/layout/cubit/cubit.dart';
import 'package:flutter_shop_app/layout/cubit/states.dart';
import 'package:flutter_shop_app/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit , ShopStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                defaultFormField(
                    controller: searchController,
                    type: TextInputType.text,
                    validtor: (String value) {
                      if (value.isEmpty) return 'Required Field';
                      return null;
                    },
                    onFieldSubmitted: (value){
                      ShopCubit.get(context).search(value);
                    },
                    label: 'Search',
                    prefixIcon: Icons.search),
                SizedBox(height: 16.0,),
                if(state is SearchLoadingState)
                  LinearProgressIndicator(),
                if(ShopCubit.get(context).searchModel!=null)
                  Expanded(
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => buildListProductItem(
                            context,
                            ShopCubit.get(context)
                                .searchModel
                                .data
                                .data[index]),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsetsDirectional.only(start: 20.0),
                          child: Container(
                            width: double.infinity,
                            height: 2.0,
                            color: Colors.grey[300],
                          ),
                        ),
                        itemCount:
                        ShopCubit.get(context).searchModel.data.data.length),
                  )
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
  


}
