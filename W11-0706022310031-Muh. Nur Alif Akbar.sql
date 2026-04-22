-- Homework W11

/* 1. buatlah query untuk menghasilkan data sbg berikut.
kodecin		nokamar	kodeusefas		kodefas	nama_fas			jumlah	harga_satuan	subtotal
T170608001	101		T170608001101	F001		EXTRA BED			1				30000					30000
T170608001	101		T170608001101	F002		EXTRA HANDUK	4				15000					60000
T170712001	201		T170712001201	F001		EXTRA BED			2				30000					60000
T170712001	220		Tidak Pakai		-				-							-				-							-
T170811001	112		T170811001112	F003		SANDAL KAMAR	2				45000					90000
T170811001	112		T170811001112	F004		LAUNDRY				8				3000					24000
T170811002	405		Tidak Pakai		-				-							-				-							-
*/

-- jawab disini
select dc.kodecin, dc.nokamar, if(u.kodeusefas is null, 'tidak dipakai', u.kodeusefas) as kodeusefas, if(u.kodefasilitas is null, '-', 
	   u.kodefasilitas) as kodefas, if(f.namafasilitas is null, '-', f.namafasilitas) as nama_fas, if(u.jumlah is null, '-', u.jumlah) as jumlah, 
       if(f.harga is null,'-',f.harga) as harga_satuan, IF(u.jumlah is null and f.harga is null, '-', f.harga * u.jumlah) AS subtotal
from dcheckin dc
left join  usefas u on u.kodeusefas = dc.kodeusefas
left join fasilitas f on f.kodefasilitas = u.kodefasilitas
order by dc.kodecin;



/* 2. buatlah query untuk menghasilkan data sbg berikut.
kodefasilitas	namafasilitas	jml_pakai	harga	subtotal
F001					EXTRA BED			3					30000	90000
F002					EXTRA HANDUK	4					15000	60000
F003					SANDAL KAMAR	2					45000	90000
F004					LAUNDRY				8					3000	2400
F005					HANGER				0					12500	0
*/

-- jawab disini
select f.kodefasilitas, f.namafasilitas, if(sum(u.jumlah) is null, '0', sum(u.jumlah)) as jml_pakai, 
	   f.harga, if(sum(u.jumlah) is null, '0', sum(u.jumlah) * f.harga) as subtotal
from fasilitas f
left join usefas u on f.kodefasilitas = u.kodefasilitas
group by f.kodefasilitas, f.namafasilitas, f.harga
order by f.kodefasilitas;



/* 3. buatlah query untuk menghasilkan data sbg berikut.
nokamar	keterangan			lama_inap				harga_kamar	pendapatan_kamar
101			Pernah Dipakai	4	hari					110000			440000
102			-								-								110000			0
112			Pernah Dipakai	Belum Check Out	110000			0
201			Pernah Dipakai	2	hari					175000			350000
220			Pernah Dipakai	2	hari					250000			500000
405			Pernah Dipakai	Belum Check Out	400000			0
*/

-- jawab disini
select k.nokamar, if(dc.nokamar is null, '-', 'Pernah Dipakai') as keterangan, 
	   if(dc.nokamar is null, '-', if(dc.tglcout is null,'Belum Checkout', datediff(dc.tglcout, hc.tglcin))) as lama_inap,
       jk.harga, if(dc.tglcout is null, '0', jk.harga * datediff(dc.tglcout, hc.tglcin)) as pendapatan_kamar
from kamar k
left join dcheckin dc on dc.nokamar = k.nokamar
left join hcheckin hc on hc.kodecin = dc.kodecin
left join jenis_kamar jk on jk.kodejenis = k.kodejenis
order by k.nokamar;

/* 4. buatlah query untuk menghasilkan data sbg berikut.
kodecin			nama					biaya_fas	biaya_kamar	TOTAL
T170608001	YOHANES KAREL	90000			880000			970000
T170712001	YUSAK WINATA	120000		1700000			1820000
*/

-- jawab disini
select t.kodecin, c.nama, sum(f.harga * u.jumlah) as biaya_fas, sum(datediff(dc.tglcout, hc.tglcin) * jk.harga) as biaya_kamar,
		 sum(f.harga * u.jumlah) + sum(datediff(dc.tglcout, hc.tglcin) * jk.harga) as total
from trans t
left join hcheckin hc on hc.kodecin = t.kodecin
left join customer c on c.kodecust = hc.kodecust
left join dcheckin dc on dc.kodecin = hc.kodecin
left join usefas u on u.kodeusefas = dc.kodeusefas
left join fasilitas f on f.kodefasilitas = u.kodefasilitas
left join kamar k on dc.nokamar = k.nokamar
left join jenis_kamar jk on k.kodejenis = jk.kodejenis
group by t.kodecin;
