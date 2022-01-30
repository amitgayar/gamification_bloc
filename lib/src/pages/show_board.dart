import 'package:flutter/material.dart';
import '../widgets/normal_board.dart';
import '../widgets/ranking_board.dart';
import 'package:provider/src/provider.dart';
import '../bloc/gamification_bloc.dart';
import '../utils/util_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';



class ShowBoardPage extends StatelessWidget {
  const ShowBoardPage({Key? key, required this.userId}) : super(key: key);
  final String userId;
  @override
  Widget build(BuildContext context) {
    var _board = context.select((GamificationBloc bloc) => bloc.state.board);
    var _index = context.select((GamificationBloc bloc) => bloc.state.boardIndex);
    if (_board == null) {
      return Container();
    } else {

      return WillPopScope(
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                ///Share Button
                _board.share != null?
                TextButton(onPressed: () async{
                  logPrint.d('app shared clicked in UI');
                  await Share.share(_board.share??'');
                }, child:  const Icon(CupertinoIcons.arrowshape_turn_up_right,
                )

                ):Container(),



                ///  Boards
                _board.type == 'normal'?
                NormalBoardContent(board: _board,)
                    :Container(),
                _board.type != 'normal'
                    ?  RankingBoardPage(board: _board,userId:userId)
                    : Container(),




                /// Continue Button
                Container(
                  margin: const EdgeInsets.only(bottom: 48),
                  width: MediaQuery.of(context).size.width * .9,
                  height: 60,
                  child:  OutlinedButton(
                      onPressed: () async {
                        context
                            .read<GamificationBloc>()
                            .add(ShowBoardEvent(index: _index! + 1));
                      },
                      child: Text(
                        "Continue",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.w700),
                      )),

                ),
              ],
            ),
          ),

          /// disables Back Button
          onWillPop: () async {
            return false;
          });
    }
  }
}



