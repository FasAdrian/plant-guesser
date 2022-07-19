import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// import 'package:plants/drift_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'functions.dart';
import 'classes.dart';
import 'package:provider/provider.dart';
// import 'drift_database.dart';
// import 'package:moor_db_viewer/moor_db_viewer.dart';


final List<Plant> plants = makePlantList();
final List<String> familyTypes = makefamilyTypesList();
ThemeColor themeColor = ThemeColor(themeColorMain: changeAppBarColor(2), themeColorBG: Color.fromARGB(255, 247, 247, 247), textColorMain: Colors.black );
bool guessFamily = true;
Map<String, List<int>> loadingCodes = {
  "gymlet poznávačka": [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109]
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadAllPreferences();
  runApp(const MyApp());
  debugPrint(plants.length.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Poznávačka', 
      theme: ThemeData(
        
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        'learningScreen': (BuildContext context) => const LearningPage(title: 'scr4'),
        'settingsScreen': (BuildContext context) => const SettingsPage(),
        'plantEnablingScreen': (BuildContext context) => const PlantEnablingPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}  
class _MyHomePageState extends State<MyHomePage> {
  final String homePagePlantLink = 'assets/images/homePagePlant.png';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _getRequests()async{
    setState(() {
        
    });
  }
  @override
  void initState() {
    loadAllPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        setState(() {
          
        });
        if(MediaQuery.of(context).size.width < MediaQuery.of(context).size.height){
          return confirmationBool(
            context, 
            () {Navigator.of(context).pop(true);}, 
            () {Navigator.of(context).pop(false);},
            subtitle: Text('Chceš vypnút aplikáciu', style: TextStyle(color:themeColor.textColorMain)),
            title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
            positiveAnswer: 'Opustiť',
            negativeAnswer: 'Zostať',
          );
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: SettingsPage(),
        ),
        backgroundColor: themeColor.themeColorBG,
        appBar: AppBar(
          backgroundColor: themeColor.themeColorMain,
          title: const Text('Poznávačka'),
          leading: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: (){
              if(MediaQuery.of(context).size.width > MediaQuery.of(context).size.height){
                _scaffoldKey.currentState?.openDrawer();
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage())).then((val)=>{_getRequests()});
              }
            },
          ),
        ),
        body: _buildBody(),
      )
    );
  }

  Widget _buildBody(){
    if('A' == 'B'){
      return Container(color: Colors.blue,);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(thickness: 50, color: themeColor.themeColorBG, height: 50,),
          Image(
            image: AssetImage(homePagePlantLink),
          ),
          Divider(thickness: 70, color: themeColor.themeColorBG, height: 70,),
          TextButton(
            onPressed: ()async{
              int playedGameStopWatch = await loadFromPreferencesInt('playedGameStopWatch');
              int playedGameCorrect = await loadFromPreferencesInt('playedGameCorrect');
              int playedGameWrong = await loadFromPreferencesInt('playedGameWrong');
              int playedGameHints = await loadFromPreferencesInt('playedGameHints');
              bool tutorialPlayed = await loadFromPreferencesBool('tutorialGame1_isPlayed');
              if(playedGameCorrect != 0 || playedGameWrong != 0){
                showDialog(context: context, 
                  builder: (context){
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(themeColor.themeColorBG),
                            ),
                            onPressed:() {
                              Navigator.of(context).pop();
                              startGuessingPage(true);
                            }, 
                            child: const Text('Nová hra', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),)
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(themeColor.themeColorBG),
                                ),
                                onPressed:() {
                                  Navigator.of(context).pop();      
                                  startGuessingPage(false);
                                }, 
                                child: const Text('Pokračovať', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),)
                              ),
                              Center(
                                child: ListTile(
                                  title: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(height: 3, color: Colors.grey,),
                                      Center(child:Text(changeMillisecondsToTime(playedGameStopWatch), style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500))),
                                      Container(color: Colors.white, height:20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              const Icon(Icons.done, color: Color.fromARGB(255, 1, 107, 7),size: 20,),
                                              Text(
                                                '$playedGameCorrect',
                                                style: const TextStyle(color: Color.fromARGB(255, 1, 107, 7), fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Icon(Icons.close, color: Colors.red[800], size: 20,),
                                              Text(
                                                '$playedGameWrong',
                                                style: TextStyle(color: Colors.red[800], fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Icon(Icons.lightbulb, color: Colors.yellow[700],size: 20,),
                                              Text(
                                                '$playedGameHints',
                                                style: TextStyle(color: Colors.yellow[700], fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(color: Colors.white, height:5),
                                      Container(height: 3, color: Colors.grey,),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }
                );    
              } else {
                startGuessingPage(true);
                if(tutorialPlayed == false){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameTutorial(imageName: 'bioFlutterMainGame', numberOfImgs: 4, tutorialPref: 'tutorialGame1_isPlayed'))).then((val)=>{_getRequests()});
                }
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(themeColor.themeColorMain),
              minimumSize: MaterialStateProperty.all(const Size(200,40)),
            ),
            child: const Text('Hrať hru', style: TextStyle(color:Colors.white, fontSize: 20),),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pushNamed('learningScreen').then((val)=>{_getRequests()});
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(themeColor.themeColorMain),
              minimumSize: MaterialStateProperty.all(const Size(200,40)),
            ), 
            child: const Text('Rastliny', style: TextStyle(color:Colors.white, fontSize: 20),),
          )
        ]
      );
    }
  }

  void startGuessingPage(bool isNewGame){
    int plantsEnabled = 0;
    plants.forEach((element) {if(element.enabled == true){plantsEnabled++;}});
    if(plantsEnabled > 1){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => GuessingPage(isNew: isNewGame,))).then((val)=>{_getRequests()});
    } else {
      showDialog(
        context: context,
        builder:(context){
          return const AlertDialog(
            title: Center(
              child: Text(
                'Musíš si povoliť aspoň 2 rastliny',
                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red, fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            content: Text(
              'NASTAVENIA -> Povoliť rastliny',
              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    } 
  }
}

class GuessingPage extends StatefulWidget {
  const GuessingPage({Key? key, required this.isNew}) : super(key: key);
  final bool isNew;

  @override
  State<GuessingPage> createState() => _GuessingPageState();
}
class _GuessingPageState extends State<GuessingPage> {
  List<int> lastIndexes = [];
  List<int> usingIndexes = [];
  int plantIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  int hintsUsed = 0;
  List<int> hintsOnPlantUsed = [];
  int maxHintsOnPlant = 3;
  List<int> wrongAnswersList = [];
  TextEditingController slovakTermInput = TextEditingController();
  TextEditingController familyInput = TextEditingController();
  final FocusNode slovakTermNode = FocusNode();
  final FocusNode familyNode = FocusNode();


  StopWatch stopWatch = StopWatch();
  bool thisGameGuessingFamily = guessFamily;
  late Widget familyInputterContainer = Container(width: 1,height: 1, color: Colors.white,);
  
  late String stopWatchTime = '00:00:00';
  late Timer everySecondTimer;

  @override
  void dispose() {
    everySecondTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    futureToInitState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(thisGameGuessingFamily == true){
      familyInputterContainer = Container(
        margin: const EdgeInsets.only(left: 20, top: 5, right: 20),
        child: TextField(
          onSubmitted: (value){
            checkAnswers();
          },
          focusNode: familyNode,
          controller: familyInput,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Čeľaď',
          ),
        ),
      );
    } else {
      familyInputterContainer = Container(width: 1,height: 1, color: Colors.white,);
    }
    return WillPopScope(
      onWillPop: ()async{
        return confirmationBool(
          context, 
          () {Navigator.of(context).pop(true);}, 
          () {Navigator.of(context).pop(false);},
          subtitle: Text('Chceš vypnút a opustiť hru', style: TextStyle(color:themeColor.textColorMain)),
          title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
          positiveAnswer: 'Opustiť',
          negativeAnswer: 'Zostať',
        );
      },
      child: Scaffold(
        backgroundColor: themeColor.themeColorBG,
        appBar: AppBar( 
          backgroundColor: themeColor.themeColorMain,
          automaticallyImplyLeading: false,
          title: const Text('Uhádni rastlinu'),
          leadingWidth: 130,
          leading: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_left),
                onPressed: (){
                  confirmationBool(
                    context, 
                    () {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop(true);
                    }, 
                    () {Navigator.of(context).pop(false);},
                    subtitle: Text('Chceš vypnút a opustiť hru', style: TextStyle(color:themeColor.textColorMain)),
                    title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
                    positiveAnswer: 'Opustiť',
                    negativeAnswer: 'Zostať',
                  );
                }
              ),
              const Spacer(),
              Text(
                correctAnswers.toString(),
                style: const TextStyle(color: Color.fromARGB(255, 1, 107, 7), fontWeight: FontWeight.w900, fontSize: 20)
              ),
              const Spacer(flex: 3),
              Text(
                wrongAnswers.toString(),
                style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.w900, fontSize: 20)
              ),
              const Spacer(flex: 3,),
              Text(
                hintsUsed.toString(),
                style: TextStyle(color: Colors.yellow[600], fontWeight: FontWeight.w900, fontSize: 20)
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.lightbulb),
              color: Colors.yellow[200],
              onPressed: showHintDialog,
            ),
            IconButton(
              icon: const Icon(Icons.next_plan_outlined),
              onPressed: (){
                confirmationDynamic(
                  context,
                  () {
                    wrongAnswersList.add(plantIndex);
                    wrongAnswers++;
                    familyInput = TextEditingController();
                    slovakTermInput = TextEditingController();
                    Navigator.of(context).pop(true);
                    showDialog(
                      context: context, 
                      builder: (context) => AlertDialog(
                        actions: [
                          IconButton(
                            onPressed: (){
                              slovakTermInput = TextEditingController();
                              familyInput = TextEditingController();
                              Navigator.pop(context);
                              setState((){});
                            }, 
                            icon: const Icon(Icons.keyboard_double_arrow_right),
                          ),
                        ],
                        backgroundColor: Colors.red,
                        buttonPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        title: Column(
                          children: [
                            const Text('Odpoveď bola:', style: TextStyle(fontSize: 25)),
                            const Divider(height: 15, thickness: 0,),
                            Text('${plants[lastIndexes[0]].slovakFirstName} ${plants[lastIndexes[0]].slovakLastName}'.toUpperCase(), style: const TextStyle(fontSize: 20)),
                            const Divider(height: 15, thickness: 0, color: Colors.red,),
                            Text(plants[lastIndexes[0]].family.toUpperCase(), style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      )
                    );
                    nextPlant(skipped:true);
                  },
                  (){
                    Navigator.of(context).pop(false);
                  },
                  subtitle: Text('Chceš preskočiť rastlinu', style: TextStyle(color: Colors.redAccent)),
                  title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
                  positiveAnswer: 'Preskočiť',
                  negativeAnswer: 'Nepreskočiť',
                );
              },
            ),
          ],
        ),
        body: buildBody()
      ),
    );
  }
   

  Widget buildBody(){
    print('${MediaQuery.of(context).size.width} ${MediaQuery.of(context).size.height}');
    if(MediaQuery.of(context).size.width/MediaQuery.of(context).size.height<0.63){
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 20, color: themeColor.themeColorBG,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${lastIndexes.length+1}/${usingIndexes.length}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: themeColor.textColorMain),),
                    Text(
                      stopWatchTime,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: themeColor.themeColorMain,
                      ),
                    ),
                    Text('${lastIndexes.length+1}/${usingIndexes.length}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: themeColor.themeColorBG),),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 20, right: 20),  
                  child: TextField(
                    focusNode: slovakTermNode,
                    autofocus: true,
                    onSubmitted: (value){
                      if(guessFamily == true){
                        slovakTermNode.unfocus();
                        FocusScope.of(context).requestFocus(familyNode);
                      } else {
                        slovakTermNode.unfocus();
                        checkAnswers();
                      }
                    },
                    controller: slovakTermInput,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Slovenský názov rastliny:',
                    ),
                  ),
                ),
                familyInputterContainer,
                Container(height: 30, color: themeColor.themeColorBG,),
                
                Divider(color: themeColor.themeColorMain, thickness: 5, indent: 20, endIndent: 20,),
                InteractiveViewer(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRect(
                      child:  Image(
                        image: AssetImage('assets/images/${plants[plantIndex].path}.png'),
                      ),
                    ),
                  ),
                ),
                Divider(color: themeColor.themeColorMain, thickness: 5, indent: 20, endIndent: 20,),
              ]
            )
          ),
          Positioned(
            right: 50,
            bottom: 50,
            child: FloatingActionButton(
              focusColor: themeColor.themeColorMain,
              backgroundColor: themeColor.themeColorMain,
              splashColor: themeColor.themeColorMain,
              onPressed: (){
                checkAnswers();
              },
              child: const Icon(Icons.done), 
            )
          ),
        ],
      );
    } else {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(height: 20, color: themeColor.themeColorBG,),
                    Text('${lastIndexes.length+1}/${usingIndexes.length}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: themeColor.textColorMain),),
                    Text(
                      stopWatchTime,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: themeColor.themeColorMain,
                      ),
                    ),
                    Text('${lastIndexes.length+1}/${usingIndexes.length}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: themeColor.themeColorBG),),
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 20, right: 20),  
                      child: TextField(
                        autofocus: true,
                        onSubmitted: (value){
                          if(guessFamily == true){
                            slovakTermNode.unfocus();
                            FocusScope.of(context).requestFocus(familyNode);
                          } else {
                            slovakTermNode.unfocus();
                            checkAnswers();
                          }
                        },
                        focusNode: slovakTermNode,
                        controller: slovakTermInput,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Slovenský názov rastliny:',
                        ),
                      ),
                    ),
                    familyInputterContainer,
                    Container(height: 30, color: themeColor.themeColorBG,),
                  ]
                )
              ),
              VerticalDivider(color: themeColor.themeColorMain, thickness: 5, indent: 20, endIndent: 20,),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Image(
                    image: AssetImage('assets/images/${plants[plantIndex].path}.png'),
                    fit: BoxFit.contain
                  ),
                )
              ),
            ]
          ),
          Positioned(
            right: 50,
            bottom: 50,
            child: FloatingActionButton(
              focusColor: themeColor.themeColorMain,
              backgroundColor: themeColor.themeColorMain,
              splashColor: themeColor.themeColorMain,
              onPressed: (){
                checkAnswers();
              },
              child: const Icon(Icons.done), 
            )
          ),
        ],
      );
    }
  }

  void checkAnswers(){
    showDialog(context: context,
      builder: (context){
        late Color bgcolor;
        bool correctPlant = false;
        bool correctFamily = false;
        if(removeDiacritics(slovakTermInput.text).replaceAll(' ', '') == removeDiacritics('${plants[plantIndex].slovakFirstName} ${plants[plantIndex].slovakLastName}').replaceAll(' ', '')){
          correctPlant = true;
        }
        if(removeDiacritics(familyInput.text).replaceAll(' ', '') == removeDiacritics(plants[plantIndex].family).replaceAll(' ', '')){
          correctFamily = true;
        }
        if(thisGameGuessingFamily == false){
          if(correctPlant){
            bgcolor = Colors.green;
            return AlertDialog(  
              backgroundColor: bgcolor,
              buttonPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              actions: [
                IconButton(
                  autofocus: true,
                  onPressed: (){
                    correctAnswers++;
                    nextPlant();
                    slovakTermInput = TextEditingController();
                    familyInput = TextEditingController();
                    Navigator.pop(context);
                    setState((){});
                  }, 
                  icon: const Icon(Icons.keyboard_double_arrow_right),
                ),
              ],
              title: Column(
                children: [
                  const Text('Správne!', style: TextStyle(fontSize: 25)),
                  const Divider(height: 15, thickness: 0,),
                  Text('${plants[plantIndex].slovakFirstName} ${plants[plantIndex].slovakLastName}'.toUpperCase(), style: const TextStyle(fontSize: 20)),
                ],
              )
            );
          } else {
            bgcolor = Colors.red;
            return AlertDialog(
              backgroundColor: bgcolor,
              title: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Skús to znova!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                    const Divider(height: 15, thickness: 0,),
                    Text('Nesprávny názov rastliny!'),
                  ]
                ),
              ) 
            );
          }
        } else {
          if(correctPlant && correctFamily){
            bgcolor = Colors.green;
            return AlertDialog(  
              backgroundColor: bgcolor,
              buttonPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              actions: [
                IconButton(
                  autofocus: true,
                  onPressed: (){
                    correctAnswers++;
                    nextPlant();
                    slovakTermInput = TextEditingController();
                    familyInput = TextEditingController();
                    Navigator.pop(context);
                    
                    setState((){});
                  }, 
                  icon: const Icon(Icons.keyboard_double_arrow_right),
                ),
              ],
              title: Column(
                children: [
                  const Text('Správne!', style: TextStyle(fontSize: 25)),
                  const Divider(height: 15, thickness: 0,),
                  Text('${plants[plantIndex].slovakFirstName} ${plants[plantIndex].slovakLastName}'.toUpperCase(), style: const TextStyle(fontSize: 20)),
                  Divider(height: 15, thickness: 0, color: bgcolor,),
                  Text(plants[plantIndex].family.toUpperCase(), style: const TextStyle(fontSize: 20)),
                ],
              )
            );
          } else {
            bgcolor = Colors.red;
            Widget returnText = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Skús to znova!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                  const Divider(height: 15, thickness: 0,),
                  Text('Nesprávny názov rastliny'),
                  Container(color: bgcolor, height: 5,),
                  Text('nesprávny názov čeľade'),
                ],
              ), 
            );  
            if(correctPlant == true && correctFamily == false){
              bgcolor = Colors.orange;
              returnText = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Skús to znova!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                    const Divider(height: 15, thickness: 0,),
                    Text('Správny názov rastliny'),
                    Container(color: bgcolor, height: 5,),
                    Text('nesprávny názov čeľade'),
                  ],
                ), 
              ); 
            } else if(correctPlant == false && correctFamily == true){
              bgcolor = Colors.orange;
              returnText = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Skús to znova!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                    const Divider(height: 15, thickness: 0,),
                    Text('Správny názov čeľade'),
                    Container(color: bgcolor, height: 5,),
                    Text('nesprávny názov rastliny'),
                  ],
                ),
              ); 
            }
            return AlertDialog(
              backgroundColor: bgcolor,
              title: returnText,
            );
          }
        }
      },
    );
  }

  Future<void> loadGameFromPreferences()async{
    lastIndexes = [];
    usingIndexes = [];
    correctAnswers = await loadFromPreferencesInt('playedGameCorrect');
    wrongAnswers = await loadFromPreferencesInt('playedGameWrong');
    hintsUsed = await loadFromPreferencesInt('playedGameHints');
    stopWatch.milliseconds = await loadFromPreferencesInt('playedGameStopWatch');
    plantIndex = await loadFromPreferencesInt('playedGameUsingPlantIndex');
    hintsOnPlantUsed = changeToIntList(await loadFromPreferencesListOfStrings('playedGameUsingPlantHints'));
    lastIndexes = changeToIntList(await loadFromPreferencesListOfStrings('playedGameLastIndexes'));
    usingIndexes = changeToIntList(await loadFromPreferencesListOfStrings('playedGameUsingIndexes'));
    wrongAnswersList = changeToIntList(await loadFromPreferencesListOfStrings('playedGameWrongAnswersList'));
    thisGameGuessingFamily= await loadFromPreferencesBool('playedGameGuessingFamily');
  }

  List<int> findUsingIndexes(){
    List<int> returnList = [];
    plants.forEach((element) { 
      if(element.enabled == true){returnList.insert(0,plants.indexOf(element));}
    });
    return returnList;
  }
  
  bool wasPlantUsed(){
    if(usingIndexes.every((element)=>element != plantIndex)){
      return true;
    }
    return lastIndexes.any((index) => index == plantIndex);
  }

  void showHintDialog(){
    Widget ongoingHintFirstName = Text(' ${prepareHints(hintsOnPlantUsed[0], plants[plantIndex].slovakFirstName)}', style: const TextStyle(fontSize: 20,),);
    Widget ongoingHintLastName = Text('');
    
    Widget ongoingHintFamily = Text('');
    Widget familyHintText = Text('');
    Widget hintString = Text('Nápoveda: ${hintsOnPlantUsed.reduce((a, b) => a + b)}/$maxHintsOnPlant', style: const TextStyle(fontSize: 20,),);
    if(prepareHints(hintsOnPlantUsed[0], plants[plantIndex].slovakFirstName) == '?'){
      ongoingHintFirstName = GestureDetector(
        child: Text('  ---?--- ', style: TextStyle(fontSize: 30,color: themeColor.themeColorMain),),
        onTap: (){
          confirmationDynamic(
            context,
            (){
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              hintsOnPlantUsed[0] = 1;
              hintsUsed ++;
              showHintDialog();
            },
            (){
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            subtitle: Text('Chceš použiť nápovedu \npre prvý názov rastliny', style: TextStyle(fontSize: 20, color: themeColor.textColorMain),),
            title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
            positiveAnswer: 'Použiť nápovedu',
            negativeAnswer: 'Nepoužiť nápovedu'
          );
        },
      );
    }
    if(plants[plantIndex].slovakLastName != ''){
      ongoingHintLastName = Text('    ${prepareHints(hintsOnPlantUsed[1], plants[plantIndex].slovakLastName)}', style: const TextStyle(fontSize: 20,),);
      if(prepareHints(hintsOnPlantUsed[1], plants[plantIndex].slovakLastName) == '?'){
        ongoingHintLastName = GestureDetector(
          child: Text(' ---?---', style:  TextStyle(fontSize: 30,color: themeColor.themeColorMain),),
          onTap: (){
            confirmationDynamic(
              context,
              (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                hintsOnPlantUsed[1] = 1;
                hintsUsed ++;
                showHintDialog();
              },
              (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              subtitle: Text('Chceš použiť nápovedu \npre druhý názov rastliny', style: TextStyle(fontSize: 20, color: themeColor.textColorMain),),
              title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
              positiveAnswer: 'Použiť nápovedu',
              negativeAnswer: 'Nepoužiť nápovedu'
            );
          },
        );
      }
    }
    if(thisGameGuessingFamily == true){
      familyHintText = Text('Čeľad:', style: const TextStyle(fontSize: 20,),);
      ongoingHintFamily = Text(' ${prepareHints(hintsOnPlantUsed[2], plants[plantIndex].family)}', style: const TextStyle(fontSize: 20,),);
      if(prepareHints(hintsOnPlantUsed[2], plants[plantIndex].family) == '?'){
        ongoingHintFamily = GestureDetector(
          child: Text('  ---?---', style: TextStyle(fontSize: 30,color: themeColor.themeColorMain),),
          onTap: (){
            confirmationDynamic(
              context,
              (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                hintsOnPlantUsed[2] = 1;
                hintsUsed ++;
                showHintDialog();
              },
              (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              subtitle: Text('Chceš použiť nápovedu \npre čeľad rastliny', style: TextStyle(fontSize: 20,color:themeColor.textColorMain),),
              title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
              positiveAnswer: 'Použiť nápovedu',
              negativeAnswer: 'Nepoužiť nápovedu'
            );
          },
        );
      }
    }
    
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Nápoveda', style: const TextStyle(fontSize: 30,),),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rastlina:', style: const TextStyle(fontSize: 20,),),
                ongoingHintFirstName,
                ongoingHintLastName,
              ],
            ),
            Container(height: 10, width: 10, color: themeColor.themeColorBG,),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                familyHintText,
                ongoingHintFamily,
              ],
            ),
            Container(height: 10, width: 10, color: themeColor.themeColorBG,),
            hintString,
          ],
        ),
      )
    );
    setState((){});
  }

  String prepareHints(int numberOfHint, String string){
    String returnString = '';
    if(numberOfHint == 0){
      returnString = '?';
    }else if(numberOfHint == 1){
      returnString = string[0];
      for (var i = 1; i < string.length; i++) {
        returnString += ' _';
      }
    }
    return returnString;
  }

  Future<void> futureToInitState()async{
    stopWatch.start();
    if(widget.isNew == false){
      await loadGameFromPreferences();
    }
    if(widget.isNew == true){
      usingIndexes = findUsingIndexes();
      nextPlant();
      lastIndexes = [];
    }

    everySecondTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      stopWatchTime = changeMillisecondsToTime(stopWatch.elapsedMillis);
      setUnEndedGameToPreferences(correctAnswers, wrongAnswers, hintsUsed, stopWatch.elapsedMillis, plantIndex, changeToStringList(lastIndexes), changeToStringList(usingIndexes), changeToStringList(hintsOnPlantUsed), thisGameGuessingFamily, changeToStringList(wrongAnswersList));
      setState((){
      });
    });


    if(thisGameGuessingFamily == false && plants[plantIndex].slovakLastName == ''){
      maxHintsOnPlant = 1;
    } else if (thisGameGuessingFamily == false || plants[plantIndex].slovakLastName == ''){
      maxHintsOnPlant = 2;
    } else {
      maxHintsOnPlant = 3;
    }
    setState((){});
  }

  void nextPlant({bool skipped = false}){
    int usingPlants = usingIndexes.length;
    if(lastIndexes.length + 2<= usingPlants){
      lastIndexes.insert(0, plantIndex);
      plantIndex = Random().nextInt(plants.length);
      hintsOnPlantUsed = [0,0,0];
      while(wasPlantUsed()){
        plantIndex = Random().nextInt(plants.length);
      }
      if(thisGameGuessingFamily == false && plants[plantIndex].slovakLastName == ''){
        maxHintsOnPlant = 1;
      } else if (thisGameGuessingFamily == false || plants[plantIndex].slovakLastName == ''){
        maxHintsOnPlant = 2;
      } else {
        maxHintsOnPlant = 3;
      }
      setUnEndedGameToPreferences(correctAnswers, wrongAnswers, hintsUsed, stopWatch.elapsedMillis, plantIndex, changeToStringList(lastIndexes), changeToStringList(usingIndexes), changeToStringList(hintsOnPlantUsed), thisGameGuessingFamily, changeToStringList(wrongAnswersList));
    } else {
      endGame(skipped: skipped);
    }
    setState(() {});
  }

  void endGame({bool skipped = false}) async {
    DateTime now = DateTime.now();
    String nowDate = '${now.day}.${now.month}.${now.year}';
    String nowTime = await '${now.hour}:${now.minute}';
    if(now.minute<10){
      nowTime = '${now.hour}:0${now.minute}';
    }
    Navigator.of(context).pop();
    if(skipped == true){
      Navigator.of(context).pop();
    }
    await showDialog(context: context, 
      builder: (context){
        print('alert dialog END GAME');
        return AlertDialog(
          backgroundColor: themeColor.themeColorBG,
          title: const Center(
            child: Text(
              'Hra skončila!',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 30),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Tvoje score:',
                style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.w400),
              ),
              Text(
                'Správne odpovede: $correctAnswers',
                style: const TextStyle(color: Color.fromARGB(255, 1, 107, 7), fontSize: 20),
              ),
              Text(
                'Preskočené rastliny: $wrongAnswers',
                style: TextStyle(color: Colors.red[800], fontSize: 20),
              ),
              Text(
                'Použité nápovedy: $hintsUsed',
                style: TextStyle(color: Colors.yellow[700], fontSize: 20),
              ),
              Container(
                color: themeColor.themeColorBG,
                height: 10,
              ),
              Text(
                "Čas: $stopWatchTime",
                style: const TextStyle(fontSize: 20, color: Colors.black),
              )
            ],
          ),
        );
      }
    );
    
    if(skipped == true){
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          actions: [
            IconButton(
              onPressed: (){
                slovakTermInput = TextEditingController();
                familyInput = TextEditingController();
                Navigator.pop(context);
                setState((){});
              }, 
              icon: const Icon(Icons.keyboard_double_arrow_right),
            ),
          ],
          backgroundColor: Colors.red,
          buttonPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          title: Column(
            children: [
              const Text('Odpoveď bola:', style: TextStyle(fontSize: 25)),
              const Divider(height: 15, thickness: 0,),
              Text('${plants[plantIndex].slovakFirstName} ${plants[plantIndex].slovakLastName}'.toUpperCase(), style: const TextStyle(fontSize: 20)),
              const Divider(height: 15, thickness: 0, color: Colors.red,),
              Text(plants[plantIndex].family.toUpperCase(), style: const TextStyle(fontSize: 20)),
            ],
          ),
        )
      );
    }
    setUnEndedGameToPreferences(0, 0, 0, 0, 0, [], [], [], guessFamily, []);
  }
}

