import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text("Home Page",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 20.0),),
          bottom: PreferredSize(
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 25.0),
              child: TabBar(
                indicatorWeight: 2.0,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Color.fromRGBO(0, 54, 107, 1.0),
                indicatorColor: Color.fromRGBO(0, 54, 107, 1.0),
                isScrollable: false,
                unselectedLabelColor: Colors.grey,

                labelPadding: EdgeInsets.only(bottom: 7.0),
                indicatorPadding:
                EdgeInsets.only(left: 15.0, right: 5.0),
                tabs: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 30.0, right: 20.0),
                    child: Text(
                        "My Courses",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0,
                             fontWeight: FontWeight.w600)
                    ),
                  ),
                  Container(
//                              margin:Translations.of(context).currentLanguage.toString().contains('ar')? EdgeInsets.only(left: 30.0, right: 30.0 ) : EdgeInsets.only(right: 30.0, left: 30.0),
                    child: Text(
                      "All Courses",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                     ),
                  ),
                  ),
                ],
              ),
             ),
            preferredSize: Size.fromHeight(50.0),
          ),
          ),
          body: TabBarView(
            children: choices.map((Choice choice) {
              return Padding(
                padding: const EdgeInsets.only(left:16.0,right: 16.0,top: 0.0),
                child: ChoicCard(choice.title,context),
              );
            }).toList(),
          ),
        ),
    );
  }

}
class Choice {
  const Choice({this.title});

  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: "All Courses"),
  const Choice(title: "My Courses")
];

class ChoicCard extends StatefulWidget {
  @override
  String _choice;
  String imgUrl;
  BuildContext ctx;
  ChoicCard(this._choice,this.ctx);

  _ChoicCardState createState() => _ChoicCardState(_choice);
}

class _ChoicCardState extends State<ChoicCard> {
  String _choice;
  _ChoicCardState(this._choice);

  final databaseReference = Firestore.instance;
  final ref = FirebaseDatabase.instance.reference();
  Map courses = new Map();
  List<String> courseTitle = new List();
  List<String> courseDescription = new List();
  List<String> courseHours = new List();
  List<String> courseStudent = new List();
  List<String> courseProfessor = new List();
  List<String> myCourseName = new List();
  List<String> courseMaterials = new List();
    String userId = "";

  currentUser()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("xxxx ${user.uid}");
    setState(() {
      userId = user.uid;
    });
  }
  getAllCourses()async{
    databaseReference
        .collection("Course")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f){

          courses = f.data;
          courseTitle.add(courses ['Title']);
          courseDescription.add(courses ['Description']);
          courseStudent.add(courses ['Limited number of students']);
          courseProfessor.add(courses ['Professor']);
          courseHours.add(courses ['Hours']);

        print('data  ${f.data}}');
        print('datas  ${courses ['Title']}}');
        print('daxxxtas  ${courses.length}}');
      });
    });
  }
  getUserCourses()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    databaseReference
        .collection("Enroll")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f){

          print("coming ${f.data['user_id']}");
          print("have ${user.uid}");
          print('xxxxaaa111');
          if(f.data['user_id'].toString() == user.uid.toString()){
            print('xxxxaaa ${f.data['enrolled_course'].toString()}');
            setState(() {
              myCourseName.add(f.data['enrolled_course'].toString());
            });
           }
      });
    });
    getCourseMaterials();
  }
  getCourseMaterials(){
    databaseReference
        .collection("Materials")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f){
          for(int i=0;i<myCourseName.length;i++){
            print("ffuu ${f.data['course_name'].toString()}");
            print("ffuu ${myCourseName[i]}");
            if(f.data['course_name'].toString() == myCourseName[i]){
              print("zzzzz");
              setState(() {
                courseMaterials.add(f.data['download_url']);
              });
            }
          }
      });
    });
  }
  bool enrolled = true;
  enrollCourse(String courseName)async{
    for(int i =0;i<myCourseName.length;i++){
      if(courseName == myCourseName[i]){
        enrolled = false;
      }
    }
    if(enrolled){

      Firestore.instance.collection('Enroll').document()
          .setData({ 'enrolled_course': courseName, 'user_id': userId });
      Toast.show("Done", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }else{
      print("error");
      Toast.show("You Already in this course", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser();
    getAllCourses();
    getUserCourses();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          margin: EdgeInsets.only(top: 25.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width ,

          child: _choice != "My Courses" ? myCourses() :allCourses()

      ),
    );
  }
  Container allCourses(){
       return Container(
      child: ListView.builder(
        itemCount: courseDescription.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
              padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
              margin: EdgeInsets.only(bottom: 15.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(.7)),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: ListTile(
                      title: Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          courseTitle[index].toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      subtitle: Container(
                        alignment: Alignment.topLeft,
                        child: Column(

                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "${courseDescription[index]}",
                                    style: TextStyle(
                                        color: Colors.grey.withOpacity(.5),
                                        fontSize: 15.0
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Hours:",
                                    style: TextStyle(
                                        color: Color(0xff2B4E72),
                                        fontSize: 15.0
                                    ),
                                  ),
                                  Text(
                                    "  ${courseHours[index]}",
                                    style: TextStyle(
                                        color: Colors.grey.withOpacity(.5),
                                        fontSize: 15.0
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor:  Color(0xff2B4E72),
                        child: Text('${courseStudent[index]}',style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0
                        ),),
                      ),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: (){
                        enrollCourse(courseTitle[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xff2B4E72),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                        ),
                        margin: EdgeInsets.only(top: 7.0),
                        padding: EdgeInsets.all(10.0),
                        child: Text("Enroll in this course",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w700),),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
  Container myCourses(){
    print('mycourse ${myCourseName.length}');
    print('maaa ${courseMaterials.length}');
    return Container(
        child: ListView.builder(
            itemCount: myCourseName.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                margin: EdgeInsets.only(bottom: 15.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(.7)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 5.0,right: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text('Course Name:',style: TextStyle(fontWeight: FontWeight.w300,color: Color(0xff2B4E72),fontSize: 15.0),),
                          ),
                          SizedBox(width: 3.0,),
                          Container(
                            child: Text('${myCourseName[index]}',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 15.0),),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0,right: 5.0),
                      padding: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color(0xff2B4E72),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: InkWell(
                        onTap: ()async{

                          if(courseMaterials.length == 0){
                            Toast.show("No Materials", context,duration: Toast.LENGTH_SHORT);
                          }else{
                            print('xxxxxxxxxx');
                            String url = courseMaterials[0];
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }
                        },
                        child: Text('Download Materials',style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.w400),),
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
    );
  }
}

