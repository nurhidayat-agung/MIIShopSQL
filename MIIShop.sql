/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     1/17/2018 6:23:46 AM                         */
/*==============================================================*/


alter table DETAILJUAL
   drop constraint FK_DETAILJU_AMBILSTOK_PEMBELIA;

alter table DETAILJUAL
   drop constraint FK_DETAILJU_BERISI_PENJUALA;

alter table PEMBELIANBARANG
   drop constraint FK_PEMBELIA_BARANGMAS_BARANG;

alter table PEMBELIANBARANG
   drop constraint FK_PEMBELIA_DIDISTRIB_SUPPLIER;

alter table PEMBELIANBARANG
   drop constraint FK_PEMBELIA_DITERIMAO_KARYAWAN;

alter table PENJUALANBARANG
   drop constraint FK_PENJUALA_DIBELIOLE_MEMBER;

alter table PENJUALANBARANG
   drop constraint FK_PENJUALA_DILAYANEO_KARYAWAN;

drop table BARANG cascade constraints;

drop index AMBILSTOKDARI_FK;

drop index BERISI_FK;

drop table DETAILJUAL cascade constraints;

drop table KARYAWAN cascade constraints;

drop table MEMBER cascade constraints;

drop index DITERIMAOLEH_FK;

drop index DIDISTRIBUSIKAN_FK;

drop index BARANGMASUK_FK;

drop table PEMBELIANBARANG cascade constraints;

drop index DIBELIOLEH_FK;

drop index DILAYANEOLEH_FK;

drop table PENJUALANBARANG cascade constraints;

drop table SUPPLIER cascade constraints;

/*==============================================================*/
/* Table: BARANG                                                */
/*==============================================================*/
create table BARANG 
(
   IDBARANG             NUMBER(16)           not null,
   NAMABARANG           CHAR(25),
   DESKRIPSIBARANG      CHAR(255),
   ISDELETE             CHAR(1),
   TOTALSTOK            NUMBER(16),
   CREATEDATE           DATE,
   UPDATEDATE           DATE,
   TOTALNILAIBARANG     NUMBER(16),
   constraint PK_BARANG primary key (IDBARANG)
);

/*==============================================================*/
/* Table: DETAILJUAL                                            */
/*==============================================================*/
create table DETAILJUAL 
(
   IDDETAILJUAL         NUMBER(16)           not null,
   IDJUAL               NUMBER(16)           not null,
   IDBARANG             NUMBER(16)           not null,
   QTY                  NUMBER(16),
   HARGAITEMTOTAL       NUMBER(16),
   IDBELI               NUMBER(16),
   constraint PK_DETAILJUAL primary key (IDDETAILJUAL)
);

/*==============================================================*/
/* Index: BERISI_FK                                             */
/*==============================================================*/
create index BERISI_FK on DETAILJUAL (
   IDJUAL ASC
);

/*==============================================================*/
/* Index: AMBILSTOKDARI_FK                                      */
/*==============================================================*/
create index AMBILSTOKDARI_FK on DETAILJUAL (
   IDBELI ASC
);

/*==============================================================*/
/* Table: KARYAWAN                                              */
/*==============================================================*/
create table KARYAWAN 
(
   NIK                  NUMBER(25)           not null,
   NAMAKARYAWAN         CHAR(25),
   PASSWORD             CHAR(15)             not null,
   JOB                  CHAR(25),
   constraint PK_KARYAWAN primary key (NIK)
);

/*==============================================================*/
/* Table: MEMBER                                                */
/*==============================================================*/
create table MEMBER 
(
   IDMEMBER             NUMBER(16)           not null,
   NAMAMEMBER           CHAR(25),
   POINT                NUMBER(16),
   SALDO                NUMBER(16),
   constraint PK_MEMBER primary key (IDMEMBER)
);

