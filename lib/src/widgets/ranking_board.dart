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
    var data = processBoard(board.player??[], board.points??-1, userId);


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
                child: RankAnimationWidget(
                  userId: userId,
                  players: data[0],
                  oldIndex: data[1],
                  newIndex: data[2],
                  editedPlayer: data[3]
                ))),
      ],
    );
  }
}

class RankAnimationWidget extends StatelessWidget {
  RankAnimationWidget({Key? key, required this.players, required this.userId, required this.oldIndex, required this.newIndex, required this.editedPlayer}) : super(key: key);

  final dynamic players;
  final dynamic userId;
  final int oldIndex;
  final int newIndex;
  final Player editedPlayer;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final scrollController = ScrollController();


  animateList(context) async{

    // dynamic player;
    // var oldIndex = 2;
    // var newIndex = 1;
    var totalItems = players.length;
    final scrollHeight = (totalItems+1)*80;
    logPrint.d("animateList called with oldIndex = $oldIndex newIndex = $newIndex _removedPlayer = ${editedPlayer.toJson()}");

    _removeAnimation() async{
      listKey.currentState!.removeItem(oldIndex, (_, animation) => slideIt( context, oldIndex, animation), duration: const Duration(milliseconds: 1));
      // await Future.delayed(const Duration(milliseconds: 400));
    }


    await scrollController.animateTo(scrollHeight*(oldIndex)/totalItems, duration: const Duration(milliseconds: 1500), curve: Curves.linear);
    await Future.delayed(const Duration(milliseconds: 500));

    // scrollController.jumpTo(scrollHeight*(oldIndex-2)/totalItems);


    _insertAnimation() async{
      players.insert(newIndex, editedPlayer);
      listKey.currentState!.insertItem(newIndex, duration: const Duration(milliseconds: 3000));
    }

    _scrollAnimation() async{
      scrollController.animateTo(scrollHeight*(newIndex)/totalItems, duration: const Duration(milliseconds: 3000), curve: Curves.linear);
      await Future.delayed(const Duration(seconds: 1));
    }
    if(oldIndex != -1){
      // await _removeAnimation();
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
      child: PlayerRowWidget(player: item, index: index, userId: userId,)
    );
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance!.addPostFrameCallback((_) => animateList(context ));

    return AnimatedList(
      shrinkWrap: true,
      controller: scrollController,
      key: listKey,
      initialItemCount: players.length,
      itemBuilder: (context, index, animation) {
        return slideIt(context, index, animation); // Refer step 3
      },
    );
  }
}

processBoard(List players, int points,  userId) {
  logPrint.d('processing Leader Animation Board with uid : $userId');
  int _oldIndex = -1;
  Player _playerEdit = Player(name:'');
  int _newRank = -1;


  if(players.isEmpty || players.indexWhere((element) => element.userId == userId)== -1 || points == -1){
    return [players, _oldIndex, _newRank, _playerEdit];
  }



  for (var i = 0; i < players.length; i++){
    if(players[i].userId == userId){
      _playerEdit = players[i].copyWith(points:points);
      _oldIndex = i;
      logPrint.d('processing Board (for loop) -  oldIndex : $_oldIndex - playerEdit = ${_playerEdit.toJson()} ');
    }
  }

  if(_oldIndex != -1){
    players.removeAt(_oldIndex);
    players.add(_playerEdit);
    players.sort((a,b) => b.points!.compareTo(a.points!.toInt()));
    _newRank = players.indexWhere((element) => element.userId == userId);
    _playerEdit = players.removeAt(_newRank);
  }
  logPrint.d('processing Board -  oldIndex = $_oldIndex, newIndex = $_newRank, playerEdit = ${_playerEdit.toJson()}');
  return [players, _oldIndex, _newRank, _playerEdit];
}

