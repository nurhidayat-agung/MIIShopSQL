--
/
create or replace TRIGGER trigBarangMasuk
after INSERT ON pembelianBarang
FOR EACH ROW
DECLARE
    vStokGudang number;
    vTotNilaiBarang number;
BEGIN
    update barang set createDate = sysdate where idbarang = :new.IdBarang;
    select TOTALSTOK into vStokGudang from barang where IDBARANG = :new.idBarang;
    vStokGudang := (vStokGudang + :new.qty);
    update BARANG set TOTALSTOK = vStokGudang where IDBARANG = :new.idBarang;
    select totalNilaiBarang into vTotNilaiBarang from barang 
        where idBarang = :new.idBarang; 
    vTotNilaiBarang := :new.hargatotal + vTotNilaiBarang;
    update barang set totalNilaiBarang = vTotNilaiBarang where idBarang = :new.idBarang;
END;

/
create or replace TRIGGER trigBarangKeluar
after INSERT ON detailJual
FOR EACH ROW
DECLARE
    sisaStok number;
    stokBaru number;
    hargaDasar number;
    vIdBeli number;
    vTotNilaiBarang number;
BEGIN
    select totalStok into sisaStok from barang where idBarang = :new.idBarang;
    stokBaru := sisaStok - :new.Qty;
    update barang set updateDate = sysdate, totalstok = stokbaru where idbarang = :new.idBarang;
    select stok into sisaStok from pembelianbarang where idBeli = :new.idBeli;
    stokBaru := sisaStok - :new.Qty;
    update pembelianBarang set stok = stokBaru where idBeli = :new.idBeli;
    select totalNilaiBarang into vTotNilaiBarang from barang 
        where idBarang = :new.idBarang; 
    vTotNilaiBarang := vTotNilaiBarang - :new.hargaItemTotal;
    update barang set totalNilaiBarang = vTotNilaiBarang where idBarang = :new.idBarang;
END;
/
-- delete in barang
-- prevent losing data barang when delete
/
create or replace TRIGGER trigAntiDeleteItem
after delete ON barang
FOR EACH ROW
BEGIN
    insert into barangTemp values(:old.idBarang,:old.namaBarang,:old.deskripsiBarang,
        'Y',:old.totalStok,:old.createDate,:old.updateDate,:old.totalNilaiBarang);
END;

/
create or replace TRIGGER trigAntiDeleteSupplier
after delete ON supplier
FOR EACH ROW
BEGIN
    insert into supplierTemp values(:old.idSupplier,:old.namaSupplier,:old.deskripsiSupplier);
END;

