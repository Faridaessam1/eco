import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_eaters_app_3/Data/dish_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../Data/order_data_model.dart';

abstract class FireBaseFirestoreServicesSeller {

  Future<void> addDishSubCollection(String sellerId, DishDataModel dish) async {
    DocumentReference sellerDocRef = FirebaseFirestore.instance.collection('users').doc(sellerId);
    await sellerDocRef.collection('dishes').add(dish.toFireStore());
  }

  Future<void> createOrderSubCollection(String sellerId, String customerId, OrderDataModel order) async {
    DocumentReference sellerDocRef = FirebaseFirestore.instance.collection('users').doc(sellerId);
    DocumentReference customerDocRef = FirebaseFirestore.instance.collection('users').doc(customerId);

    // إضافة الطلب في مجموعة "orders" الخاصة بـ Seller
    await sellerDocRef.collection('orders').add(order.toFireStore());

    // إضافة الطلب في مجموعة "orders" الخاصة بـ Customer
    await customerDocRef.collection('orders').add(order.toFireStore());
  }

  static Future<void> getSellerProfileData({
    required TextEditingController businessNameController,
    required TextEditingController contactPersonController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
    required Function(String) onAddressSelected,
    required Function(String?) onBusinessTypeSelected,
    required Function(String?) onOperatingHoursSelected,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
try{
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserId)
      .get();

  if (doc.exists) {
    final data = doc.data()!;

      businessNameController.text = data['businessName'] ;
      contactPersonController.text = data['contactPerson'];
      phoneController.text = data['phone'] ;
      emailController.text = data['email'] ;

      onAddressSelected(data['city']?.toString().trim() ?? 'No address available');
      onBusinessTypeSelected(data['businessType']?.toString().trim());
      onOperatingHoursSelected(data['operatingHours']?.toString().trim());

  }
} catch(e){
  print("Error fetching seller data: $e");
}
  }

  // update function
  static Future<bool> updateSellerProfile({
    required String businessName,
    required String contactPerson,
    required String phone,
    required String email,
    required String city,
    required String operatingHours,
    String? businessType,
  }) async {
    try {
      var userId =
          FirebaseAuth.instance.currentUser?.uid; // Get the current user's ID

      if (userId != null) {
        // Reference to the user document
        var userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);

        // Check if the document exists
        var docSnapshot = await userDocRef.get();
        if (!docSnapshot.exists) {
          print("No document found for the current user.");
          return false;
        }

        // Update the fields inside the user document
        await userDocRef.update({
          'businessName': businessName,
          'contactPerson': contactPerson,
          'phone': phone,
          'email': email,
          'city': city,
          'operatingHours': operatingHours,
          'businessType': businessType ?? docSnapshot.data()?['businessType'],
          // Retains old value if businessType is null
        });

        return true;
      }
      return false;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
}

//functions trg3 el data mn database (read data)
//   static Future <List<RestaurantDataModel>> getDataFromFirestore(String categoryName) async {
//     var collectionRef = getCollectionRef().where(
//       "eventCategory" , isEqualTo: categoryName,
//     );
//
//     //3ayza arg3 data(docs) el fl collection
//     QuerySnapshot<EventDataModel> data = await collectionRef.get();
//
//     // bs el data btrg3 b no3 mokhtlf shewia
//     //Future<QuerySnapshot<EventDataModel>>
//     // hn3mlha mapping 3shan n7wel no3ha w y loop 3ala el list of doc
//
//     // 3nde list of QuerySnapshot<EventDataModel> el hya f variabl el data
//     // 3yza a7welha ll model bta3e el trg3 be yeb2a mapping
//     List<EventDataModel> eventDataList = data.docs.map(
//           (element) {
//             return element.data();
//           },
//         )
//         .toList();
//     return eventDataList;
// // ana hna 3mlt el map gwa el function l2en k future l data btrg3 mra whda bs
//   // kol ma bndah el function btgeb data t7welha w trg3ha
//   }
  // static Stream<QuerySnapshot<EventDataModel>> getStreamData(String categoryName){
  //   Query<EventDataModel> collectionRef = getCollectionRef();
  //
  //   if (categoryName != "All") {
  //     collectionRef = collectionRef.where(
  //       "eventCategory",
  //       isEqualTo: categoryName,
  //     );
  //   }
  //
  //
  //   return collectionRef.snapshots();
  //   //bnrg3 el collection as stream
  //   //once 7sal change aw update yrg3hole f wa2tha msh shart a3mle refresh
  //
  //   //fl stream bn3ml el map hnak fl stream builder
  //   //l2en hwa bygeb l data 3la tol kol ma y7sal change
  //   // msh hyro7 yndah el function 3shan ygeb data
  //   //lazm el data tthawel mngher ma andh function
  //
  // }

//function trg3 stream data llfavorite page
//   static Stream<QuerySnapshot<EventDataModel>> getStreamFavoriteData(){
//     var collectionRef = getCollectionRef().where(
//       "isFavorite", isEqualTo : true,
//     );
//
//
//
//     return collectionRef.snapshots();
//     //bnrg3 el collection as stream
//     //once 7sal change aw update yrg3hole f wa2tha msh shart a3mle refresh
//
//     //fl dtream bn3ml el map hnak fl stream builder
//     //l2en hwa bygeb l data 3la tol kol ma y7sal change
//     // msh hyro7 yndah el function 3shan ygeb data
//     //lazm el data tthawel mngher ma andh function
//
//   }

  // static Future<bool> deleteEvent(EventDataModel data) async{
  //   try{
  //     var collectionRef = getCollectionRef();
  //
  //     var docRef = collectionRef.doc(data.eventID);
  //
  //     docRef.delete();
  //     return Future.value(true);
  //   } catch(error){
  //     return Future.value(false);
  //
  //   }
  //
  // }
  // static Future<bool> updateEvent(EventDataModel data) async{
  //   try{
  //     var collectionRef = getCollectionRef();
  //
  //     var docRef = collectionRef.doc(data.eventID);
  //
  //     docRef.update(
  //       data.toFireStore(),
  //     );
  //     return Future.value(true);
  //   } catch(error){
  //     return Future.value(false);
  //
  //   }
  //
  // }
