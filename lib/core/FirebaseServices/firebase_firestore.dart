import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Data/restaurant_model.dart';

abstract class FireBaseFirestoreServices {
// function 3shan tt3aml m3 firestore w trg3 esm el collection
  static CollectionReference<RestaurantDataModel> getCollectionRef() {
    //singelton class bakhod mno object w a3del 3aleh
    // b set esm el collection (table) ,
    // w byrg3le el collection kolo bkol el docs el feh,
    // do converter
    return FirebaseFirestore.instance
        .collection(RestaurantDataModel.collectionName)
        .withConverter<RestaurantDataModel>(
          //snapshot da el doc el gy mn firesotre(map<string , dynamic >) btakhdo w thawelo l object mn no3 eventDataModel
          // from firestore 3ndha parameter map string w dynamic
          // badeha el snapshot.data 3shan el parameter
          fromFirestore: (snapshot, _) =>
              RestaurantDataModel.fromFireStore(snapshot.data()!),
          toFirestore: (eventModel, _) => eventModel.toFireStore(),
        ); // bstkhdmha 3shan a read w write data
  }

  // function t create new Restaurant
  // static Future<bool> createNewRestaurant(RestaurantDataModel eventData) async {
  //   try {
  //     //awl haga a3mlha eni ageb el collection ref
  //     var collectionRef = getCollectionRef();
  //
  //     var docRef = collectionRef.doc(); //create new doc in collection
  //
  //     eventData.eventID = docRef.id;
  //     //b2olo yhotele el value bt3t el id fl object mn l id el hwa auto generated fe el firestore
  //
  //     docRef.set(eventData);
  //     //b2olo y create el data bl object el m3aia mn eventDataModel
  //     // yroh yb3to l function to firestore w thawelo l map w tb3to
  //     // mesh 7ata await hna 3shan ana msh mestnya data trg3 lw kan fe haga rg3a kan lazm await
  //
  //     return Future.value(true);
  //   } catch (error) {
  //     return Future.value(false);
  //   }
  // }

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


}
