import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/util_functions.dart';

class PlayerRowWidget extends StatelessWidget {

  final dynamic userId;
  final dynamic player;
  final dynamic index;

  const PlayerRowWidget({Key? key, this.player, this.index, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   logPrint.d("player widget size = ${context.size}");
    // });
    return Container(
      color: player.userId == userId?Colors.blueGrey[100]:null,
      padding: const EdgeInsets.all(16),
      child: Row(
          children: [
           index!=null? Text(
              (index + 1).toString(),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.blueGrey
              ),

            ):Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueGrey,
                    child: ClipOval(
                      child: Image.network(
                        player.image??'',
                        width: 40.0,
                        errorBuilder:  (context, error, stackTrace) {
                          return const Icon(CupertinoIcons.person);
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                player.name??'',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Spacer(),
            Text(
              player.points.toString()+" XP",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]
      ),
    );
  }
}

