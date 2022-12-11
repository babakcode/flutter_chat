importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js");

//Using singleton breaks instantiating messaging()
// App firebase = FirebaseWeb.instance.app;


firebase.initializeApp({
apiKey: "AIzaSyC7lfF_K5-Wktm6DSv5ZoNk18F1MvVpQAI",
authDomain: "babakcode-chat.firebaseapp.com",
projectId: "babakcode-chat",
storageBucket: "babakcode-chat.appspot.com",
messagingSenderId: "69437946182",
appId: "1:69437946182:web:3ca0be4cb3f2caa0284d47",
measurementId: "G-M8P6YDB49X"
});

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});