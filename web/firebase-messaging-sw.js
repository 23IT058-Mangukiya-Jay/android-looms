// Firebase Cloud Messaging Service Worker
// Required for FCM push notifications on Flutter Web

importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyCYHCiysB6r-DWFzLdhgDwyaArQYrd6m9E',
  appId: '1:158650970118:web:f88cfe48990a48c3a8d387',
  messagingSenderId: '158650970118',
  projectId: 'mobile-looms',
  authDomain: 'mobile-looms.firebaseapp.com',
  storageBucket: 'mobile-looms.firebasestorage.app',
  measurementId: 'G-EQGNFJ16DD',
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function (payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  const notificationTitle = payload.notification?.title || 'Looms Management';
  const notificationOptions = {
    body: payload.notification?.body || '',
    icon: '/icons/Icon-192.png',
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
