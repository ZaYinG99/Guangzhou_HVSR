FI=depth_vs_4f.txt
GRD=grid.grd
J=M20c
FI_MEAN=depth_mean.txt
RANGE=113.258635/113.407799/22.817701/23.364731
R=113.2/113.5/22.7/23.46
gmt makecpt -Cglobe -T-100/500/1000+ -Z >gnew.cpt
gmt begin guangdong_station1 png
	gmt gmtset MAP_FRAME_TYPE fancy
	gmt gmtset FONT_ANNOT_PRIMARY +30p
	gmt basemap -J$J -R$R -BWSne -Ba0.1f0.02 
	gmt grdcut @earth_relief_01s.grd -R$R -Gtopo.grd
	gmt grdgradient topo.grd -Ne1 -A310 -Gtopo.grad
	gmt grdimage topo.grd -Itopo.grad -R$R -J$J -Cgnew.cpt -E100

	gmt plot didiaoyuan_fault.dat -W4p,red

	gmt plot  guangdong_3.gmt -W4p,black,dashdot
	gmt plot station_list -St0.4 -Gblack
	gmt plot -Sr+s -W3p,black  << EOF
	113.257 22.815 113.408 23.3650
EOF

gmt end show
