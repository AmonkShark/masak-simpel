const V="masak-simpel-v7";
const SHELL=["./","index.html","manifest.json","icon-192.png","icon-512.png"];
self.addEventListener("install",e=>{e.waitUntil(caches.open(V).then(c=>c.addAll(SHELL)).then(()=>self.skipWaiting()))});
self.addEventListener("activate",e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==V).map(x=>caches.delete(x)))).then(()=>self.clients.claim()))});
self.addEventListener("fetch",e=>{
  const u=new URL(e.request.url);
  if(e.request.method!=="GET")return;
  if(u.hostname.includes("youtube.com")||u.hostname.includes("googlevideo"))return;
  if(u.origin===location.origin){
    // halaman: coba internet dulu supaya selalu versi terbaru, kalau offline pakai simpanan
    e.respondWith(fetch(e.request).then(r=>{const c=r.clone();caches.open(V).then(x=>x.put(e.request,c));return r}).catch(()=>caches.match(e.request).then(r=>r||caches.match("index.html"))));
    return;
  }
  if(u.hostname==="upload.wikimedia.org"||u.hostname==="i.ytimg.com"||u.hostname.includes("fonts.g")){
    // foto & huruf: pakai simpanan, perbarui di belakang
    e.respondWith(caches.open(V).then(c=>c.match(e.request).then(hit=>{const net=fetch(e.request).then(r=>{c.put(e.request,r.clone());return r}).catch(()=>hit);return hit||net})));
  }
});
