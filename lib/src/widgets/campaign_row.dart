import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/util_functions.dart';

class CampaignRowWidget extends StatelessWidget {
  const CampaignRowWidget({Key? key, required this.campaign, required this.onSelection}) : super(key: key);
  final dynamic campaign;
  final VoidCallback onSelection;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onSelection,
      leading: Image.network(campaign.image!,
        errorBuilder: (_,__,___){
          return const Icon(CupertinoIcons.flame);
        },
      ),
      title: Text(campaign.name!.toString().toCapitalized()),
      subtitle: Text(campaign.desc!.toString().toCapitalized()),
      isThreeLine: true,
    );
  }
}