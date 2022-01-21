import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamification_bloc/gamification_bloc.dart';
import '../models/campaign_model.dart';
import 'package:provider/src/provider.dart';
import '../bloc/gamification_bloc.dart';

class CampaignListWidget extends StatelessWidget {
  const CampaignListWidget({Key? key, required this.onSelection}) : super(key: key);
  final  Function onSelection;

  @override
  Widget build(BuildContext context) {
    dynamic _campaignList = context.select((GamificationBloc value) => value.state.campaignList);
    logPrint.d("_campaignList = $_campaignList");
    _campaignList = _campaignList!;


    // if(_campaignList!.isEmpty) {
    //   return Container();
    // }
    // _campaignList.forEach((element) {
    //   logPrint.d("${element.toJson()}");
    // });

    return SizedBox(
      height: 100,
      child:  Container(
        decoration: const BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: ListView.builder(
          itemExtent: 180,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: _campaignList.length,
            itemBuilder: (context, index){
              return
               Container(
                  padding: const EdgeInsets.all(4),
                 margin: const EdgeInsets.all(4),
                 child: Card(
                   child:  Column(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       ClipOval(
                         child: Image.network(
                           _campaignList[index].image!,
                           width: 100.0,
                           errorBuilder:  (context, error, stackTrace) {
                             return const Icon(CupertinoIcons.square_stack_3d_down_right);
                           },
                         ),
                       ),
                       Text(_campaignList[index].name!.toString().toCapitalized(),
                         style: Theme.of(context).textTheme.headline6,
                       ),
                       Text(_campaignList[index].desc!.toString().toCapitalized(),
                         style: Theme.of(context).textTheme.caption,
                       ),
                     ],
                   ),
                 ),
               );
                // ListTile(
                //   // onTap: onSelection(_campaignList[index].id),
                //   leading: Image.network(_campaignList[index].image!,
                //     errorBuilder: (_,__,___){
                //       return const Icon(CupertinoIcons.flame);
                //     },
                //   ),
                //   title: Text(_campaignList[index].name!.toString().toCapitalized()),
                //   subtitle: Text(_campaignList[index].desc!.toString().toCapitalized()),
                //   isThreeLine: true,
                // );
            }),
      ),
    );
  }
}



