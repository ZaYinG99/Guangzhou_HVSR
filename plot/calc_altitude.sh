R=113.248333333/113.418333333/22.8075/23.375
gmt grdcut @earth_relief_01s.grd -R$R -Gtopo.grd
gmt grdtrack depth_a_b.txt -Gtopo.grd >altitiude.txt