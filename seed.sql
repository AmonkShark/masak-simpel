-- ===== Masak Simpel: resep awal Komunitas =====
alter table public.recipes disable trigger recipes_limit;
insert into public.recipes (user_id, author, name, category, minutes, ingredients, steps, tip)
select u.id, 'Dapur Masak Simpel', x.name, x.category, x.minutes, x.ingredients, x.steps, x.tip
from auth.users u,
(values
 ('Seblak Kerupuk Simpel','Lainnya',20,
   array['1 genggam kerupuk bawang, rendam air panas','1 butir telur','2 siung bawang putih','3 buah cabai rawit','1 ruas kencur (opsional)','2 batang sawi','garam, gula, kaldu bubuk','300 ml air'],
   array['Haluskan bawang putih, cabai, dan kencur.','Tumis bumbu halus sampai harum.','Masukkan telur, orak-arik.','Tuang air, masukkan kerupuk dan sawi.','Bumbui garam, gula, kaldu, masak sampai kerupuk kenyal.'],
   'Tambah sosis, bakso, atau ceker supaya lebih komplet.'),
 ('Rujak Buah Bumbu Kacang','Lainnya',15,
   array['1 buah mangga muda','1 buah bengkuang','1 buah timun','1 potong nanas','3 sdm kacang tanah goreng','2 buah cabai rawit','50 g gula merah','1 sdt asam jawa','sejumput garam'],
   array['Kupas dan potong semua buah.','Ulek cabai, garam, dan kacang tanah.','Tambah gula merah dan asam jawa, ulek sampai halus.','Beri 2 sdm air supaya bumbu agak cair.','Sajikan buah dengan bumbu rujak.'],
   'Simpan buah di kulkas dulu supaya rujak lebih segar.'),
 ('Pisang Keju Cokelat','Kue & Camilan',10,
   array['3 buah pisang raja atau kepok','1 sdm mentega','2 sdm keju parut','1 sdm meses cokelat','1 sdm susu kental manis'],
   array['Kupas pisang, belah dua memanjang.','Panggang di teflon dengan mentega 2 menit tiap sisi.','Angkat ke piring.','Siram susu kental manis.','Taburi keju dan meses.'],
   'Pakai pisang yang sudah matang supaya manis alami.'),
 ('Mie Lidi Pedas','Kue & Camilan',15,
   array['100 g mie lidi','2 sdm cabai bubuk','1 sdt bawang putih bubuk','1 sdt gula pasir','½ sdt garam','daun jeruk iris tipis','minyak untuk menggoreng'],
   array['Goreng mie lidi di minyak panas sebentar sampai mengembang.','Tiriskan sampai minyaknya turun.','Goreng daun jeruk sebentar sampai kering.','Campur semua bumbu bubuk.','Kocok mie lidi, daun jeruk, dan bumbu dalam wadah tertutup.'],
   'Simpan dalam toples rapat supaya tetap renyah.'),
 ('Dalgona Coffee','Minuman',10,
   array['2 sdm kopi instan tanpa ampas','2 sdm gula pasir','2 sdm air panas','200 ml susu cair dingin','es batu'],
   array['Campur kopi, gula, dan air panas di mangkuk.','Kocok kuat dengan whisk atau mixer sampai mengembang dan kental.','Isi gelas dengan es dan susu.','Sendokkan krim kopi di atasnya.','Aduk sebelum diminum.'],
   'Pakai mixer supaya cuma butuh 2 menit.'),
 ('Es Milo Kepal','Minuman',5,
   array['4 sdm Milo bubuk','2 sdm susu kental manis','100 ml air panas','100 ml susu cair dingin','es serut atau es batu'],
   array['Larutkan 2 sdm Milo dengan air panas.','Tambah susu kental manis dan susu cair.','Isi gelas dengan es serut.','Tuang campuran Milo.','Taburi sisa Milo bubuk di atasnya.'],
   'Semakin banyak taburan Milo, semakin mirip yang dijual di pinggir jalan.'),
 ('Sambal Mangga Muda','Sambal',10,
   array['½ buah mangga muda, serut','10 buah cabai rawit','2 siung bawang merah','1 sdt terasi bakar','½ sdt garam','1 sdt gula'],
   array['Ulek cabai, bawang merah, terasi, garam, dan gula.','Masukkan mangga muda serut.','Ulek kasar sebentar.','Koreksi rasa.','Sajikan dengan ikan goreng atau ayam.'],
   'Tidak perlu dimasak, segarnya dari mangga muda.'),
 ('Ayam Suwir Kemangi','Lauk',30,
   array['250 g dada ayam, rebus lalu suwir','1 ikat kemangi','5 siung bawang merah','3 siung bawang putih','5 buah cabai merah','2 lembar daun jeruk','garam dan gula','2 sdm minyak'],
   array['Haluskan bawang merah, bawang putih, dan cabai.','Tumis bumbu dengan daun jeruk sampai harum.','Masukkan ayam suwir dan sedikit air.','Bumbui garam dan gula, masak sampai meresap.','Masukkan kemangi, aduk sebentar lalu angkat.'],
   'Air rebusan ayam bisa dipakai untuk sup.'),
 ('Sop Ceker Pedas','Sop',45,
   array['500 g ceker ayam','1 buah wortel','2 buah kentang','1 batang daun bawang','4 siung bawang putih','5 buah cabai rawit','garam, merica, gula','1 liter air'],
   array['Rebus ceker 5 menit, buang airnya.','Rebus lagi dengan air baru sampai empuk, sekitar 30 menit.','Tumis bawang putih dan cabai halus, masukkan ke rebusan.','Masukkan wortel dan kentang, masak sampai empuk.','Bumbui, beri daun bawang, lalu angkat.'],
   'Pakai panci presto supaya ceker empuk dalam 15 menit.'),
 ('Tahu Gejrot','Lainnya',10,
   array['6 buah tahu pong, potong','3 siung bawang merah','2 siung bawang putih','5 buah cabai rawit','3 sdm kecap manis','1 sdm gula merah','100 ml air matang','sejumput garam'],
   array['Ulek kasar bawang merah, bawang putih, dan cabai.','Larutkan kecap, gula merah, dan garam dalam air.','Campur bumbu ulek dengan kuah.','Tata tahu di piring.','Siram dengan kuah, sajikan.'],
   'Lebih enak pakai cobek tanah liat kecil seperti aslinya.')
) as x(name, category, minutes, ingredients, steps, tip)
where u.email = 'amonkpubg@gmail.com'
  and not exists (select 1 from public.recipes r where r.name = x.name);
alter table public.recipes enable trigger recipes_limit;