/*==============================================================*/
/* Table: PEMBELIANBARANG                                       */
/*==============================================================*/
create table PEMBELIANBARANG 
(
   IDBELI               NUMBER(16)           not null,
   IDBARANG             NUMBER(16)           not null,
   IDSUPPLIER           NUMBER(16)           not null,
   NIK                  NUMBER(25)           not null,
   TANGGALBELI          DATE,
   QTY                  NUMBER(16),
   STOK                 NUMBER(16),
   HARGABELI            NUMBER(16),
   HARGAJUAL            NUMBER(16),
   HARGATOTAL           NUMBER(16),
   constraint PK_PEMBELIANBARANG primary key (IDBELI)
);

/*==============================================================*/
/* Index: BARANGMASUK_FK                                        */
/*==============================================================*/
create index BARANGMASUK_FK on PEMBELIANBARANG (
   IDBARANG ASC
);

/*==============================================================*/
/* Index: DIDISTRIBUSIKAN_FK                                    */
/*==============================================================*/
create index DIDISTRIBUSIKAN_FK on PEMBELIANBARANG (
   IDSUPPLIER ASC
);

/*==============================================================*/
/* Index: DITERIMAOLEH_FK                                       */
/*==============================================================*/
create index DITERIMAOLEH_FK on PEMBELIANBARANG (
   NIK ASC
);

/*==============================================================*/
/* Table: PENJUALANBARANG                                       */
/*==============================================================*/
create table PENJUALANBARANG 
(
   IDJUAL               NUMBER(16)           not null,
   IDMEMBER             NUMBER(16)           not null,
   TOTALBAYAR           NUMBER(16),
   UANGDIBAYAR          NUMBER(16),
   UANGKEMBALI          NUMBER(16),
   NIK                  NUMBER(25),
   TGLJUAL              DATE,
   constraint PK_PENJUALANBARANG primary key (IDJUAL)
);

/*==============================================================*/
/* Index: DILAYANEOLEH_FK                                       */
/*==============================================================*/
create index DILAYANEOLEH_FK on PENJUALANBARANG (
   NIK ASC
);

/*==============================================================*/
/* Index: DIBELIOLEH_FK                                         */
/*==============================================================*/
create index DIBELIOLEH_FK on PENJUALANBARANG (
   IDMEMBER ASC
);

/*==============================================================*/
/* Table: SUPPLIER                                              */
/*==============================================================*/
create table SUPPLIER 
(
   IDSUPPLIER           NUMBER(16)           not null,
   NAMASUPPLIER         CHAR(25),
   DESKRIPSISUPPLIER    CHAR(25),
   constraint PK_SUPPLIER primary key (IDSUPPLIER)
);

alter table DETAILJUAL
   add constraint FK_DETAILJU_AMBILSTOK_PEMBELIA foreign key (IDBELI)
      references PEMBELIANBARANG (IDBELI);

alter table DETAILJUAL
   add constraint FK_DETAILJU_BERISI_PENJUALA foreign key (IDJUAL)
      references PENJUALANBARANG (IDJUAL);

alter table PEMBELIANBARANG
   add constraint FK_PEMBELIA_BARANGMAS_BARANG foreign key (IDBARANG)
      references BARANG (IDBARANG);

alter table PEMBELIANBARANG
   add constraint FK_PEMBELIA_DIDISTRIB_SUPPLIER foreign key (IDSUPPLIER)
      references SUPPLIER (IDSUPPLIER);

alter table PEMBELIANBARANG
   add constraint FK_PEMBELIA_DITERIMAO_KARYAWAN foreign key (NIK)
      references KARYAWAN (NIK);

alter table PENJUALANBARANG
   add constraint FK_PENJUALA_DIBELIOLE_MEMBER foreign key (IDMEMBER)
      references MEMBER (IDMEMBER);

alter table PENJUALANBARANG
   add constraint FK_PENJUALA_DILAYANEO_KARYAWAN foreign key (NIK)
      references KARYAWAN (NIK);

