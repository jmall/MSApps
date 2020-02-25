

class Movies{
  int id;
  String title;
  String image;
  double rating;
  int releaseYear;
  String genere;
  static final columns = ["id", "title", "image", "rating", "releaseYear", "genere"];

  Movies(this.title, this.image, this.rating, this.releaseYear);

  Map<String, dynamic> toMap() => {
    "id" : id,
    "title": title,
    "image": image,
    "rating": rating,
    "releaseYear": releaseYear,
    "genere": genere
  };

  Movies.fromJson(Map<String, dynamic> data)
      : id = data['id'] as int,
        title = data['title'] as String,
        image = data['image'] as String,
        rating = data['rating'].toDouble() as double,
        releaseYear = int.parse(data['releaseYear']),
        genere = data['genere']?.cast<String>();

}