class LearningPage extends StatefulWidget {
  const LearningPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<LearningPage> createState() => _LearningPageState();
}
class _LearningPageState extends State<LearningPage>{
  final _biggerFont = const TextStyle(fontSize: 30, color: Colors.black);
  Widget customSearchBar = const Text('Čeľade');
  Icon searchIcon = const Icon(Icons.search);
  TextEditingController searchInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor.themeColorMain,
        title: customSearchBar,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){
              List<String> resultList = [];
              plants.forEach((element) { 
                resultList.insert(0,'${element.slovakFirstName} ${element.slovakLastName}');
              });
              familyTypes.forEach((element) {
                resultList.insert(0, element);
              });
              
              showSearch(
                context: context,
                delegate: MySearchDelegate(searchResults: resultList),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: familyTypes.length*2,
        itemBuilder: (context, index) {
          return buildFamilyListTileWidget(context,index);
        },
      )
    );
  }

  
  // Widget buildFamilyRoutePage(BuildContext context, int index){
  //   List<Plant> chosenFamilyPlantList = [];
  //   plants.forEach((plant) => {
  //     if(plant.family == familyTypes[index ~/ 2]){
  //       chosenFamilyPlantList.insert(0, plant)
  //     }
  //   });
  //   chosenFamilyPlantList.sort(((a, b) {return '${a.slovakFirstName} ${a.slovakLastName}'.compareTo('${b.slovakFirstName} ${b.slovakLastName}');}));
  //   return Scaffold(
  //       appBar: AppBar(
  //       title: Text(familyTypes[index ~/ 2]),
  //     ),
  //     body: ListView.builder(
  //       itemCount: chosenFamilyPlantList.length,
  //       itemBuilder: (context, i){
  //         return buildPlantListTile(context, chosenFamilyPlantList[i]);
  //       },
  //     )
  //   );
  // }

  // Widget buildPlantListTile(BuildContext context, Plant plant){
  //   return Column(
  //     mainAxisSize: MainAxisSize.max,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Text('${plant.slovakFirstName} ${plant.slovakLastName}', style: _biggerFont,),
  //       Image(
  //         image: AssetImage('assets/images/${plant.path}.png'),
  //         fit: BoxFit.fitWidth,
  //       ),
  //     ],
  //   );
  // }

  Widget buildFamilyListTileWidget(BuildContext context, int index){
    Color? listTileColor = themeColor.themeColorBG; 
    if(index % 4 == 0){
      listTileColor = Colors.grey[200];
    }
    if(index.isOdd){
      return const Divider(thickness: 1, color: Colors.grey, height: 5,);
    }
    return ListTile(
      title: Center(child: Text(familyTypes[index ~/ 2], style: _biggerFont,)),
      tileColor: listTileColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      onTap: (){
        List<Plant> chosenFamilyPreparedList = [];
        plants.forEach((plant) => {
          if(plant.family == familyTypes[index ~/ 2]){
            chosenFamilyPreparedList.insert(0, plant)
          }
        });
        chosenFamilyPreparedList.sort(((a, b) {return '${a.slovakFirstName} ${a.slovakLastName}'.compareTo('${b.slovakFirstName} ${b.slovakLastName}');}));
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) => PlantTile(chosenFamilyPlantList: chosenFamilyPreparedList,)
          )
        );
        setState((){});
      },
    );
  }
}

