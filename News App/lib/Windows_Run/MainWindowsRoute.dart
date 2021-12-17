import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/Model/news.dart';
import 'package:news_app/NetWork/api_request.dart';
import 'package:news_app/Screen/news_details.dart';
import 'package:news_app/State/state_managment.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_riverpod/all.dart';

class MainWindowsRoute extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.teal,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      title: "News App",
      onGenerateRoute: (settings){
        switch(settings.name){
          case '/detail':{
            return PageTransition(child: MyNewDetail(), type: PageTransitionType.fade , settings: settings);
          }
          default:{
            return null;
          }
        }
      },
      home: MainWindowsPage(),
    );
  }

}

class MainWindowsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _MainWindowsPageState();

}

class _MainWindowsPageState extends State<MainWindowsPage> with SingleTickerProviderStateMixin{

  final List<Tab> tabs = <Tab>[
    Tab(text: "General"),
    Tab(text: "Technology"),
    Tab(text: "Sports"),
    Tab(text: "Business"),
    Tab(text: "Entertaiment"),
    Tab(text: "Health"),
  ];

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("News App"),
        bottom: TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BubbleTabIndicator(
            indicatorColor: Colors.teal,
            indicatorHeight: 25.0,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: tabs,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((tab){
          return FutureBuilder(
              future: fetchNewsByCategory(tab.text),
              builder: (context , snapshot){
                if(snapshot.hasError)
                  return Center(child: Text('${snapshot.error}'),);

                else if(snapshot.hasData){
                  News newsList = snapshot.data as News;
                  //Select 10 Top
                  //If length > 10 , we will get from 0~10
                  //If length < 10 , we will get from 0~x
                  //If length == null , we will get 0
                  var sliderList = newsList.articles != null ?
                  newsList.articles.length > 10 ?
                  newsList.articles.getRange(0, 10).toList()
                      : newsList.articles.take(newsList.articles.length).toList()
                      : [];

                  //Select articles excepts top 10
                  var contentList = newsList.articles != null ?
                  newsList.articles.length > 10 ?
                  newsList.articles.getRange(11,  newsList.articles.length -1).toList()
                      :[]
                      :[];

                  return SafeArea(
                      child: Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                                aspectRatio: 16/9,
                                enlargeCenterPage: true,
                                viewportFraction: 0.8
                            ),
                            items: sliderList.map((item) {
                              return Builder(builder: (context){
                                return GestureDetector(
                                  onTap: (){
                                    context.read(urlState).state = item.url;
                                    Navigator.pushNamed(context, '/detail');
                                  },
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Image.network(
                                            '${item.urlToImage}',
                                            fit: BoxFit.cover,)
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            color: Color(0xAA333639),
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                '${item.title}',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                            }).toList(),
                          ),
                          Divider(thickness: 3,),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text("Trending*" , style: TextStyle(fontSize: 26 , fontWeight: FontWeight.bold),),),
                          Divider(thickness: 3,),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: contentList.length,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      onTap: (){
                                        context.read(urlState).state = contentList[index].url;
                                        Navigator.pushNamed(context, '/detail');
                                      },
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network('${contentList[index].urlToImage}' , fit: BoxFit.cover, height: 80, width: 80,),
                                        ),
                                        title: Text('${contentList[index].title}' , style: TextStyle(fontWeight: FontWeight.bold),),
                                        subtitle: Text("${contentList[index].publishedAt}", style: TextStyle(fontStyle: FontStyle.italic),),
                                      ),
                                    );
                                  })
                          )
                        ],
                      )
                  );
                }
                else
                  return Center(child: CircularProgressIndicator(),);
              });
        }).toList(),
      ),
    );
  }

}