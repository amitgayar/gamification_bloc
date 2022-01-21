import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamification_bloc/gamification_bloc.dart';
import '../utils/util_functions.dart';

class NormalBoardContent extends StatelessWidget {
  const NormalBoardContent({Key? key, required this.board}) : super(key: key);
  final Board board;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                board.title ?? '',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                board.subtitle ?? '',
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          Image.network(
            board.image!,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                CupertinoIcons.flame,
                size: 70,
                color: Colors.green,
              );
            },
          ),
          Column(
              children: board.table!.entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key.toString().toCapitalized(),
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      entry.value.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.w700),
                      // .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              )).toList()

          ),
        ],
      ),
    );
  }
}