import 'package:flutter/material.dart';

class Submitted extends StatefulWidget {
  const Submitted({Key? key}) : super(key: key);

  @override
  State<Submitted> createState() => _SubmittedState();
}

class _SubmittedState extends State<Submitted> {
  Map data = {};
  Map instructions ={
    'English':{
      'Police Force':[],
      'Fire Service':['Try not to panic',
        'Tell everyone in the building/area',
        'Use your pre planned escape route to get everyone out of the building if there is not escape the building any way possible',
        'Use an escape tool, Smoke will rises so stay as low as possible or crawl while escaping around the cleaner air where its easy to breath',
        'Do not stop to collect valuables or possessions',
        'Do not stop to look for pets',
        'If possible, close the door to th room where the fire is located and close all doors you left behind to delay the spread of fire and smoke',
        'Before opening a closed door check it with the back of your hand, do not open if you feel warm- the fire will be on the other side',
        'If you escaped do not go back to the build for whatsoever reason find a safe place as fire service are arriving soon',
        'If someone is still in the building tell the fire service personnel when they arrive',
        'Note If you go back to the building you are putting yourself at risk'
      ],
      'Hospital Emergency':['Get yourself and your vehicle out of danger',' Determine whether anyone is hurt and help them out','Avoid roadside discussions about responsibility',],
      'GBV agency':['Go Someplace Safe','Leave Your Body As Is','Get Medical Treatment as soon as possible','Take STD and HIV Test'],
      'Family Crises Unit':[],
      'Police Force/Kidnapping':['Wait for police Personnel','Dont give ransom','Document or Record Everything the kidnappers said if they called']
    },
    'Hausa':{
      'Police Force':[
      ],
      'Fire Service':[
        'Kada a Tsorata',
        'Asanar ma duk wanda yake cikin gidan',
        'Ayi saurin kokarin Tsere wa daga cikin gidan ta kowani hali ',
        'Hayaki Sama yake tashi asunkuyadda kai yayin Tserewa ko kuma ararrafa',
        'A yi kokarin shakan numpashi maras hayaki yayin Tserewa',
        'Kada ayi kokarin Tsayawa daukan kaya ko wani iri neh',
        'Rayuwa tafi komi',
        'Arufe dakin da wutan yatashi kuma A rufe ko wani kofa da aka wuce in da hali',
        'A taba kofan da bayan hannu kafun a bude, in da zafi to akwai wuta a dakin',
        'Kada a koma cikin gida ko menene dalilin a samu wani wuri a gefen gidan a zauna a jira maikatan kashe gobara suna hanyan zuwa',
        'Idan akwai mutum a gidan a fada ma ma aikatan kashe gobara in sun iso da dukkan bayanai'
      ],
      'Hospital Emergency':['Afita daga cikin abun hawa ko hatsari','A duba ko akwai masu rauni a taimaka musu','Kada a tsaya kallo ko hira a gefen titi ko kusada hatsari'],
      'GBV agency':['A neme wuri mai kyau a zauna','Abar Jiki a yanda yake','A samu ganin hukomomin lafia nan take','Tayi gwajin cutar STD da Kwayar sida'],
      'Family Crises Unit':[],
      'Police Force/Kidnapping':['A jira maikata suna zuwa','Kada a bada kudin fansa','A rubuta ko a yi recording abun da ya Garkuwan suka fada in sun kira']
    }
  };
  Map lang = {
  'English': {
  'header': 'Report Submitted',
    'subheader':'Your Report has been submitted to the rightful authorities.'

  },
  'Hausa': {
  'header': 'Rahoto ya turu',
    'subheader':'An tura rahotonka ga mahukuntan da ya dace'

    }
  };

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute
        .of(context)
        ?.settings
        ?.arguments as Map;
    var dialect = data['language'];
    var reportType = data['reportType'];
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 15.0,),
             Center(
                child:  Text(
                    lang[dialect]['header'],
                    style: const  TextStyle(
                        color: Colors.white
                    )
                )
            ),
            const SizedBox(width: 10.0,),
            Expanded(
              child: ClipRect(
                child: Image.asset(
                  'assets/logo.png',
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFixedExtentList(
            itemExtent: 200.0,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Column(
                    children: [
                      const SizedBox(height: 20,),
                      const Center(
                          child: Icon(Icons.check_circle_outline,
                            color: Colors.green,
                            size:40,
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                            child: Text(
                                lang[dialect]['subheader'],
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueGrey
                                )
                            )
                        ),
                      ),
                    ],
                  );
              },
              childCount: 1,
            ),
          ),

          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return  ListTile(
                          title: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            '${index+1} ${instructions[dialect][reportType][index]}',
                             style: const TextStyle(
                               fontSize: 15,
                                color: Colors.blueGrey
                               )
                             ),
                           ),
                      );
              },
              childCount: instructions[dialect][reportType].length,
            ),
          ),
        ],
      )
    );
  }
}