class PlantTile extends StatefulWidget {
  const PlantTile({Key? key, required this.chosenFamilyPlantList, this.index = 0}) : super(key: key);
  final int index;
  final List<Plant> chosenFamilyPlantList;

  @override
  State<PlantTile> createState() => _PlantTileState();
}
class _PlantTileState extends State<PlantTile>{
  List<LogicalKeyboardKey> keys = [];
  late int index;
  late Widget floatingActionButton1;
  late Widget floatingActionButton2;
  String? swipeDirection;
  

  @override
  void initState() {
    index = widget.index;
    initFloatingButtons();
    super.initState();
  }

  void initFloatingButtons(){
    if(index != 0){
      floatingActionButton1 = Positioned(
        bottom: 50,
        left: 30,
        child: FloatingActionButton(
          heroTag: 'btn1',
          onPressed: (){
            previousPlant();
          },
          backgroundColor: themeColor.themeColorMain,
          child: const Icon(Icons.arrow_circle_left_outlined),
        ),
      );
    } else {
      floatingActionButton1 = Positioned(
        bottom: 50,
        left: 30,
        child: Text('', style: TextStyle(color: themeColor.themeColorBG))
      );
    }

    if(index != widget.chosenFamilyPlantList.length-1){
      floatingActionButton2 = Positioned(
        bottom: 50,
        right: 30,
        child: FloatingActionButton(
          heroTag: 'btn2',
          onPressed: (){
            nextPlant();
          },
          backgroundColor: themeColor.themeColorMain,
          child: const Icon(Icons.arrow_circle_right_outlined),
        ),
      );
    } else {
      floatingActionButton2 = Positioned(
        bottom: 50,
        right: 30,
        child: Text('', style: TextStyle(color: themeColor.themeColorBG))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event){
        final key = event.logicalKey;
        if(event is RawKeyDownEvent){
          if(!keys.contains(key)){
            keys.add(key);
            if(key == LogicalKeyboardKey.arrowLeft){
              previousPlant();
            } else if (key == LogicalKeyboardKey.arrowRight){
              nextPlant();
            }
          }
        } else {
          keys.remove(key);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeColor.themeColorMain,
          title: Text(widget.chosenFamilyPlantList[index].family, style: const TextStyle(fontSize: 20, color: Colors.white),),
        ),
        body: buildBody()
      ),
    );
  }
  
