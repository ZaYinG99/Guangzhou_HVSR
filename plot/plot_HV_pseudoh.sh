J=m100c

RANGE=113.258635/113.407799/22.817701/23.364731
R=113.248333333/113.418333333/22.8075/23.375
gmt makecpt -Cgray -T-200/200/5 -Z >g1.cpt

gmt begin guangdong_psudo_h png
	gmt gmtset FORMAT_GEO_MAP ddd.xx
	gmt gmtset FONT_ANNOT_PRIMARY 30p
	gmt basemap -J$J -R$R -Ba0.1f0.02
	#gmt grdimage topo.grd -Itopo.grad -R$R -J$J -Cg.cpt -E100
	gmt blockmean altitude.txt -R$RANGE -I0.015+e/0.015+e >pseudo_h_mean.txt
	gmt surface pseudo_h_mean.txt -R$RANGE -I0.01+e/0.01+e -Gpseudo_h.grd -T0
	gmt grdgradient pseudo_h.grd -Ne1 -A325 -Gpseudo_h.grad
#	gmt nearneighbor $FI -R$RANGE -I0.001+e/0.001+e -G$GRD -S100M
#	gmt greenspline $FI -R$RANGE -I0.0002+e/0.0002+e -G$GRD 
	gmt grdimage pseudo_h.grd -Ipseudo_h.grad -Cg1.cpt -R$RANGE -J$J -E300  
#	gmt grdimage pseudo_h.grd -R$RANGE -J$J -E300  
#	gmt colorbar
	gmt plot fault_cn -W4p,red
	#gmt plot bad_stations.txt -Sc0.3 -Gblue
	#gmt text bad_stations.txt -D0/0.4 -F+f6p
	#gmt plot $FI -Sc0.3 -W1p,red
	#gmt colorbar

gmt end show
