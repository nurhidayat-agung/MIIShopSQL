-- sample usage insert barang
    exec sp_insertBarang(1,'Aqua','Air Mineral',null);
    exec sp_insertBarang(2,'Indomie','Seleraku',null);
    exec sp_insertBarang(3,'Promaag','Makanan Ahir Bulan',null);
    exec sp_insertBarang(4,'Milanta','Alternatif makanan ahir bulan',null);
    exec sp_insertBarang(5,'Paramex','Jus Segar',null);
    select * from barang;
    --delete from barang;

-- sample usage insert 
exec sp_insertKaryawan(14117659,'Agung','Qwerty123','owner');
exec sp_insertKaryawan(14117652,'Jaki','Qwerty123','kasir');
select * from karyawan;

-- sample usage insert member
exec sp_insertMember(61112733,'Agung',0,0);
exec sp_insertMember(61112732,'nur',0,0);

select * from member;

-- usage supplier
exec sp_insertSupplier('Nur','mitra sejahtera');
select * from SUPPLIER;

-- usage pembelian barang
-- idBarang , idSupplier, nik, qty, hargaBeliSatuan
exec sp_barangMasuk(1,1,14117659,5,15000);
exec sp_barangMasuk(1,1,14117659,10,12000);
select * from PEMBELIANBARANG;


delete from detailJual;
delete from PENJUALANBARANG;
delete from PEMBELIANBARANG;
delete from BARANG;

-- demo at client using sp with output value
insert into penjualanbarang(idJual,idmember,nik) values(1,61112733,14117659);
insert into penjualanbarang(idJual,idmember,nik) values(2,61112733,14117659);
select * from PENJUALANBARANG;

-- barang keluar
-- idJual, idBarang, qty
exec sp_pushDetilJual(1,1,1);
exec sp_pushDetilJual(2,1,1);

select * from DETAILJUAL;
select * from PEMBELIANBARANG;
SELECT * from BARANG;

select m.NAMAMEMBER,b.NAMABARANG,pb.HARGABELI,pb.HARGAJUAL,dj.QTY,pb.TANGGALBELI,p.TGLJUAL,b.TOTALSTOK,
(pb.HARGAJUAL * dj.QTY) as "TotalBayarItem",p.NIK as "kasir" from member m 
inner join PENJUALANBARANG p using(IDMEMBER) inner join DETAILJUAL dj using(IDJUAL) 
inner join BARANG b using(IDBARANG)inner join PEMBELIANBARANG pb using (IDBELI) order by idJual;

exec sp_getTranSaksi();
exec sp_getTranSaksiPerItem(1);
SET SERVEROUTPUT ON;

-- delete 
delete from barang where IDBARANG = 5;
delete from BARANGTEMP;
select * from BARANGTEMP;
select * from BARANG;