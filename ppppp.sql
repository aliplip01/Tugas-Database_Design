create database if not exists W07_DOSEN;

use W07_DOSEN;

create table if not exists GOL (
	kode_gol varchar(5) primary key,
    g_pokok int unsigned not null,
    g_tambah int unsigned not null,
    tunj_istri int unsigned
);

create table if not exists DOSEN (
	nip varchar(5) primary key,
    nama_dosen varchar(20) not null,
    isMenikah char(1) check (isMenikah = 'Y' or isMenikah = 'N'),
    kode_gol varchar(4) not null,
    tgl_lahir date
);

create table if not exists KELUARGA (
	nip varchar(5),
    nama_kel varchar(20) not null,
    hubungan char(1) check (hubungan = 'I' or hubungan = 'A'),
    primary key (nip, nama_kel)
);

alter table DOSEN
	modify column nama_dosen varchar(50);
    
alter table KELUARGA
	change column nama_kel nama_keluarga varchar(20) not null;
    
alter table KELUARGA
	add constraint fk_nip foreign key (nip) references DOSEN(nip);
    
rename table gol to GOLONGAN;
    
alter table GOLONGAN
	add tunj_anak int UNSIGNED default 0;
    
create table if not exists DOSEN_EDIT (
	nip varchar(5) primary key,
    nama_dosen varchar(20) not null,
    g_pokok int unsigned,
    g_tambahan int unsigned,
    tunj_istri int unsigned,
    tunj_anak int unsigned
);

insert into GOLONGAN (kode_gol, g_pokok, g_tambah, tunj_istri, tunj_anak)
	values ('GOL1', '1200000', '25000', '300000', '1500000'),	
		   ('GOL2', '1500000', '35000', '200.000', '20000000'),
           ('GOL3', '800000', '45000', '150000', '1000000'),
           ('GOL4', '600000', '25000', '200000', '1200000');
    
 insert into DOSEN (nip, nama_dosen, isMenikah, kode_gol, tgl_lahir)
	values ('20201', 'BERTRAND ARESTO', 'Y', 'GOL1', '1977-09-17'),
		   ('20202', 'SUGIARTO SAPUTRA', 'N', 'GOL2', '1985-01-31'),
           ('20203', 'ROLAND MEZZY', 'Y', 'GOL2', '1974-02-28'),
           ('20304', 'CAROLUS WIDJAJA', 'Y', 'GOL3', '1982-05-12'),
           ('20305', 'AGUS PUTRA', 'N', 'GOL4', '1985-04-23');
        
 insert into DOSEN(nip, nama_dosen, kode_gol, tgl_lahir)
	values ('20204', 'ANDY', 'GOL2', '1992-12-16');       
        
 insert into KELUARGA(nip, nama_keluarga, hubungan)
	values ('20201', 'MARIA ANTONIA', 'I'),
		   ('20201', 'MANDY LANTAROZ', 'A'),
           ('20201', 'LUCKY ROSALIE', 'A'),
           ('20203', 'MERRY ONGKO', 'I'),
           ('20203', 'SILVIANA', 'A'),
           ('20203', 'MARGARETHA', 'A'),
           ('20204', 'ROSALES ANTAGUES', 'I');
    
update DOSEN
set kode_gol = 'GOL4'
where nip = '20203';

update GOLONGAN
set g_pokok = case
	when g_pokok < 1000000 then g_pokok + 500000
    else g_pokok
end;

insert into KELUARGA(nip, nama_keluarga, hubungan)
	values ('20304', 'MICHAEL', 'A');

update KELUARGA
set nama_keluarga = LOWER(nama_keluarga)
where nama_keluarga like 'M%';

ALTER TABLE KELUARGA
DROP FOREIGN KEY fk_nip;

ALTER TABLE KELUARGA
ADD CONSTRAINT fk_nip FOREIGN KEY (nip) REFERENCES DOSEN(nip) ON DELETE CASCADE;

delete from KELUARGA
where nip = '20304' and hubungan = 'A';