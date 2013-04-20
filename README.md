# Wishbone BFM verilog portint
Verilogで書かれたWishboneのBFMです。

VHDLで書かれたオリジナルは、ここから入手できます。
http://opencores.org/project,wishbone_bfm

## サポートしているAPI
* rd_32 32bitシングルリード
* wr_32 32bitシングルライト
* rmw 32bitリードモディファイライト 

各APIの使い方は、 io_package.v を参照してください。

## ライセンス
オリジナルと同じLGPLです。