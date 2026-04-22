-- Advanced SQL

-- 1. Tampilkan nama fasilitas yang tidak pernah digunakan.
/*
output:
FASILITAS  
--------------------
HANGER
*/

select namafasilitas as FASILITAS
from fasilitas
where kodefasilitas not in (select kodefasilitas
							from usefas);

-- 2. Tampilkan kodecin, nomor kamar yang belum dibayar (tidak ada pada tabel transaksi)
/*
output:
KODE_CIN     NO_KAMAR
----------   -----------------
T170811001     112
T170811002     405
*/

select kodecin as KODE_CIN, nokamar as NO_KAMAR
from dcheckin
where kodecin not in (select kodecin
						from trans);


-- 3. Tampilkan kode fasilitas, namafasilitas, dan total penggunaan fasilitas dan biaya dari penggunaan fasilitas serta fasilitas yang tidak pernah digunakan. Gunakan UNION.
/*
output:
KODE 	NAMAFASILITAS 	TOTAL  	BIAYA
------ 	-------------- 	------ 	---------
F001 	EXTRA BED      	3 kali 	Rp. 90000
F002 	EXTRA HANDUK	4 kali 	Rp. 60000
F003 	SANDAL KAMAR	2 kali 	Rp. 90000
F004 	LAUNDRY         8 kali 	Rp. 24000
F005 	HANGER          0 kali 	Rp. 0
*/

select f.kodefasilitas as KODE, f.namafasilitas as NAMAFASILITAS, 
		concat(ifnull(sum(u.jumlah),0), ' kali') as TOTAL,
		concat('Rp. ', ifnull(sum(u.jumlah) * f.harga, 0)) as BIAYA
from usefas u, fasilitas f
where u.kodefasilitas = f.kodefasilitas
group by f.kodefasilitas
union
select kodefasilitas, namafasilitas, '0 kali' , 'Rp. 0'
from fasilitas
where kodefasilitas not in(select kodefasilitas
							from usefas)
order by 1 asc;

-- 4. Tampilkan nama fasilitas yang frekuensi penggunaan fasilitas tersebut hanya pernah digunakan 1x saja.
/*
output:
FASILITAS      
-------------- 
EXTRA HANDUK 	
SANDAL KAMAR  	
LAUNDRY        
*/

SELECT f.namafasilitas as FASILITAS
FROM fasilitas f
WHERE f.kodefasilitas IN (
    SELECT u.kodefasilitas
    FROM usefas u
    GROUP BY u.kodefasilitas
    HAVING COUNT(*) = 1
);

-- 5. Tampilkan kode dan nama customer serta waktu pelunasan transaksi (lihat dari tabel transaksi). Jika belum lunas, maka diberi ''
/*  
output: 
KODE 	NAMA_CUST        	WAKTU
------ 	---------------- 	-------------------------
T00001 	YOHANES KAREL    	TGL 12/06/2017 JAM 10:00
T00002 	YUSAK WINATA     	TGL 14/07/2017 JAM 13:00
T00003 	LISTYA ARINI
T00004 	YOHANES KAREL
*/

select c.kodecust as KODE, 
       c.nama as NAMA_CUST, 
       coalesce(concat('tgl ', date_format(t.tgltrans, '%d/%m/%Y'), ' jam ', t.jamtrans), '') as WAKTU
from customer c
join hcheckin h on c.kodecust = h.kodecust
left join trans t on h.kodecin = t.kodecin
group by c.kodecust, c.nama, waktu
order by 3 desc;

-- 6. Tampilkan nama fasilitas, jumlah penggunaan dari fasilitas yang paling sering digunakan.
/*
output:
FASILITAS       JUM_PENGGUNAAN
--------------- --------------
LAUNDRY         8 kali
*/

select c.namafasilitas as FASILITAS, concat(sq.freq, ' kali') as JUM_PENGGUNAAAN
from fasilitas c, (
				select u. kodefasilitas, u.jumlah as freq
                from usefas u
                ) sq
where c.kodefasilitas = sq.kodefasilitas
order by 2 desc
limit 1;

-- 7. Tampilkan nama fasilitas beri keterangan yang paling banyak digunakan, yang paling sedikit.
/*
output:
  NAMA                 	MOST 	LEAST
  -------------------- 	---- 	-----
  EXTRA BED
  EXTRA HANDUK
  SANDAL KAMAR             		*
  LAUNDRY              	*
*/

SELECT f.namafasilitas as NAMA, IF(sq.freq = max_freq, '*', ' ') AS MOST,
		IF(sq.freq = min_freq, '*', ' ') AS LEAST
FROM 
    fasilitas f
