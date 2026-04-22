/* isi dengna NIM dan Nama Anda:
NIM  : 0706022310031
Nama : Muh. Nur Alif Akbar
Kelas: A
*/

-- menggunakan database indramar_class_demo

use indramar_class_demo;

-- 1. Tampilkan jenis_kamar yang memiliki harga diatas 200000
-- jawab:
select kodejenis as kode, namajenis, harga
from jenis_kamar
where harga > 200000
order by kodejenis desc;

/* output:
kode	namajenis				harga
V01		VIP						250000
P01		PRESIDENT SUITE			400000
*/

-- 2. Tampilkan jenis_kamar beserta dengan jumlah kamarnya
-- jawab:
select jk.namajenis as jenis_kamar, concat(count(k.kodejenis), ' room') as jml_kamar
from jenis_kamar jk
left join kamar k on jk.kodejenis = k.kodejenis
group by jk.namajenis;

/* output:
jenis_kamar			jml_kamar
DELUXE				1 room
PRESIDENT SUITE		1 room
STANDARD			3 room
VIP					1 room
*/

-- 3. Tampilkan customer yang namanya memiliki huruf 'AN'
-- jawab:
select kodecust, nama, alamat, kota, telepon
from customer
where nama like'%AN%';


/* output:
kodecust	nama				alamat					kota		telepon
YH0001		YOLANDA HIDAYATI	TALANG 1				MALANG		7894455
YK0001		YOHANES KAREL		RAMPAL KULON 12			MALANG		6503478
*/

-- 4. Tampilkan nama depan dan belakang customer
-- jawab:
select substring_index(nama, ' ', 1) as first_name, substring_index(nama, ' ', -1) as last_name
from customer;

/* output:
first_name	last_name
LISTYA			ARINI
YOLANDA			HIDAYATI
YOHANES			KAREL
YUSAK			WINATA
*/

-- 5. Tampilkan nama customer namun dengan format Capitalize Each Word
-- jawab:
select CONCAT(upper(substring(substring_index(nama, ' ', 1), 1, 1)), lower(substring(substring_index(nama, ' ', 1), 2)), ' ',
			  upper(substring(substring_index(nama, ' ', -1), 1, 1)), lower(substring(substring_index(nama, ' ', -1), 2))) as nama_customer
from customer
order by 1;

/* output:
nama_customer
Listya  Arini
Yohanes  Karel
Yolanda  Hidayati
Yusak  Winata
*/

-- 6. Tampilkan nokamar, jenis kamar, dan status kamarnya
-- jawab:
select k.nokamar, jk.namajenis, if(k.status_kamar = 0, 'Kosong', 'Terisi') as status_kamar
from kamar k
left join jenis_kamar jk on jk.kodejenis = k.kodejenis
order by k.nokamar;
/* output:
nokamar	namajenis				status_kamar
101		STANDARD				Kosong
112		STANDARD				Terisi
201		DELUXE					Kosong
220		VIP						Kosong
405		PRESIDENT SUITE			Terisi
*/

-- 7. Tampilkan kode fasilitas, nama fasilitas, serta jumlah penggunaannya dari semua fasilitas yang ada. Catatan: record sama perlu dijumlahkan.
-- jawab:
select f.kodefasilitas as kode, f.namafasilitas as nama_fasilitas, concat(if(sum(u.jumlah) is null, '0',sum(u.jumlah)), ' pcs') as jumlah
from fasilitas f
left join usefas u on u.kodefasilitas = f.kodefasilitas
group by f.kodefasilitas;


/* output:
kode	nama_fasilitas	jumlah
F001	EXTRA BED		3 pcs
F002	EXTRA HANDUK	4 pcs
F003	SANDAL KAMAR	2 pcs
F004	LAUNDRY			8 pcs
F005	HANGER			0 pcs
*/

-- 8. Tampilkan kode customer, nama customer, dan jumlah pernah menginapnya di hotel.
-- jawab:
select c.kodecust, c.nama, concat(count(h.kodecust), ' kali') as berapa_kali
from customer c
left join hcheckin h on h.kodecust = c.kodecust
group by c.kodecust
order by 3 desc;


/* output:
kodecust	nama					berapa_kali
YK0001		YOHANES KAREL			2 kali
LA0001		LISTYA ARINI			1 kali
YW0001		YUSAK WINATA			1 kali
YH0001		YOLANDA HIDAYATI		0 kali
*/

-- 9. Tampilkan laporan keuangan untuk penggunaan fasilitas
-- jawab:
select f.kodefasilitas as kode, f.namafasilitas as nama_fasilitas, concat(if(sum(u.jumlah) is null, '0',sum(u.jumlah)), ' pcs') as jumlah,
	   concat('Rp. ', format(f.harga, 0)) as hrg_per_pcs, concat('Rp. ', if(sum(u.jumlah) is null, 0, format(sum(u.jumlah) * f.harga, 0))) as subtotal
from fasilitas f
left join usefas u on u.kodefasilitas = f.kodefasilitas
group by f.kodefasilitas;



/* output:
kode	nama_fasilitas	jumlah	hrg_per_pcs	subtotal
F001	EXTRA BED		3 pcs		Rp. 30,000	Rp. 90,000
F002	EXTRA HANDUK	4 pcs		Rp. 15,000	Rp. 60,000
F003	SANDAL KAMAR	2 pcs		Rp. 45,000	Rp. 90,000
F004	LAUNDRY			8 pcs		Rp. 3,000	Rp. 24,000
F005	HANGER			0 pcs		Rp. 12,500	Rp. 0
*/

-- 10. tampilkan customer yang hanya menginap 1x.
-- jawab:
select c.kodecust, c.nama -- count(h.kodecust) as berapa_kali
from customer c
left join hcheckin h on h.kodecust = c.kodecust
group by c.kodecust
having count(h.kodecust) = '1';

/* output:
kodecust	nama				
LA0001		LISTYA ARINI
YW0001		YUSAK WINATA
*/