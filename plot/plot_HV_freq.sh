FI=sta_hvsr.txt
GRD=hvsr_grad.grd
J=m100c
FI_MEAN=hvsr_mean.txt
CPT_P=HVv.cpt
RANGE=113.258635/113.407799/22.817701/23.364731
R=113.248333333/113.418333333/22.8075/23.375

gmt makecpt -Chaxby -Ic -T0/10/0.5 -D -V -F -Z  >$CPT_P
gmt begin guangdong_HV_peak_f png
	gmt gmtset FORMAT_GEO_MAP ddd.xx
	gmt gmtset FONT_ANNOT_PRIMARY 30p
	gmt basemap -J$J -R$R -Ba0.1f0.02
	gmt grdcut @earth_relief_01s.grd -R$R -Gtopo.grd
	gmt grdgradient topo.grd -Ne0.8 -A310 -Gtopo.grad
	gmt grdimage topo.grd -Itopo.grad -R$R -J$J -Cg.cpt -E100
	gmt blockmean $FI -R$RANGE -I0.015+e/0.015+e >$FI_MEAN
	gmt surface $FI_MEAN -R$RANGE -I0.01+e/0.01+e -G$GRD -T0
#	gmt nearneighbor $FI -R$RANGE -I0.001+e/0.001+e -G$GRD -S100M
#	gmt greenspline $FI -R$RANGE -I0.0002+e/0.0002+e -G$GRD 
	gmt grdimage $GRD -J$J -t50 -E500 -C$CPT_P
	gmt plot didiaoyuan_fault.dat -W4p,red
	#gmt plot bad_stations.txt -Sc0.3 -Gblue
	#gmt text bad_stations.txt -D0/0.4 -F+f6p
	#gmt plot $FI -Sc0.3 -W1p,red
	gmt colorbar -C$CPT_P -Ba2
gmt end show