LEFT JOIN 
    (SELECT kodefasilitas, SUM(jumlah) AS freq 
     FROM usefas 
     GROUP BY kodefasilitas) sq ON f.kodefasilitas = sq.kodefasilitas,
     
    (SELECT MAX(freq) as max_freq, MIN(freq) as min_freq 
     FROM (SELECT SUM(jumlah) AS freq 
           FROM usefas 
           GROUP BY kodefasilitas) subq) limits;

-- 8. Tampilkan nomor kamar, penggunaan fasilitas extra bed untuk masing-masing transaksi cek in  (lihat dari tabel hcheckin)
/*
output:
NO_KAMAR       EXTRA_BED
--------       -----------------
101            v
112            -
201            v
220            -
405            -
*/

select k.nokamar as NO_KAMAR, 
       case when uf.kodefasilitas is not null then 'v' else '-' end as EXTRA_BED
from kamar k
join dcheckin d on k.nokamar = d.nokamar
left join usefas uf on d.kodeusefas = uf.kodeusefas and uf.kodefasilitas = 'F001'
order by k.nokamar;

-- 9. Tampilkan nama cust, biaya sewa kamar, biaya fasilitas, total tagihan yang harus dibayar oleh LISTYA ARINI.
/*
output:
NAMA             BIAYA_SEWA    BIAYA_FAS    TOTAL
-------------    ----------    ----------   ---------------
LISTYA ARINI     Rp 880000     Rp 114000    Rp 994000
*/

select c.nama as NAMA,
       sum(datediff(d.tglcout, h.tglcin) * jk.harga) as BIAYA_SEWA,
       sum(uf.jumlah * f.harga) as BIAYA_FAS,
       sum(datediff(d.tglcout, h.tglcin) * jk.harga) + sum(uf.jumlah * f.harga) as TOTAL
from customer c
left join hcheckin h on c.kodecust = h.kodecust
left join dcheckin d on h.kodecin = d.kodecin
left join kamar k on d.nokamar = k.nokamar
left join jenis_kamar jk on k.kodejenis = jk.kodejenis
left join usefas uf on d.kodeusefas = uf.kodeusefas
left join fasilitas f on uf.kodefasilitas = f.kodefasilitas
where c.nama = 'LISTYA ARINI'
group by c.nama;

-- 10. Tampilkan detail transaksi pelanggan yang menginap beserta kamar yang ditempati, jenis kamar, fasilitas yang dipakai, dan harga fasilitasnya.
/*
output:
kodetrans	nama			nokamar	namajenis	namafasilitas	jumlah	harga
N00001		YOHANES KAREL	101		STANDARD	EXTRA BED		1	30000
N00001		YOHANES KAREL	101		STANDARD	EXTRA HANDUK	4	15000
N00002		YUSAK WINATA	201		DELUXE		EXTRA BED		2	30000
*/

select t.kodetrans, c.nama, d.nokamar, jk.namajenis, f.namafasilitas,
		u.jumlah, f.harga
from trans t
join hcheckin h on t.kodecin = h.kodecin 
join dcheckin d on d.kodecin = h.kodecin
join usefas u on u.kodeusefas = d.kodeusefas
join customer c on c.kodecust = h.kodecust
join kamar k on k.nokamar = d.nokamar
join jenis_kamar jk on jk.kodejenis = k.kodejenis
join fasilitas f on f.kodefasilitas = u.kodefasilitas;

-- 11. Tampilkan jumlah customer yang berdasarkan kota yang sama dimana jumlahnya lebih dari 1
/*
output:
kota	jumlah_customer
MALANG	2
*/

select kota, count(*) as jumlah_customer
from customer
group by kota
having count(*) > 1;

-- 12. Tampilkan data customer yang tidak pernah menggunakan fasilitas 'Extra Handuk'
/*
output:
kodecust	nama				alamat			kota		telepon
C00002		YUSAK WINATA		MASPATI III/25	SURABAYA	8658898
C00003		LISTYA ARINI		MAWAR 14		JAKARTA		5934485
C00004		YOLANDA HIDAYATI	TALANG 1		MALANG		7894455
*/

select c.kodecust, c.nama, c.alamat, c.kota, c.telepon
from customer c
where c.kodecust not in (
    select c.kodecust
    from customer c
    left join hcheckin h on h.kodecust = c.kodecust
    left join dcheckin d on d.kodecin = h.kodecin
    left join usefas u on u.kodeusefas = d.kodeusefas
    left join fasilitas f on f.kodefasilitas = u.kodefasilitas
    where f.namafasilitas = 'EXTRA HANDUK'
)
order by c.kodecust;

