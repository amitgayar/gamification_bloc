import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/campaign_model.dart';
import 'package:provider/src/provider.dart';
import '../bloc/gamification_bloc.dart';
import '../utils/util_functions.dart';

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
      height: 100,
      child:  Container(
        decoration: const BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: ListView(
          itemExtent: 180,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              for(var campaign in _campaignList)
                Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(4),
                  child: InkWell(
                    onTap: () => onSelection(campaign),
                    child: Card(
                      child:  Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipOval(
                              child: Image.network(
                                campaign.image!,
                                width: 100.0,
                                errorBuilder:  (context, error, stackTrace) {
                                  return const Icon(CupertinoIcons.square_stack_3d_down_right);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(campaign.name!.toString().toCapitalized(),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(campaign.desc!.toString().toCapitalized(),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
            ),
      ),
    );
  }
}



