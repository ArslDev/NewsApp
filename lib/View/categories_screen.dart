import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/models/catogries_news_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/categories_news_model.dart';
import '../view_model/news_view_model.dart';
import 'home_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();


  final format = DateFormat('MMMM dd, yyyy');

  String category = 'bbc-news';
  List<String> CategoriesList =
  ['General', 'Health', 'Entertainment','Bitcoin','Sports','Asia' ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height *1;
    final width = MediaQuery.sizeOf(context).width *1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: CategoriesList.length,
                  itemBuilder:
                      (context , index) {
                    return InkWell(
                      onTap: (){
                        category = CategoriesList[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only( right: 10,left: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color:  category == CategoriesList[index] ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(19),

                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(child: Text(CategoriesList[index].toString(),style: GoogleFonts.poppins(fontSize: 13,color : Colors.white),)),
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
            Expanded(
                child: FutureBuilder<CategoriesNewsModel>(
                    future: newsViewModel.fetchCategoriesNewsApi(category),
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
                                    height : height * .20,
                                    width : width * .3,
                                    placeholder: (context , url) => Container(child: spinkit2,),
                                    errorWidget: (context, url ,error) => Icon(Icons.error_outline,color: Colors.red,),
                                  ),
                                ),
                                Expanded(child:Container(
                                  height: height * .20,
                                  padding : EdgeInsets.only(left: 15),
                                  child: Column(
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

                        );
                      }
                    }
                ),
              ),
          ],
        ),
      ),
    );
  }
}
