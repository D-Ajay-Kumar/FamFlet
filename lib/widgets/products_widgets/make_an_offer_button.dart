// import 'package:flutter/material.dart';

// class MakeAnOfferButton extends StatelessWidget {
//   const MakeAnOfferButton({
//     @required this.width,
//     @required this.height,
//   });
//   final double width;
//   final double height;

//   @override
//   Widget build(BuildContext context) {
//     return ButtonTheme(
//       height: height * 0.06,
//       minWidth: width * 0.4,
//       buttonColor: const Color(0xff000000),
//       child: RaisedButton(
//         onPressed: () {
//           return showModalBottomSheet(
//             backgroundColor: Colors.transparent,
//             context: context,
//             builder: (BuildContext context) {
//               return SingleChildScrollView(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xffffffff),
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(width * 0.03),
//                         topRight: Radius.circular(width * 0.03)),
//                   ),
//                   height: height * 0.5,
//                   child: Center(child: TextField()),
//                 ),
//               );
//             },
//           );
//         },
//         textColor: const Color(0xffffffff),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
//         child: Text(
//           'Make An Offer',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
// }
