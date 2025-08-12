import '../models/venue.dart';
class PlacesRepository {
  Future<List<Venue>> sample() async {
    return [
      Venue(id:'v1', name:'Fabrika Courtyard', type:'bar', lat:41.7106, lng:44.8015, rating:4.5, priceLevel:2, priceBand:'mid', address:'8 Egnate Ninoshvili St', photoUrl:'https://images.unsplash.com/photo-1528605248644-14dd04022da1?w=1200', tags:['terrace','live_music'], openNow:true, district:'Marjanishvili', queueMinutes:10, noise:3),
      Venue(id:'v2', name:'Stamba Café', type:'restaurant', lat:41.7099, lng:44.7894, rating:4.6, priceLevel:3, priceBand:'high', address:'14 Merab Kostava St', photoUrl:'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=1200', tags:['late_kitchen'], openNow:true, district:'Vera', queueMinutes:5, noise:2),
      Venue(id:'v3', name:'Lolita', type:'bar', lat:41.7059, lng:44.7908, rating:4.4, priceLevel:2, priceBand:'mid', address:'7 Tamar Chovelidze St', photoUrl:'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200', tags:['terrace'], openNow:true, district:'Vera', queueMinutes:8, noise:3),
      Venue(id:'v4', name:'Bassiani', type:'club', lat:41.7177, lng:44.8217, rating:4.7, priceLevel:3, priceBand:'high', address:'2 Akaki Tsereteli Ave', photoUrl:'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=1200', tags:['live_music'], openNow:false, district:'Didube', queueMinutes:25, noise:5),
    ];
  }
}
