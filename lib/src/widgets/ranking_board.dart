import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../gamification_bloc.dart';
import '../models/gamification_data.dart';
import '../widgets/player_row_widget.dart';
import 'package:provider/src/provider.dart';



class RankingBoardPage extends StatelessWidget {
   const RankingBoardPage({Key? key, required this.board, required this.userId}) : super(key: key);
  final Board board;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Column(
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

        // todo : change indices (priority 1)
        Container(
            decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey, width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.blueGrey,
                  offset: Offset(5.0,5.0,),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),//BoxShadow
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height*.6,
                child: RankAnimationWidget(userId: userId, player:board.selectedPlayerData, players:board.oldPlayer, oldIndex : board.oldIndex, newIndex: board.newIndex,))),
      ],
    );
  }
}

class RankAnimationWidget extends StatelessWidget {
  RankAnimationWidget({Key? key,this.player, this.players, this.oldIndex, this.newIndex, this.userId = ''}) : super(key: key);

  final dynamic players;
  final dynamic oldIndex;
  final dynamic newIndex;
  final dynamic player;
  final String userId;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final scrollController = ScrollController();


  adjustList(context) async{
    // var oldIndex = 2;
    // var newIndex = 1;
    var totalItems = players.length;
    final scrollHeight = (totalItems+1)*80;
    logPrint.d("adjustList called with oldIndex = $oldIndex newIndex = $newIndex _removedPlayer = ${player.toJson()}");



    await scrollController.animateTo(scrollHeight*(oldIndex-2)/totalItems, duration: const Duration(milliseconds: 500), curve: Curves.linear);
    // scrollController.jumpTo(scrollHeight*(oldIndex-2)/totalItems);

    _removeAnimation() async{
      listKey.currentState!.removeItem(oldIndex, (_, animation) => slideIt( context, oldIndex, animation), duration: const Duration(milliseconds: 1));
      // await Future.delayed(const Duration(milliseconds: 400));
    }

    _insertAnimation() async{
      players.insert(newIndex, player);
      listKey.currentState!.insertItem(newIndex, duration: const Duration(milliseconds: 3000));
    }

    _scrollAnimation() async{
      scrollController.animateTo(scrollHeight*(newIndex-4)/totalItems, duration: const Duration(milliseconds: 3000), curve: Curves.linear);
      await Future.delayed(const Duration(seconds: 1));
    }
    if(player.name != '' && player.name != null){
      // _removeAnimation();
      _insertAnimation();
      _scrollAnimation();
    }

    // await Future.wait([first(), second(), third()]).then((value) {
    //   log.d('future wait OK OK');
    // });
  }

  Widget slideIt(BuildContext context, int index, animation) {
    var item = players[index];
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, (oldIndex-newIndex).toDouble()),
        end: const Offset(0, 0),
      ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutQuad)
        // animation
          ),
      child: InkWell(
        onTap: (){
          adjustList(context);
        },
        child: PlayerRowWidget(player: item, index: index, userId: userId,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => adjustList(context));
    // todo :  get userId
    // userId = context.select((GamificationBloc bloc) => bloc.state.userData!.uid);
    return AnimatedList(
      shrinkWrap: true,
      controller: scrollController,
      key: listKey,
      initialItemCount: players.length,
      itemBuilder: (context, index, animation) {
        // todo : change
        // if(index==players.length-1)adjustList(context);
        return slideIt(context, index, animation); // Refer step 3
      },
    );
  }
}

