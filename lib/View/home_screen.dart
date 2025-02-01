import 'package:news_app/View/categories_screen.dart';
import 'package:news_app/models/news_channels_headlines_model.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../models/categories_news_model.dart';
import '../models/catogries_news_model.dart';


class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}
enum FilterList {bbcNews, aryNews , Independence , cnn , Aljazeera}

class _homeScreenState extends State<homeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;

  final format = DateFormat('MMMM dd, yyyy');

  String name = 'bbc-news';
  @override
  Widget build(BuildContextcontext) {
    final height = MediaQuery.sizeOf(context).height *1;
    final width = MediaQuery.sizeOf(context).width *1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoriesScreen()));
        }, icon: Image.asset('Images/category_icon.png' ,height: 25,)),
        title: Center(child: Text('News',style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),)),
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              icon: Icon(Icons.more_vert,color: Colors.black,),
              onSelected: (FilterList item) {

                if(FilterList.bbcNews.name == item.name){
                  name = 'bbc-news';
                }
                if(FilterList.aryNews.name == item.name){
                  name = 'ary-news';
                }
                if(FilterList.cnn.name == item.name){
                  name = 'cnn';
                }
                if(FilterList.Aljazeera.name == item.name){
                  name = 'al-jazeera-english';
                }
                if(FilterList.Independence.name == item.name){
                  name = 'hacker-news';
                }
                setState(() {});
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
                PopupMenuItem<FilterList>(
                    value: FilterList.bbcNews ,
                    child: Text('BBC News')),
                PopupMenuItem<FilterList>(
                    value: FilterList.aryNews ,
                    child: Text('ARY News')),
                PopupMenuItem<FilterList>(
                    value: FilterList.Independence ,
                    child: Text('Hacker News')),
                PopupMenuItem<FilterList>(
                    value: FilterList.cnn ,
                    child: Text('CNN News')),
                PopupMenuItem<FilterList>(
                    value: FilterList.Aljazeera ,
                    child: Text('Aljazeera News')),
              ])
        ],
      ),

      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: height * .55,
                width: width,
                child: FutureBuilder<NewsChannelsHeadlinesModel>(
                    future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
                    builder: (BuildContext  context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: SpinKitCircle(
                            size: 50,
                            color: Colors.blue,
                          ) ,
                        );
                      }
                      else {
                        return ListView.builder(itemBuilder: (context,index){
                          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return  SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.6,
                                  width: width * .9,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: height * .02,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString() ,
                                      fit: BoxFit.cover,
                                      placeholder: (context , url) => Container(child: spinkit2,),
                                      errorWidget: (context, url ,error) => Icon(Icons.error_outline,color: Colors.red,),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  child: Card(
                                    elevation: 9,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      alignment: Alignment.bottomCenter,
                                      height: height * .22,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.7,
                                            child: Text(snapshot.data!.articles![index].title.toString(), style:
                                            GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.bold),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: width * 0.7,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(), style:
                                                GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.blue),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,),
                                                Text(format.format(dateTime), style:
                                                GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ],

                            ),
                          );
                        },
                          itemCount: snapshot.data!.articles!.length,
                          scrollDirection: Axis.horizontal,

                        );
                      }
                    }
                ),
              ),
            ),
          ),
          SizedBox(height: 4,),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(10),
                child: FutureBuilder<CategoriesNewsModel>(
                    future: newsViewModel.fetchCategoriesNewsApi('bbc'),
                    builder: (BuildContext  context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(
                          child: SpinKitCircle(
                            size: 50,
                            color: Colors.blue,
                          ) ,
                        );
                      }
                      else {
                        return ListView.builder(itemBuilder: (context,index){
                          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString() ,
                                    fit: BoxFit.cover,
                                    height : height * .18,
                                    width : width * .3,
                                    placeholder: (context , url) => Container(child: spinkit2,),
                                    errorWidget: (context, url ,error) => Icon(Icons.error_outline,color: Colors.red,),
                                  ),
                                ),
                                Expanded(child:Container(
                                  height: height * .18,
                                  padding : EdgeInsets.only(left: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(snapshot.data!.articles![index].title.toString(), maxLines: 3,style:
                                      GoogleFonts.poppins(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w600),),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(snapshot.data!.articles![index].source!.name.toString(),style:
                                          GoogleFonts.poppins(fontSize: 13,color: Colors.blue,fontWeight: FontWeight.w500),),
                                          Text(format.format(dateTime),style:
                                          GoogleFonts.poppins(fontSize: 13,color: Colors.black54,fontWeight: FontWeight.w500),),

                                        ],)
                                    ],
                                  ),
                                ) )
                              ],
                            ),
                          ) ;
                        },
                          itemCount: snapshot.data!.articles!.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,

                        );
                      }
                    }
                ),
              ),
            ),
        ],
      ),

    );
  }
}
const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);