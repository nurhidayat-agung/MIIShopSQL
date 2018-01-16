-- sp insert barang
/
create or replace PROCEDURE sp_insertBarang(
    vIdBarang in number,
    vNama in varchar, 
    vDeskripsi in varchar,
    vStok in number
) 
is
BEGIN
    if vStok is null then
        insert into barang(IDBARANG,NAMABARANG,DESKRIPSIBARANG,ISDELETE,TOTALSTOK) 
            values(vIdBarang,vNama,vDeskripsi,'N',0);
    elsif vStok > 0 then
        insert into barang(IDBARANG,NAMABARANG,DESKRIPSIBARANG,ISDELETE,TOTALSTOK) 
            values(vIdBarang,vNama,vDeskripsi,'N',0);
    else    
        insert into barang(IDBARANG,NAMABARANG,DESKRIPSIBARANG,ISDELETE,TOTALSTOK) 
            values(vIdBarang,vNama,vDeskripsi,'N',0);
    end if;
END sp_insertBarang;
/
-- 
/
-- karyawan table procedure
CREATE OR REPLACE PROCEDURE sp_insertKaryawan(
    vNik in number,
    vNamaKaryawan in varchar, 
    vPassword in varchar,
    vJob in varchar
) 
is
BEGIN
    insert into karyawan values(vNik,vNamaKaryawan,vPassword,vJob);
END sp_insertKaryawan;
/
--
/
-- sp insert member
CREATE OR REPLACE PROCEDURE sp_insertMember(
    vIdMember in number,
    vNamaMember in varchar, 
    vPoint in number,
    vSaldo in number
) 
is
BEGIN
    insert into member values(vIdMember,vNamaMember,vPoint,vSaldo);
END sp_insertMember;

/
--
/
/
-- sp insert supplier
CREATE OR REPLACE PROCEDURE sp_insertSupplier( 
    vNamaSupplier in varchar,
    vDeskripsiSupplier in varchar
) 
is
BEGIN
declare lastID int default 0;
begin
    select count(*) into lastID from supplier;
    lastID := lastID + 1;
    insert into SUPPLIER values(lastID,vNamaSupplier,vDeskripsiSupplier);
end;
END sp_insertSupplier;

/
--
/
/
CREATE OR REPLACE PROCEDURE sp_barangMasuk( 
    vIdBarang in number, -- from application session
    vIdSupplier in number, -- from application session
    vNik in number, -- from application session
    vQty in number,
    vHargaBeli in number
) 
is
BEGIN
declare 
    lastID int default 0;
    vHargaTotal number;
    vHargaJual number;
    vIdBeli number;
begin
    select count(*) into lastID from pembelianbarang;
    lastID := lastID + 1;
    vHargaTotal := (vHargaBeli * vQty);
    vHargaJual := (vHargaBeli + (vHargaBeli * 0.15));
    insert into pembelianbarang(idBeli,IdBarang,idSupplier,nik,tanggalBeli,qty,stok,hargabeli,hargatotal,hargajual)
    values(lastID,vIdBarang,vIdSupplier,vNik,sysdate,vQty,vQty,vHargaBeli,vHargaTotal,vHargaJual);
end;
END sp_barangMasuk;

/
-- sp when sell item
-- get idJual for foreign key detail Jual
CREATE OR REPLACE PROCEDURE sp_getIdJual(
    vIdMember in number, -- from application session
    vNik in number, -- from application session
    vIdJual out number
)
is
BEGIN
declare 
    lastID int default 0;
begin
    select count(*) into lastID from penjualanBarang;
    lastID := lastID + 1;
    insert into penjualanBarang(idJual,idMember,nik) values(lastID,vIdMember,vNik);
end;
END sp_getIdJual;

/
-- above procedure method can only implement with ADO.net 
-- commandtext store procedure type
/
--
/
/
CREATE OR REPLACE PROCEDURE sp_pushDetilJual(
    vIdJual in number, -- from application session result output procedure
    vIdBarang in number, -- from application session
    vQty in number
)
is
BEGIN
declare 
    lastID int default 0;
    vHargaItemTotal number;
    vIdBeli number;
    vStok number;
    vPushStok number;
