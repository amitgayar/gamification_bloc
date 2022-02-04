import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamification_bloc/gamification_bloc.dart';
import '../utils/util_functions.dart';

class NormalBoardContent extends StatelessWidget {
  const NormalBoardContent({Key? key, required this.board}) : super(key: key);
  final Board board;

  @override
  Widget build(BuildContext context) {
    TextTheme _theme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              board.title ?? '',
              style: _theme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.w900),
            ),
            Text(
              board.subtitle ?? '',
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: _theme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Image.network(
          board.image??"image.com",
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              CupertinoIcons.flame,
              size: 70,
              color: Colors.green,
            );
          },
        ),
       if( board.table != null)
             Column(
                children: board.table!.entries
                    .map((entry) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key.toString().toCapitalized(),
                                style: _theme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                entry.value.toString(),
                                style: _theme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.w700),
                                // .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ))
                    .toList())
      ],
    );
  }
}
