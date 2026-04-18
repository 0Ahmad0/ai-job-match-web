// Firebase Messaging Service Worker for Web Push Notifications
// Place this file in your web/ directory

// Import Firebase scripts
importScripts('https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.8.0/firebase-messaging-compat.js');

// Initialize Firebase with your configuration
firebase.initializeApp({
  apiKey: "AIzaSyBQfwZw-3Y9UCQxUaRNDEfD775-Pgz3w5M",
  appId: "1:14038176626:web:2b9405242071c91c4943eb",
  messagingSenderId: "14038176626",
  projectId: "ai-job-matcher-88f00",
  authDomain: "ai-job-matcher-88f00.firebaseapp.com",
  storageBucket: "ai-job-matcher-88f00.firebasestorage.app",
  measurementId: "G-649K0BC4CS",
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  const notificationTitle = payload.notification.title || 'Default Title';
  const notificationOptions = {
    body: payload.notification.body || 'Default body',
    icon: payload.notification.icon || '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    data: payload.data,
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification click
self.addEventListener('notificationclick', function(event) {
  console.log('[firebase-messaging-sw.js] Notification click received.');

  event.notification.close();

  // This looks for a window client and focuses it, or opens a new window
  event.waitUntil(
    clients.matchAll({ type: 'window' }).then((clientList) => {
      for (const client of clientList) {
        if (client.url.includes(self.location.origin) && 'focus' in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow('/');
      }
    })
  );
});
