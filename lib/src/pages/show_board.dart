import 'package:flutter/material.dart';
import '../../gamification_bloc.dart';
import '../widgets/normal_board.dart';
import '../widgets/ranking_board.dart';
import 'package:provider/provider.dart';
import '../bloc/gamification_bloc.dart';
import '../utils/util_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';

class ShowBoardPage extends StatelessWidget {
  const ShowBoardPage({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    Board? _board = context.select((GamificationBloc bloc) => bloc.state.board);
    if (_board == null || _board.type == null) {
      return const SizedBox.shrink();
    }

    var _index =
        context.select((GamificationBloc bloc) => bloc.state.boardIndex);
    Size _size = MediaQuery.of(context).size;

    return WillPopScope(
        child: Container(
          color: Colors.white,
          child: Stack(children: [
            Column(
              children: [
                ///Share Button
                SizedBox(
                  height: _size.height * .1,
                  child: _board.share != null
                      ? Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                              onPressed: () async {
                                logPrint.d('app shared clicked in UI');
                                await Share.share(_board.share ?? '');
                              },
                              child: const Icon(
                                CupertinoIcons.arrowshape_turn_up_right,
                              )),
                        )
                      : Container(),
                ),

                ///  Boards
                SizedBox(
                  height: _size.height * .6,
                  child: _board.type == 'normal'
                      ? NormalBoardContent(
                          board: _board,
                        )
                      : RankingBoardPage(board: _board, userId: userId),
                ),
              ],
            ),

            /// Continue Button
            Positioned(
              bottom: 48,
              left: _size.width*.05,
              child: SizedBox(
                // margin: const EdgeInsets.only(bottom: 48),
                width: _size.width*.9,
                child: OutlinedButton(
                    onPressed: () async {
                      context
                          .read<GamificationBloc>()
                          .add(ShowBoardEvent(index: _index! + 1));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Continue",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.w900),
                      ),
                    )),
              ),
            ),
          ]),
        ),

        /// disables Back Button
        onWillPop: () async {
          context
              .read<GamificationBloc>()
              .add(const ShowBoardEvent(index: -1));
          return false;
        });
  }
}
