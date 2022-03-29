import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  List<String> languages = ['English','Hausa'];
  List  lang = [
    {
      'name':'English',
      'head':'Emergency Help needed?',
      'sub':'Select an emergency',
      'items':['Public/Security','Fire Alert','Hospital/ Medical /Accident','Gender Based Violence','Family Crises','Kidnapping'],
      'company':['Police Force','Fire Service','Hospital Emergency','GBV agency','Family Crises Unit','Police Force/Kidnapping']
    },
    {
      'name':'Hausa',
      'head':'Ana Bukatan Taimako?',
      'sub':'Zabi taimakon da ake bukata',
      'items':['Tsaro','Gobara','Kiwon Lafia /Hatsari','Fyade','Rikicin Iyali','Yan garkuwa da Mutane'],

    }
  ];
  String dropDownValue = "English";
  var selected;
  void setLang(val) {
    if(val =='English'){
      selected = lang[0];
    }
    if(val =='Hausa'){
      selected = lang[1];
    }
  }
  @override
  void initState() {
    super.initState();
    selected = lang[0];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton(
              value: dropDownValue,
              icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.lightBlueAccent,
              ),
              items:languages
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                      value,
                  ),
                );
              }).toList(),
              elevation: 16,
              onChanged: (String? newValue) {
                setState(() {
                  dropDownValue = newValue!;
                });
                setLang(newValue);
              },
              style: const TextStyle(
                  color: Colors.lightBlueAccent,
              ),
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 170.0,),
            Expanded(
              child: ClipRect(
                child:Image.asset(
                  'assets/logo.png',
                  height: 60,
                ) ,
              ),
            ),
          ],
        ),
        elevation: 0.0,
      ),
      body: Column(
        children:[
          Container(
            padding:const EdgeInsets.fromLTRB(50, 30, 50, 5),
            child:  Text(
                selected['head'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color:Colors.blueAccent
                )
            ),
          ),
          Image.asset('assets/location.png',

          ),
          Text(
              selected['sub'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 25,
                  color:Colors.blueAccent,
              )
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2
              ),
              itemCount: selected['items'].length,
              padding: const EdgeInsets.all(30.0),
              itemBuilder: (BuildContext context, int index){
                return  Padding(
                  padding: const EdgeInsets.fromLTRB(5, 40, 5, 20),
                  child:ElevatedButton(
                    onPressed: () async{
                      var dialect = selected['name'];
                      var reportType = lang[0]['company'][index];
                      await Navigator.pushNamed(context, '/reportDetails', arguments: {
                        'language':dialect,
                        'reportType':reportType
                        }
                      );
                    },
                    child: Text(selected['items'][index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color:Colors.blueAccent
                        )
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white)
                    ),
                  ),
                );
              },
            ),
          )
        ]
      ),
    );
  }
}
