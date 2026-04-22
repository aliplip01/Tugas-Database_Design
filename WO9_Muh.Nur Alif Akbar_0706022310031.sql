-- gunakan table exercise W09 (mahasiswa dan prodi)
-- silahkan langsung menuliskan sql pada bagian jawab 

-- 1. tampilkan nim dan nama mahasiswa yang namanya mengandung kata 'chris'
/* output:
nim				nama_lengkap
---				------------
0706022310012	Feylin Christelia
0706022310015	Raphael Christiano Wahono
0706022310041	Tiffany Christabel Anggriawan
*/
-- jawab setelah line ini:
select nim, nama_lengkap
from mahasiswa
where nama_lengkap like '%chris%';

-- 2. tampilkan data mahasiswa yang namanya mengandung kata "wan" dan dari prodi ISB. kemudian urutkan berdasarkan nama
/* output:
nim				nama_lengkap				prodi
---				------------				--------
0706022310023	Angela Melia Gunawan		ISB
0706022310014	Deborah Michelle Kwandinata	ISB
*/

-- jawab setelah line ini:
select nim, nama_lengkap, prodi_id prodi
from mahasiswa
where nama_lengkap like '%wan%' and prodi_id ='ISB';

-- 3. tampilkan nim dan nama mahasiswa (huruf besar semua) diurutkan nomor urut registrasi mahasiswa. nomor urut didapatkan dari 4 digit terakhir nim mahasiswa.
/* output:
nim				nama_lengkap
---				------------
0706022310001	EVELYN KOMALASARI HARTONO
0706022310002	FELICIA KATHRIN VALERIE HARSONO
...dst			...dst
0706022310015	RAPHAEL CHRISTIANO WAHONO
0706022210016	I GUSTI AYU DEVINA SATYA PRATIWI
0706022310016	VINCENT HALIM
0706022310017	VARREL TJANDRA
...dst			...dst
0706022310063	MARION ARKAN WIBISONO
0706022210065	MALVIN JAPNANTO
*/

-- jawab setelah line ini:
select nim, nama_lengkap
from mahasiswa
order by substring(nim, -4);

-- 4. tampilkan nomor group dan jumlah anggotanya
/* output:
group_id	jml_anggota
--------	-----------
1			5 orang
2			5 orang
3			4 orang
4			4 orang
5			4 orang
6			4 orang
7			4 orang
8			4 orang
9			4 orang
10			4 orang
11			4 orang
12			4 orang
13			4 orang
14			4 orang
15			5 orang
*/

-- jawab setelah line ini:
select group_id, concat(count(group_id), ' orang') as jml_anggota
from mahasiswa
group by group_id
order by 1;

-- 5. tampilkan nim, nama, dan angkatan seorang mahasiswa. Angkatan didapatkan dari nim pada karakter 7-8
/* output:
nim				nama_lengkap						angkatan
---				------------						--------
0706022210016	I Gusti Ayu Devina Satya Pratiwi	2022
0706022210065	Malvin Japnanto						2022
0706022310001	Evelyn Komalasari Hartono			2023
0706022310002	Felicia Kathrin Valerie Harsono		2023
0706022310003	Andrew Hendrawan					2023
...dst			...dst								...dst
*/

-- jawab setelah line ini:
select nim, nama_lengkap, CONCAT('20', SUBSTRING(nim, 7, 2)) as angkatan
FROM mahasiswa;


-- 6. tampilkan jumlah prodi yang terlibat dalam suatu group.
/* output:
group_id	jml_keterlibatan
--------	----------------
1			4 prodi
2			5 prodi
3			3 prodi
4			4 prodi
5			4 prodi
6			4 prodi
7			4 prodi
8			4 prodi
9			3 prodi
10			4 prodi
11			3 prodi
12			3 prodi
13			4 prodi
14			4 prodi
15			5 prodi
*/

-- jawab setelah line ini:
select group_id, CONCAT(COUNT(DISTINCT prodi_id), ' prodi') as jml_keterlibatan
from mahasiswa
group by group_id
order by 1;


-- 7. tampilkan jumlah mahasiswa dari suatu prodi yang ada pada suatu group_id.
/* output:
group_id	prodi_id	jml_mhs
--------	--------	-------
1			COM			2 orang
1			DME			1 orang
1			HTB			1 orang
1			ISB			1 orang
2			ACC			1 orang
2			FTP			1 orang
2			HTB			1 orang
2			MED			1 orang
2			VCD			1 orang
3			CBZ			1 orang
3			HTB			2 orang
3			IBM			1 orang
4			FPD			1 orang
4			IMT			1 orang
4			MED			1 orang
4			VCD			1 orang
5			ACC			1 orang
5			DME			1 orang
5			INA			1 orang
5			ISB			1 orang
6			CBZ			1 orang
6			IBM			1 orang
6			INA			1 orang
6			VCD			1 orang
7			DME			1 orang
7			IBM			1 orang
7			IMT			1 orang
7			ISB			1 orang
8			CBZ			1 orang
8			DME			1 orang
8			FTP			1 orang
8			HTB			1 orang
9			COM			1 orang
9			DME			1 orang
9			ISB			2 orang
10			ACC			1 orang
10			INA			1 orang
10			PSY			1 orang
10			VCD			1 orang
11			CBZ			1 orang
11			DME			1 orang
11			HTB			2 orang
12			CBZ			1 orang
12			FTP			2 orang
12			VCD			1 orang
13			COM			1 orang
13			HTB			1 orang
13			INA			1 orang
13			MDP			1 orang
14			ACC			1 orang
14			IMT			1 orang
14			INA			1 orang
14			MDP			1 orang
15			COM			1 orang
15			FPD			1 orang
15			INA			1 orang
15			MEM			1 orang
15			PSY			1 orang
*/

-- jawab setelah line ini:
select group_id, prodi_id, CONCAT(COUNT(*), ' orang') as jml_mahasiswa
from mahasiswa
group by group_id, prodi_id
order by group_id, prodi_id;



-- 8. tampilkan jumlah group pada suatu prodi. diurutkan dari yang terbanyak
/* output:
prodi_id	prodi_nama							jml_tim
--------	----------							-------
HTB			Hotel and Tourism Business			8 tim
DME			Doctoral Management					6 tim
INA			Interior Architecture				6 tim
ISB			Information System for Business		5 tim
CBZ			Culinary Business					5 tim
VCD			Visual Communication Design			5 tim
COM			Communication						5 tim
FTP			Food Technology						4 tim
ACC			Accounting							4 tim
IBM			International Business Management	3 tim
IMT			Informatics							3 tim
MED			Medical								2 tim
FPD			Fashion and Product Design			2 tim
MDP			Medical Profession					2 tim
PSY			Psychology							2 tim
MEM			Magister Management					1 tim
*/

-- jawab setelah line ini:
select m.prodi_id, p.prodi_nama, CONCAT(COUNT(DISTINCT m.group_id), ' tim') as jml_tim
from mahasiswa m
join prodi p on m.prodi_id = p.prodi_id
group by m.prodi_id, p.prodi_nama
order by COUNT(distinct m.group_id) desc;
