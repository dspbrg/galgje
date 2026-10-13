// =============================================================
// Service worker voor Galgje
//
// Doel: de app start en werkt zonder internet.
//   - bij installatie alles in de cache zetten
//   - daarna eerst uit de cache serveren, en op de achtergrond verversen
//   - bij een nieuwe versie (andere CACHE) de oude weggooien
//
// De woordenlijsten komen uit Overhoren (../overhoren/lists.js) en
// worden ook gecachet, zodat alleen spelen offline blijft werken.
// De versie wordt bij elke build door build.sh vervangen.
// =============================================================
const VERSIE = "20261013104638";
const CACHE = "galgje-" + VERSIE;

const SCHIL = [
  "./", "./index.html", "./manifest.json",
  "./icons/icoon-192.png", "./icons/icoon-512.png",
  "../overhoren/lists.js"
];

self.addEventListener("install", e => {
  e.waitUntil(caches.open(CACHE).then(c => Promise.allSettled(SCHIL.map(u => c.add(u)))).then(() => self.skipWaiting()));
});

self.addEventListener("activate", e => {
  e.waitUntil(
    caches.keys()
      .then(namen => Promise.all(namen.filter(n => n.startsWith("galgje-") && n !== CACHE).map(n => caches.delete(n))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", e => {
  const req = e.request;
  if (req.method !== "GET") return;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return;   // fonts gaan gewoon naar het net

  e.respondWith(
    caches.match(req, { ignoreSearch: true }).then(hit => {
      const vers = fetch(req).then(res => {
        if (res && res.ok) caches.open(CACHE).then(c => c.put(req, res.clone()));
        return res;
      }).catch(() => hit);
      return hit || vers;
    })
  );
});
