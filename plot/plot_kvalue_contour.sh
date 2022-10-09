FI=depth_a_b.txt
GRD=grid_thickness.grd
J=M40ch
FI_MEAN=depth_mean.txt
#RANGE=113.258635/113.407799/22.817701/23.364731
RANGE=113.26/113.41/22.82/23.36
R=113.248333333/113.418333333/22.8075/23.375
FI1=K_value.txt
GRD1=grid_kvalue.grd
FI_MEAN1=kvalue_mean.txt
gmt makecpt -Cgray -T-500/500/1000+ -Z >g.cpt
gmt makecpt -Cturbo -T0/80/10 -D -V -F  > HV1.cpt
gmt makecpt -Chaxby -T0/60/20 -D -V -F  > HVp.cpt
gmt begin guangdong_kvalue_station png
	gmt basemap -J$J -R$R -BwSnE -Ba0.1f0.02+f
#	gmt grdcut @earth_relief_01s.grd -R$R -Gtopo.grd
#	gmt grdgradient topo.grd -Ne0.8 -A310 -Gtopo.grad
	gmt grdimage topo.grd -Itopo.grad -R$R -J$J -Cg.cpt -E500
	gmt blockmean $FI1 -R$RANGE -I0.02+e/0.02+e >$FI_MEAN1
#	gmt surface $FI_MEAN1 -R$RANGE -I0.01+e/0.01+e -G$GRD1 -T0
#	gmt nearneighbor $FI_MEAN1 -R$RANGE -I0.01+e/0.01+e -G$GRD1 -S200M
	gmt greenspline $FI_MEAN1 -R$RANGE -I0.02+e/0.02+e -Sc -Z2 -G$GRD1 
	gmt grdimage $GRD1 -J$J -t50 -E500 -CHVp.cpt
#	gmt plot didiaoyuan_fault1.dat -W4p,red -Sqn1:+Lh+f26p,black+n0c/0.5c
	gmt plot -R$R -J$J guangdong_3.gmt -W4p,black,dashdot
	gmt text stations_compare.txt -D1/1 -F+f18p
	gmt plot stations_compare.txt -St1 -Gred
	gmt colorbar -CHVp.cpt -Ba20+l"K value"
gmt end show	