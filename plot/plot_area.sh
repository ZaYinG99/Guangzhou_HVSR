FI=depth_a_b.txt
GRD=grid.grd
J=m100c
FI_MEAN=depth_mean.txt
RANGE=113.258635/113.407799/22.817701/23.364731
R=113.248333333/113.418333333/22.8075/23.375

gmt begin guangdong_HV_area png
	gmt gmtset FONT_ANNOT_PRIMARY 30p
	gmt basemap -J$J -R$RANGE -Baf
	gmt blockmean $FI -R$RANGE -I0.01+e/0.01+e >$FI_MEAN
	gmt surface $FI_MEAN -R$RANGE -I0.01+e/0.01+e -G$GRD -T0.1

	gmt grdimage $GRD -J$J -E300
	gmt plot fault_cn -W2p,red
	gmt plot -R$RANGE -J$J guangdong_3.gmt -W1.5p,black

	gmt colorbar
gmt end show
