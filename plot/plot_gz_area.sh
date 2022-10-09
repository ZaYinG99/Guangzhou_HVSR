FI=depth_vs_4f.txt
GRD=grid.grd
J=M20ch
Rg=100/130/15/35
Jg=M10ch
FI_MEAN=depth_mean.txt
RANGE=113.258635/113.407799/22.817701/23.364731
R=112.8/114.0/22.5/23.7
R1=113.2/113.5/22.7/23.46
gmt makecpt -Cglobe -T-100/500/1000+ -Z >gnew.cpt
gmt begin guangzhou_area png
	gmt gmtset MAP_FRAME_TYPE fancy
	gmt gmtset FONT_ANNOT_PRIMARY +20p
	gmt basemap -J$J -R$R -BWSne -Ba0.5f0.25+f
	gmt grdcut @earth_relief_01s.grd -R$R -Gtopo.grd
	gmt grdgradient topo.grd -Ne1 -A310 -Gtopo.grad
	gmt grdimage topo.grd -Itopo.grad -R$R -J$J -Cgnew.cpt -E100
	gmt coast -R$R -J$J -Da -Sdodgerblue -Wthin
	gmt plot didiaoyuan_fault1.dat -W2p,red
	#gmt plot bad_stations.txt -Sc0.3 -Gblue
	gmt text fault_list  -F+a+f
	gmt plot -R$R -J$J guangzhou.gmt -W2p,blue,dashdot
	gmt plot -Sr+s -W2p,black  << EOF
	113.257 22.815 113.408 23.3650
EOF
	gmt inset begin -DjRB+w6c/4.8c+o0.1c -F+gwhite+p1p
		gmt coast -R$Rg -JM? -B0 -B+gwhite -Df -N1 -W -A5000  --MAP_FRAME_TYPE=plain 
		echo 112.8 22.5 114.0 23.7 | gmt plot -Sr+s -W1p,blue 
	gmt inset end
#	gmt plot  guangdong_2.gmt -W2p,black,dashdot
	
	


	gmt basemap -J$J -R$R1 -BWSne -Ba0.2f0.1+f -Xw+20c
	gmt grdcut @earth_relief_01s.grd -R$R1 -Gtopo.grd
	gmt grdgradient topo.grd -Ne1 -A310 -Gtopo.grad
	gmt grdimage topo.grd -Itopo.grad -R$R1 -J$J -Cgnew.cpt -E100
	gmt plot didiaoyuan_fault1.dat -W2p,red
#	gmt plot  guangdong_3.gmt -W1.5p,black,dashdot
	gmt plot station_list -St0.2 -Gblack
	gmt plot -Sr+s -W2p,black  << EOF
	113.257 22.815 113.408 23.3650
EOF

gmt end show
