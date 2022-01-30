import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/campaign_model.dart';
import 'package:provider/provider.dart';
import '../bloc/gamification_bloc.dart';
import '../utils/util_functions.dart';
import 'package:shimmer/shimmer.dart';

class CampaignListWidget extends StatelessWidget {
  const CampaignListWidget({Key? key, required this.onSelection}) : super(key: key);
  final Function(Campaign) onSelection;

  @override
  Widget build(BuildContext context) {
    dynamic _campaignList = context.select((GamificationBloc value) => value.state.campaignList);
    logPrint.d("_campaignList = $_campaignList");
    // todo : put loader
    if(_campaignList == null) {
      return Container();
    }
    _campaignList = _campaignList!;

    return SizedBox(
      height: MediaQuery.of(context).size.height*.6,
      child:  ListView.builder(
          itemCount:   _campaignList.length,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  height: 100,
                  child: ListTile(
                    onTap: () => onSelection(_campaignList[index]),
                    leading: ClipOval(
                      child: Image.network(
                        _campaignList[index].image!,
                        width: 50.0,
                        errorBuilder:  (context, error, stackTrace) {
                          return const Icon(CupertinoIcons.square_stack_3d_down_right);
                        },
                      ),
                    ),
                    title: Shimmer.fromColors(
                      baseColor: Colors.black87,
                      highlightColor: Colors.orangeAccent[100]!,
                      child: Text((_campaignList[index].name??'').toString().toCapitalized(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    subtitle: Text((_campaignList[index].desc??'').toString().toCapitalized(),
                      style: Theme.of(context).textTheme.caption,
                    ),

                  ),
                )
            ;
          }

          ),
    );
  }
}