  Widget buildBody(){
    if(MediaQuery.of(context).size.width < MediaQuery.of(context).size.height){
      return GestureDetector(
        onPanUpdate: (details) {
          if(details.delta.dx < -10){
            swipeDirection = 'left';
          } else if ( details.delta.dx > 10){
            swipeDirection = 'right';
          }
        },
        onPanEnd: (details){
          if (swipeDirection == null) {
          return;
          }
          if (swipeDirection == 'left') {
            nextPlant();
          }
          if (swipeDirection == 'right') {
            previousPlant();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 15),
              child: Text(
                '${widget.chosenFamilyPlantList[index].slovakFirstName} ${widget.chosenFamilyPlantList[index].slovakLastName}'.toUpperCase(), 
                style: const TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Image(
                image: AssetImage('assets/images/${widget.chosenFamilyPlantList[index].path}.png'),
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 70,
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 15, 30, 30),
                child: GestureDetector(
                  onTap: (){
                    if(widget.chosenFamilyPlantList[index].wikipediaLink != 'None'){
                      launchUrl(Uri.parse(widget.chosenFamilyPlantList[index].wikipediaLink));
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            alignment: Alignment.center,
                            title: Text(
                              'Slovenská wikipedia sa nenašla',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color:Colors.red, ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Row(
                    children: const [
                      Text(
                        'wikipedia',
                        style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, decoration: TextDecoration.underline),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.link, color:Colors.blue),
                    ],
                  )
                ),
              ),
            ),
            floatingActionButton1,
            floatingActionButton2,
          ],
        ),
      );
    } else {
      return GestureDetector(
        onPanUpdate: (details) {
          if(details.delta.dx < -10){
            swipeDirection = 'left';
          } else if ( details.delta.dx > 10){
            swipeDirection = 'right';
          }
        },
        onPanEnd: (details){
          if (swipeDirection == null) {
          return;
          }
          if (swipeDirection == 'left') {
            nextPlant();
          }
          if (swipeDirection == 'right') {
            previousPlant();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.chosenFamilyPlantList[index].slovakFirstName} ${widget.chosenFamilyPlantList[index].slovakLastName}'.toUpperCase(), 
                        style: const TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: (){
                          if(widget.chosenFamilyPlantList[index].wikipediaLink != 'None'){
                            launchUrl(Uri.parse(widget.chosenFamilyPlantList[index].wikipediaLink));
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  alignment: Alignment.center,
                                  title: Text(
                                    'Slovenská wikipedia sa nenašla',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color:Colors.red, ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            );
                          }
                        },
                        // child: Center(
                        //   child: Text(
                        //     'wikipedia',
                        //     style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, decoration: TextDecoration.underline),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'wikipedia',
                              style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, decoration: TextDecoration.underline),
                              textAlign: TextAlign.center,
                            ),
                            Icon(Icons.link, color:Colors.blue),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                VerticalDivider(color: themeColor.themeColorMain, thickness: 5, indent: 20, endIndent: 20,),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Image(
                      image: AssetImage('assets/images/${widget.chosenFamilyPlantList[index].path}.png'),
                      fit: BoxFit.contain,
                    ),
                  )
                ),
              ]
            ),
            floatingActionButton1,
            floatingActionButton2,
          ],
        ),
      );
    }
  }

  void nextPlant(){
    if(index+1 >= widget.chosenFamilyPlantList.length){
    } else {
      index++;
    }
    initFloatingButtons();
    setState(() {});
  }
  void previousPlant(){
    if(index-1 < 0){
    } else {
      index--;
    }
    initFloatingButtons();
    setState(() {});
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage ({Key? key}) : super(key: key);

  @override
  State<SettingsPage > createState() => _SettingsState();
}
class _SettingsState extends State<SettingsPage > {
  int _changeColorRadioValue = 0;
  TextStyle customTextStyle = const TextStyle(fontWeight: FontWeight.w500, fontSize: 30, );
  Color activeTrackColorCustom = Color.fromARGB(255, themeColor.themeColorMain.red, themeColor.themeColorMain.green, themeColor.themeColorMain.blue);
  TextEditingController codeController = TextEditingController();

  
  @override
  void initState(){
    if(themeColor.themeColorMain == Colors.red){
      _changeColorRadioValue = 1;
    } else if(themeColor.themeColorMain == Colors.blue){
      _changeColorRadioValue = 2;
    } else if(themeColor.themeColorMain == Colors.green){
      _changeColorRadioValue = 3;
    }
    if(_changeColorRadioValue == 1){
      activeTrackColorCustom = Color.fromARGB(255, 250, 153, 147);
    } else if(_changeColorRadioValue == 2){
      activeTrackColorCustom = Color.fromARGB(255, 106, 183, 245);
    } else if(_changeColorRadioValue == 3){
      activeTrackColorCustom = Color.fromARGB(255, 95, 220, 99);
    }
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if(_changeColorRadioValue == 1){
      activeTrackColorCustom = Color.fromARGB(255, 250, 153, 147);
    } else if(_changeColorRadioValue == 2){
      activeTrackColorCustom = Color.fromARGB(255, 106, 183, 245);
    } else if(_changeColorRadioValue == 3){
      activeTrackColorCustom = Color.fromARGB(255, 95, 220, 99);
    }
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor.themeColorMain,
        title: const Text('Nastavenia'),
      ),
      backgroundColor: themeColor.themeColorBG,
      body: ListView(
        children: [
          ExpansionTile(
            title: Center(child: Text('Zmeniť farby aplikácie', style: customTextStyle,)),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.red,
                  ),
                  Radio(
                    value: 1,
                    groupValue: _changeColorRadioValue,
                    onChanged: (value) async {
                      setState(() {
                        _changeColorRadioValue = 1;
                        themeColor.themeColorMain = changeAppBarColor(_changeColorRadioValue);                
                      });
                      setState(() { });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('themeColorMain', _changeColorRadioValue);
                    },
                  ),
                  Container(
                    width: 20,
                    height: 10,
                    color: themeColor.themeColorBG,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.blue,
                  ),
                  Radio(
                    value: 2,
                    groupValue: _changeColorRadioValue,
                    onChanged: (value) async {
                      setState(() {
                        _changeColorRadioValue = 2;
                        themeColor.themeColorMain = changeAppBarColor(_changeColorRadioValue); 

                      });
                      setState(() { });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('themeColorMain', _changeColorRadioValue);
                    },
                  ),
                  Container(
                    width: 20,
                    height: 10,
                    color: themeColor.themeColorBG,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.green,
                  ),
                  
                  Radio(
                    value: 3,
                    groupValue: _changeColorRadioValue,
                    onChanged: (value) async {
                      setState(() {
                        _changeColorRadioValue = 3;
                        themeColor.themeColorMain = changeAppBarColor(_changeColorRadioValue); 
                      });
                      setState(() { });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('themeColorMain', _changeColorRadioValue);
                    },
                  ),
                  Container(
                    width: 20,
                    height: 10,
                    color: themeColor.themeColorBG,
                  ),
                ],
              )
            ],
          ),
          ListTile(
            title: Center(child: Text('Povoliť rastliny', style: customTextStyle,)),
            trailing: IconButton(
              icon: const Icon(Icons.keyboard_arrow_right_rounded),
              onPressed: (){
                Navigator.of(context).pushNamed('plantEnablingScreen');
              },
            ),
          ),
          ListTile(
            title: Center(child:Text('Hádať aj čeľaď', style: customTextStyle)),
            trailing: Switch(
              value: guessFamily,
              onChanged: (value)async{
                
                final prefs = await SharedPreferences.getInstance();
                await (prefs.setBool('guessFamily', value));
                setState((){
                  guessFamily = value;
                  
                });
              },
              activeTrackColor: activeTrackColorCustom,
              activeColor: themeColor.themeColorMain,
            ),
          ),
          Divider(thickness: 10, color: themeColor.themeColorBG),
          ListTile(
            title: Center(child: Text('Tutoriál', style: customTextStyle,)),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => GameTutorial(imageName: 'bioFlutterMainGame', numberOfImgs: 4, tutorialPref: 'tutorialGame1_isPlayed')));
            },
          ),
          // Divider(color: themeColor.themeColorBG, thickness:1),
          // Divider(color: Colors.black, thickness:2),
          // ListTile(
          //   title: TextField(
          //     maxLength: 25,
          //     controller: codeController,
          //     decoration: const InputDecoration(
          //       border: OutlineInputBorder(),
          //       hintText: 'Kód:',
          //     ),
          //   ),
          //   trailing: IconButton(
          //     icon: Icon(Icons.open_in_new_sharp),
          //     onPressed: (){
          //       loadingCodes.forEach((key, value) {
          //         if(codeController.text == key){
          //           confirmationDynamic(
          //             context, 
          //             () { 
          //               Navigator.of(context).pop();
          //               value.forEach((element) { 
          //                 plants[element].enabled = true;
          //               });
          //             }, 
          //             () { 
          //               Navigator.of(context).pop();
          //             },
          //             subtitle: Text('Chceš zmeniť všetky povolenia rastlín podľa kódu ${codeController.text}', style: TextStyle(color:themeColor.textColorMain)),
          //             title: Text('Si si istý?', style: TextStyle(color:themeColor.textColorMain)),
          //           );
          //         } else {
          //           showDialog(context: context, 
          //             builder: (context){
          //               return AlertDialog(
          //                 alignment: Alignment.center,
          //                 backgroundColor: Colors.red,
          //                 title: Column(
          //                   children: [
          //                     Text("Nenašiel sa kód s názvom", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
          //                     Divider(color: Colors.red, thickness:5),
          //                     Text('" ${codeController.text} "', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic,),),
          //                   ],
          //                 ),
          //               );
          //             }
          //           );
          //         }
          //       });
          //     },
          //   ),
          // ),
          // Divider(color: Colors.black, thickness:2),
        ],
      )
    );
  }
}

