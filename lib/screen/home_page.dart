import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(onPressed: (){}, icon: Icon((Icons.arrow_back_ios),size: 35,)),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        title: Text('Add Image / Icon',style: TextStyle(
          fontSize: 28,
          fontStyle: FontStyle.italic,
          color: Colors.black.withOpacity(0.6)
        ),),
        centerTitle: true,
      ),
      body: SafeArea(child:
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Upload Image',style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22
                ),),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                    height: 50,
                    width: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.teal
                    ),
                    child: Center(
                      child: Text('Choose from Device',style: TextStyle(
                        color: Colors.white,
                        fontSize: 22
                      ),),
                    ),
                  ),
                )
              ],
            ),
          )
        ],),
      )),
    );
  }
}
