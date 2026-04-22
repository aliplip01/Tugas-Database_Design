/* isi dengna NIM dan Nama Anda:
NIM  : 
Nama : 
Kelas: A/B
*/

-- save as -> ganti [NIM] dengan NIM Anda.

-- menggunakan database indramar_class_demo
use indramar_class_demo;

/* 1. Tampilkan nomor kamar beserta jenis nya, dari kamar yang tidak pernah digunakan.

NO_KAMAR	JENIS_KAMAR
--------- -----------
102				STANDARD

Penilaian:
Header Benar (5/0)
Data Benar (5/0)
Format Data (5/0)
*/

-- jawab disini :
select k.nokamar as NO_KAMAR, j.namajenis as JENIS_KAMAR
from kamar k
left join jenis_kamar j on k.kodejenis = j.kodejenis
left join dcheckin dc on k.nokamar = dc.nokamar
where dc.kodecin is null;
      

/* 2. Tampilkan nama fasilitas dan jumlah penggunaannya, yang dibawah 4.

FASILITAS			USE_QUANTITY
------------- ------------
EXTRA BED			3 pcs
SANDAL KAMAR		2 pcs
HANGER				0 pcs

Penilaian:
Header Benar (5/0)
Data Benar (5/0)
Format Data (5/0) -> ada tulisan pcs
*/

-- jawab disini :
select f.namafasilitas as FASILITAS, 
       concat(ifnull(sum(u.jumlah), 0), ' pcs') as USE_QUANTITY
from fasilitas f
left join usefas u on f.kodefasilitas = u.kodefasilitas
group by f.namafasilitas
having use_quantity < 4;



/* 3. Tampilkan nama fasilitas dan jumlah penggunaan dari fasilitas yang paling sedikit digunakan (bukan berarti tidak pernah digunakan).

FASILITAS			USE_QUANTITY
------------- -------------
sandal kamar	2 pcs

Penilaian:
Header Benar (2/0)
Data Benar (8/0)
Format Data (5/0) -> ada tulisan pcs dan huruf kecil
*/

-- jawab disini :
select lower(f.namafasilitas) as FASILITAS, 
       concat(ifnull(sum(u.jumlah), 0), ' pcs') as USE_QUANTITY
from fasilitas f
left join usefas u on f.kodefasilitas = u.kodefasilitas
group by f.namafasilitas
having use_quantity = (
    select min(use_count)
    from (
        select ifnull(sum(jumlah), 0) as use_count
        from usefas
        group by kodefasilitas
    ) as min_usage
);




/* 4. Tampilkan nama customer, frekuensi menginap, dan beri keterangan yang paling banyak/sedikit menginap.

NAMA_CUST					FREQUENCY	MOST	LEAST
-----------------			--------- 	----- 	-----
LISTYA ARINI				1 kali	 	 
YOHANES KAREL				2 kali		*	 
YOLANDA HIDAYATI			0 kali	 			*
YUSAK WINATA				1 kali	 	 

Penilaian:
Header Benar (3/0)
Data Benar (10/0)
Format Data (2/0) -> ada tulisan kali
*/

-- jawab disini :
select 	c.nama as NAMA_CUST, concat(count(h.kodecin), ' kali') as FREQUENCY,
		IF(COUNT(h.kodecin) = (SELECT COUNT(kodecin) FROM hcheckin GROUP BY kodecust ORDER BY COUNT(kodecin) DESC LIMIT 1), '*', '') AS MOST,
		IF(COUNT(h.kodecin) = 0, '*', '') AS LEAST
from customer c
left join hcheckin h on h.kodecust = c.kodecust
group by c.nama
order by 1;

/* 5. Tampilkan kode trans, tgl trans, jamtrans, biaya kamar, biaya fasilitas, dan total yang harus dibayar dari setiap kodetrans

KODE_TRANS	TGL_TRANS				JAM_TRANS	BIAYA_KAMAR		BIAYA_FASILITAS	TOTAL_BIAYA
----------  --------------------- --------- ----------- --------------- -----------
N170612001	Monday, 12 June 2017	10:00		440,000			90,000			530,000
N170714001	Friday, 14 July 2017	13:00		850,000			60,000			910,000

Penilaian:
Header Benar (2/0)
Data Benar (8/0)
Format Data (5/0) -> tgl, jam, biaya2
*/

-- jawab disini :
select 
    t.kodetrans as KODE_TRANS, 
    concat(dayname(t.tgltrans), ', ', day(t.tgltrans), ' ', monthname(t.tgltrans), ' ', year(t.tgltrans)) as TGL_TRANS, 
    concat(substring(t.jamtrans, 1, 2), ':', substring(t.jamtrans, 3, 2)) as JAM_TRANS,
    format(sum(jk.harga * datediff(dc.tglcout, hc.tglcin)), 0) as BIAYA_KAMAR,
    format(sum(ifnull(u.jumlah * f.harga, 0)), 0) as BIAYA_FASILITAS,
    format(sum(jk.harga * datediff(dc.tglcout, hc.tglcin)) + sum(ifnull(u.jumlah * f.harga, 0)), 0) as TOTAL_BIAYA
from trans t
left join dcheckin dc on t.kodecin = dc.kodecin
left join kamar k on k.nokamar = dc.nokamar
left join jenis_kamar jk on jk.kodejenis = k.kodejenis
left join hcheckin hc on hc.kodecin = t.kodecin
left join usefas u on dc.kodeusefas = u.kodeusefas
left join fasilitas f on u.kodefasilitas = f.kodefasilitas
group by t.kodetrans, t.tgltrans, t.jamtrans;



/* 6. Tampilkan pendapatan yang didapat dari hotel.

Keterangan
---------------------------------------------------
Pendapatan yang didapat hotel sebesar Rp. 1,440,000

Penilaian:
Header Benar (2/0)
Data Benar (10/0)
Format Data (3/0) -> tulisan, duitnya
*/

-- jawab disini :

select concat('Pendapatan yang didapat hotel sebesar Rp. ', format(sum(total_biaya * 2), 0)) as Keterangan
from (select t.kodetrans, sum(ifnull(jk.harga, 0) + ifnull(fas.harga, 0)) as total_biaya
	  from trans t
	  left join hcheckin hc on t.kodecin = hc.kodecin
	  left join dcheckin dc on hc.kodecin = dc.kodecin
	  left join kamar k on dc.nokamar = k.nokamar
      left join jenis_kamar jk on k.kodejenis = jk.kodejenis
	  left join usefas uf on dc.kodeusefas = uf.kodeusefas
	  left join fasilitas fas on uf.kodefasilitas = fas.kodefasilitas
	  group by t.kodetrans
	 ) as pendapatan;
