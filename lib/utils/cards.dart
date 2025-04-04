


import 'package:flutter/material.dart';



class CardsUser extends StatelessWidget {

  final user;
  final email;
  final phone;
  final image;
  bool has_products = false;

  CardsUser(this.user, this.has_products, {this.phone,this.email, this.image, super.key});


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // FadeInImage.assetNetwork(
            //     placeholder: 'assets/img/placeholder.jpg',
            //     image: this.image),
            CircleAvatar(
              radius: 40,
              backgroundImage: image != null ? NetworkImage(image) : null ,

            ),
            Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user,style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),),
                  Text('Tel: ${phone ?? ''}'),
                  Text("Email: ${email ?? ''} "),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  has_products ? const Icon(Icons.shopping_cart, color: Colors.green) : Container(),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
