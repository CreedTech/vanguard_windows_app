import 'package:hive/hive.dart';
import 'local_db.dart';

// Functions for article save and delete
Box? codeBox;
void saveArticle({
  postId,
  imageUrl,
  title,
  shortDescription,
  content,
  date,
  authorName,
  avatarUrl,
  categoryIdNumbers,
}) {
  final value = {
    "postId": postId,
    "imageUrl": imageUrl,
    "title": title,
    "shortDescription": shortDescription,
    "content": content,
    "date": date,
    "authorName": authorName,
    "avatarUrl": avatarUrl,
    "categoryIdNumbers": categoryIdNumbers,
  };
  final saveArticle = SaveArticle()..articleData = value;

  final key = postId.toString();
  final box = Hive.box('saveposts');
  box.put(key, saveArticle);
}

void deleteSavedArticle({postId}) {
  final box = Hive.box('saveposts');
  box.delete("$postId");
}

// Functions for notification save and delete
void saveNotification({notificationId, title, body}) {
  final notificationData = {
    "notificationId": notificationId,
    "title": title,
    "body": body,
  };
  final saveNotification = SaveNotification()
    ..notificationData = notificationData;

  final key = notificationId.toString();
  final box = Hive.box('savenotification');
  box.put(key, saveNotification);
}

void deleteSavedNotifcation() {
  Hive.box('savenotification').clear();
}