import '../model/post_data.dart';

Map apiDataAccess(PostData postData) {
  final postId = postData.id;
  final link = postData.link;
  final title = parsedHtmlString(postData.title.rendered);
  // var media = postData.banner;
  String imageUrl = postData.banner;
  // if (media!.sizes["medium_large"] != null) {
  //   imageUrl = media.sizes["medium_large"]!.sourceUrl;
  // } else if (media.sizes["large"] != null) {
  //   imageUrl = media.sizes["large"]!.sourceUrl;
  // } else if (media.sizes["full"] != null) {
  //   imageUrl = media.sizes["full"]!.sourceUrl;
  // } else {
  //   imageUrl = "";
  // }

  final shortDesc = parsedHtmlString(postData.excerpt.rendered);
  final content = parsedHtmlString(postData.content.rendered);
  // final avatarUrl = postData.embedded.author[0].avatarUrls["48"];
  final authorName = postData.author;
  final categoryIdNumbers = postData.categories;
  final date = convertJsonDate(postData.date);

  Map apiData = {
    "id": postId,
    "link": link,
    "title": title,
    "imageUrl": imageUrl,
    "shortDesc": shortDesc,
    "content": content,
    // "banner": banner,
    "authorName": authorName,
    "categoryIdNumbers": categoryIdNumbers,
    "date": date,
  };
  // print(apiData);

  return apiData;
}
