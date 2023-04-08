drop table if exists QuoteKline;
create table QuoteKline
(
  id            bigint         not null comment '主键' primary key,
  exchange      varchar(10)    not null comment '交易所',
  marketType    varchar(10)    not null comment '市场类型',
  commodityCode varchar(10)    not null comment '品种代码',
  contractCode  varchar(20)    not null comment '合约代码',
  timeType      int            not null comment 'k线时间类型',
  displayTime   bigint         not null comment 'k线展示时间',
  createTime    bigint         not null comment '记录创建时间',
  openPrice     decimal(24, 8) not null comment '开盘价',
  closePrice    decimal(24, 8) not null comment '收盘价',
  highPrice     decimal(24, 8) not null comment '最高价',
  lowPrice      decimal(24, 8) not null comment '最低价',
  sumAmt        decimal(24, 8) not null comment '总成交量',
  sumBal        decimal(24, 8) not null comment '总成交额'
) comment '行情k线表';
