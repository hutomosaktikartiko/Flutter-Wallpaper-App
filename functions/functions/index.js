const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp();
const fcm = admin.messaging();

exports.sendNewWallpaperNotification = functions.firestore
  .document("wallpapers/{wallpaperId}")
  .onCreate((snapshot) => {
    const data = snapshot.data();

    var payload = {
      notification: {
        title: "WallyApp",
        body: "New Wallpaper is here",
      },
      icon:
        "https://firebasestorage.googleapis.com/v0/b/wallyapp-34e0a.appspot.com/o/logo_circle.png?alt=media&token=aa34f2fd-aba6-44c6-a9db-f7e85015de66",
      image: data.url,
    };

    const topic = "promotion";

    fcm.sendToTopic(topic, payload);
  });
