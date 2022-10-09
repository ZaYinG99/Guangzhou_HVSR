FI=depth_a_b.txt
GRD=grid.grd
J=m100c
FI_MEAN=depth_mean.txt
RANGE=113.258635/113.407799/22.817701/23.364731
R=113.248333333/113.418333333/22.8075/23.375
gmt begin guangdong_HV_contour png
	gmt gmtset FONT_ANNOT_PRIMARY 30p
	gmt basemap -J$J -R$RANGE -Baf
#	gmt grdcut @earth_relief_01s.grd -R$R -Gtopo.grd  #topography
#	gmt grdgradient topo.grd -Ne0.8 -A100 -Gtopo.grad #topography
#	gmt grdimage topo.grd -Itopo.grad -R$R -J$J -Cg.cpt -E100
	gmt blockmean $FI -R$RANGE -I0.01+e/0.01+e >$FI_MEAN
	gmt surface $FI_MEAN -R$RANGE -I0.01+e/0.01+e -G$GRD -T0.1
#	gmt nearneighbor $FI -R$RANGE -I0.001+e/0.001+e -G$GRD -S100M
#	gmt greenspline $FI -R$RANGE -I0.0002+e/0.0002+e -G$GRD 
	gmt grdimage $GRD -J$J -E500
	gmt grdcontour $GRD -J$J -A20,40,60,80+f12p -R$RANGE -W1p,black 
	gmt plot fault_cn -W2p,red
	#gmt plot bad_stations.txt -Sc0.3 -Gblue
	#gmt text bad_stations.txt -D0/0.4 -F+f6p
	#gmt plot $FI -Sc0.3 -W1p,red
	gmt colorbar
gmt end show