begin
    select count(*) into lastID from detailjual;
    lastID := lastID + 1;
    select idBeli,hargaJual,stok into vIdBeli,vHargaItemTotal,vStok from pembelianbarang 
        where idBarang = vIdBarang and stok > vQty and rownum = 1 order by idbeli asc;
    vHargaItemTotal := vQty * vHargaItemTotal;
    insert into detailJual(idDetailJual,idJual,idBarang,qty,HARGAITEMTOTAL,idBeli) 
        values(lastID,vIdJual,vIdBarang,vQty,vHargaItemTotal,vIdBeli);
end;
END sp_pushDetilJual;
/
--
/
CREATE OR REPLACE PROCEDURE sp_getTranSaksi
is
BEGIN
DECLARE
    CURSOR cur_transaksi IS 
    select m.NAMAMEMBER,b.NAMABARANG,pb.HARGABELI,pb.HARGAJUAL,dj.QTY,dj.HARGAITEMTOTAL,
        pb.TANGGALBELI,p.TGLJUAL,b.TOTALSTOK,p.NIK from member m inner join PENJUALANBARANG p 
        using(IDMEMBER) inner join DETAILJUAL dj using(IDJUAL) inner join BARANG b 
        using(IDBARANG)inner join PEMBELIANBARANG pb using (IDBELI) order by idJual;
BEGIN
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('NamaPembeli'||chr(9)||'Nama Barang'||chr(9)||
        'Harga Beli'||chr(9)||'Harga Jual'||chr(9)||'Qty'||chr(9)||'Total Bayar'
        ||chr(9)||'Tanggal Beli'||chr(9)||'Tanggal Jual'||chr(9)||'Stok Gudang'||
        chr(9)||'Kasir');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
    FOR curIdx IN cur_transaksi
    LOOP
        DBMS_OUTPUT.PUT_LINE(curIdx.NAMAMEMBER||chr(9)||chr(9)||curIdx.NAMABARANG||chr(9)||
        curIdx.HARGABELI||chr(9)||curIdx.HARGAJUAL||chr(9)||curIdx.QTY||chr(9)||
        curIdx.HARGAITEMTOTAL||chr(9)||curIdx.TANGGALBELI||chr(9)||curIdx.TGLJUAL||
        chr(9)||curIdx.TOTALSTOK||chr(9)||curIdx.nik);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
end;
END sp_getTranSaksi;
/
--
/
CREATE OR REPLACE PROCEDURE sp_getTranSaksiPerItem(v_PerItem in number)
is
BEGIN
DECLARE
    CURSOR cur_transaksi IS 
    select m.NAMAMEMBER,b.NAMABARANG,pb.HARGABELI,pb.HARGAJUAL,dj.QTY,dj.HARGAITEMTOTAL,
        pb.TANGGALBELI,p.TGLJUAL,b.TOTALSTOK,p.NIK from member m inner join PENJUALANBARANG p 
        using(IDMEMBER) inner join DETAILJUAL dj using(IDJUAL) inner join BARANG b 
        using(IDBARANG)inner join PEMBELIANBARANG pb using (IDBELI) 
        where dj.idDetailJual = v_PerItem order by idJual;
BEGIN
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('NamaPembeli'||chr(9)||'Nama Barang'||chr(9)||
        'Harga Beli'||chr(9)||'Harga Jual'||chr(9)||'Qty'||chr(9)||'Total Bayar'
        ||chr(9)||'Tanggal Beli'||chr(9)||'Tanggal Jual'||chr(9)||'Stok Gudang'||
        chr(9)||'Kasir');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
    FOR curIdx IN cur_transaksi
    LOOP
        DBMS_OUTPUT.PUT_LINE(curIdx.NAMAMEMBER||chr(9)||chr(9)||curIdx.NAMABARANG||chr(9)||
        curIdx.HARGABELI||chr(9)||curIdx.HARGAJUAL||chr(9)||curIdx.QTY||chr(9)||
        curIdx.HARGAITEMTOTAL||chr(9)||curIdx.TANGGALBELI||chr(9)||curIdx.TGLJUAL||
        chr(9)||curIdx.TOTALSTOK||chr(9)||curIdx.nik);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
end;
END sp_getTranSaksiPerItem;