class MySearchDelegate extends SearchDelegate{
  MySearchDelegate({required this.searchResults});
  List<String> searchResults;
  bool buildedResult = false;

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: ()=> close(context, null),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context){
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if(query.isEmpty){
            close(context, null);
          } else {
            query ='';
          }
          if(buildedResult){
            Navigator.of(context).pop();
          }
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context){
    buildedResult = true;
    List<Plant> listToInsert = [];
    List<String> unDiacriticedFamilyTypes = [];
    List<String> unDiacriticedPlants = [];
    plants.forEach((element) {unDiacriticedPlants.insert(0, removeDiacritics('${element.slovakFirstName}${element.slovakLastName}'));});
    familyTypes.forEach((element) {unDiacriticedFamilyTypes.insert(0, removeDiacritics(element));});
    if(unDiacriticedFamilyTypes.contains(removeDiacritics(query.replaceAll(' ', '')))){
      plants.forEach((element){
        if(removeDiacritics(element.family) == removeDiacritics(query.replaceAll(' ', ''))){
          listToInsert.insert(0, element);
        }
      });
      return PlantTile(chosenFamilyPlantList: listToInsert);
    } else if (unDiacriticedPlants.contains(removeDiacritics(query.replaceAll(' ', '')))){
      Plant chosenPlant = findInputtedFamily(removeDiacritics(query.replaceAll(' ', '')));
      
      plants.forEach((element){
        if(element.family == chosenPlant.family){
          listToInsert.insert(listToInsert.length, element);
        }
      });

      return PlantTile(chosenFamilyPlantList: listToInsert, index: listToInsert.indexOf(chosenPlant),);
    } else {
      return Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Pre hľadaný výraz', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 30)),
            Text( '"$query"', style: const TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w600, color: Colors.red, fontSize: 30)),
            const Text(' sa nič nenašlo', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 30))
          ],
        )
      );
    }
  }

  Plant findInputtedFamily(input){
    late Plant returnFamily;
    plants.forEach((element){
      if(removeDiacritics('${element.slovakFirstName}${element.slovakLastName}') == input){
        returnFamily = element;
      }
    });
    return returnFamily;
  }

  @override
  Widget buildSuggestions(BuildContext context){
    List<String> suggestions = searchResults.where((searchResult){
      final result = removeDiacritics(searchResult);
      final input = removeDiacritics(query.replaceAll(' ', ''));

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index){
        final suggestion = suggestions[index];

        return ListTile(
          title: Text(suggestion),
          onTap: (){
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}

class PlantEnablingPage extends StatefulWidget {
  const PlantEnablingPage({Key? key}) : super(key: key);

  @override
  State<PlantEnablingPage> createState() => _PlantEnablingPageState();
}
class _PlantEnablingPageState extends State<PlantEnablingPage> {
  bool appBarCheckBoxValue = plants.every((element) => element.enabled == true);
  TextStyle customTextStyle = const TextStyle(fontWeight: FontWeight.w500, fontSize: 30);
  TextStyle customTextStyled = const TextStyle(fontWeight: FontWeight.w400, fontSize: 20);

  @override
  void setState(VoidCallback fn) {
    appBarCheckBoxValue = plants.every((element) => element.enabled == true);
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: themeColor.themeColorBG,
      appBar: AppBar(
        backgroundColor: themeColor.themeColorMain,
        title: const Text(
          'Použité rastliny',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          Checkbox(
            activeColor: Colors.black,
            
            value: appBarCheckBoxValue, 
            onChanged: (value){
              plants.forEach((element) {
                element.enabled = (value ?? false);
                element.setToPreferences();
              });
              setState(() { });
            }
          ),
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: familyTypes.length,
        itemBuilder: (context, index){
          final List<Plant> indexFamilyList = [];
          plants.forEach((element) {
            if(element.family == familyTypes[index]){
              indexFamilyList.insert(indexFamilyList.length, element);
            }
          });
          bool allEnabled = indexFamilyList.every((element) => element.enabled
          );
          return ExpansionTile(
            leading: Checkbox(
              value: allEnabled,
              onChanged: (value){
                if(value == true){
                  indexFamilyList.forEach((element) {
                    element.enabled = true;
                    element.setToPreferences();
                  });
                } else if(value == false){
                  indexFamilyList.forEach((element) {
                    element.enabled = false;
                    element.setToPreferences();
                  });
                }
                
                setState((){});
              },
            ),
            title: Text(familyTypes[index], style: customTextStyle),
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: indexFamilyList.length,
                itemBuilder: (context, index){
                  return ListTile(
                    leading: Container(width: 30, height: 10, color: themeColor.themeColorBG,),
                    title: Text(
                      '${indexFamilyList[index].slovakFirstName} ${indexFamilyList[index].slovakLastName}', 
                      style: customTextStyled,
                    ),
                    trailing: Checkbox(
                      value: indexFamilyList[index].enabled,
                      onChanged: (value){
                        if(value == true){
                          indexFamilyList[index].enabled = true;
                        } else if (value == false){
                          indexFamilyList[index].enabled = false;
                        }
                        indexFamilyList[index].setToPreferences();
                        setState(() {});
                      },
                    )
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class GameTutorial extends StatefulWidget {
  const GameTutorial({Key? key, required this.imageName, required this.numberOfImgs, required this.tutorialPref}) : super(key: key);
  final String imageName;
  final int numberOfImgs;
  final String tutorialPref;

  @override
  State<GameTutorial> createState() => _GameTutorialState();
}
class _GameTutorialState extends State<GameTutorial> {
  late List<String> images = [];
  int onIndex = 0;
  late Widget floatingActionButton1;
  late Widget floatingActionButton2;

  @override
  void initState() {
    for(int i=1;i<widget.numberOfImgs+1;i++){
      images.insert(images.length, '${widget.imageName}$i');
      debugPrint('$images');
    }
    initFloatingButtons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor.themeColorMain,
        title: const Text(
          'Tutoriál',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Image(
              image: AssetImage('assets/tutorials/bioFlutterMainGame${onIndex+1}.png'),
              fit: BoxFit.fitHeight,
            ),
            floatingActionButton1,
            floatingActionButton2,
          ],
        ),
      )
    );
  }
  void initFloatingButtons(){
    if(onIndex != 0){
      floatingActionButton1 = Positioned(
        left: 50,
        bottom: 30,
        child: FloatingActionButton(
          heroTag: 'a',
          onPressed: (){
            debugPrint('prev');
            prev();
          },
          child: Icon(Icons.arrow_back_ios_new_rounded),
          backgroundColor: themeColor.themeColorMain,
        ),
      );
    } else {
      floatingActionButton1 = Positioned(
        bottom: 30,
        left: 30,
        child: Text('', style: TextStyle(color: themeColor.themeColorBG))
      );
    }

    if(onIndex < images.length-1){
      floatingActionButton2 = Positioned(
        right: 50,
        bottom: 30,
        child: FloatingActionButton(
          heroTag: 'b',
          onPressed: (){
            debugPrint('Next');
            next();
          },
          backgroundColor: themeColor.themeColorMain,
          child: Icon(Icons.arrow_forward_ios_rounded)
        ),
      );
    } else {
      floatingActionButton2 = Positioned(
        right: 50,
        bottom: 30,
        child: FloatingActionButton(
          heroTag: 'b',
          onPressed: (){
            debugPrint('Next');
            next();
          },
          backgroundColor: themeColor.themeColorMain,
          child: Icon(Icons.next_plan_outlined)
        ),
      );
    }
  }

  

  void next() async {
    if(onIndex < images.length-1){
      onIndex++;
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(widget.tutorialPref, true);
      Navigator.of(context).pop();
    }
    initFloatingButtons();
    setState(() {});
  }

  void prev(){
    if(onIndex > 0){
      onIndex--;
    }
    initFloatingButtons();
    setState(() {});
  }

}
