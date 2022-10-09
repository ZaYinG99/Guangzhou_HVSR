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
gmt begin guangdong_thickness_kvalue png
#GEOMAP



	gmt gmtset FORMAT_GEO_MAP ddd.xx
	gmt gmtset FONT_ANNOT_PRIMARY +20p
#	gmt grdcut geo_cn_1-100_11.tif -J$J -R$RANGE -Ggeo.grd
	gmt basemap -J$J -R$RANGE -BWSne -Ba0.1f0.02+f
	gmt grdimage -J$J -R$RANGE  -D geo_cn_1-100_10.tif #-Ichina_grad.grd
#	gmt grdimage -J$J -R$RANGE -Ba0.1f0.2 -D geo.grd
	#gmt grdimage geo.png -J$J -R$RANGE 
	gmt plot didiaoyuan_fault1.dat -W4p,red -Sqn1:+Lh+f26p,black+n0c/0.5c
#	gmt text fault_list1  -F+a+f
#	gmt legend -DjBR+w8c+o-10c/0.5c  -C4p/4p <<EOF

#S 0.1i r 1i 255/255/223 0.25p 0.75i Qd
#G 0.3i
#S 0.1i r 1i 255/255/183 0.25p 0.75i Qm
#G 0.3i
#S 0.1i r 1i 255/255/93 0.25p 0.75i Qdw
#G 0.3i
#S 0.1i r 1i 255/255/91 0.25p 0.75i Qxs
#G 0.3i
#S 0.1i r 1i 255/254/166 0.25p 0.75i Eby
#G 0.3i
#S 0.1i r 1i 255/255/0 0.25p 0.75i Kd
#G 0.3i
#S 0.1i r 1i 237/115/132 0.25p 0.75i J2@%12%\\147 
#G 0.3i
#S 0.1i r 1i 237/103/105 0.25p 0.75i J3@%12%\\147 
#G 0.3i
#S 0.1i r 1i 255/77/78 0.25p 0.75i Jm
#G 0.3i
#S 0.1i r 1i 249/220/39 0.25p 0.75i Ts
#G 0.3i
#S 0.1i r 1i 183/255/0 0.25p 0.75i Pzmi
#G 0.3i
#S 0.1i r 1i 237/234/223 0.25p 0.75i Cds
#G 0.3i
#S 0.1i r 1i 249/0/0 0.25p 0.75i O@%12%\\147 
#G 0.3i
#S 0.1i r 1i 255/220/105 0.25p 0.75i Zd
#EOF

#THICNKESS
	gmt basemap -J$J -R$R -BwSne -Ba0.1f0.02+f -Xw+5c 
#	gmt grdcut @earth_relief_01s.grd -R$R -Gtopo.grd
#	gmt grdgradient topo.grd -Ne0.8 -A310 -Gtopo.grad
	gmt grdimage topo.grd -Itopo.grad -R$R -J$J -Cg.cpt -E500
	gmt blockmean $FI -R$RANGE -I0.02+e/0.02+e >$FI_MEAN
#	gmt surface $FI_MEAN -R$RANGE -I0.01+e/0.01+e -G$GRD -T0
#	gmt nearneighbor $FI_MEAN -R$RANGE -I0.01+e/0.01+e -G$GRD -S200M
	gmt greenspline $FI_MEAN  -R$RANGE -I0.02+e/0.02+e -Sc -Z2 -G$GRD 
	gmt grdimage $GRD -J$J -t30 -E500 -CHV1.cpt
	gmt plot didiaoyuan_fault1.dat -W4p,red -Sqn1:+Lh+f26p,black+n0c/0.5c
	#gmt plot bad_stations.txt -Sc0.3 -Gblue
	#gmt text bad_stations.txt -D0/0.4 -F+f6p
	#gmt plot $FI -Sc0.3 -W1p,red
	gmt plot bad_stations.txt -St0.5 -Gred
	gmt plot multi_stations.txt -St0.5 -Gblue
	gmt colorbar -CHV1.cpt -Ba10+l"Sediment thickness (m)"

#KVALUE
	gmt basemap -J$J -R$R -BwSnE -Ba0.1f0.02+f -Xw+5c
#	gmt grdcut @earth_relief_01s.grd -R$R -Gtopo.grd
#	gmt grdgradient topo.grd -Ne0.8 -A310 -Gtopo.grad
	gmt grdimage topo.grd -Itopo.grad -R$R -J$J -Cg.cpt -E500
	gmt blockmean $FI1 -R$RANGE -I0.02+e/0.02+e >$FI_MEAN1
#	gmt surface $FI_MEAN1 -R$RANGE -I0.01+e/0.01+e -G$GRD1 -T0
#	gmt nearneighbor $FI_MEAN1 -R$RANGE -I0.01+e/0.01+e -G$GRD1 -S200M
	gmt greenspline $FI_MEAN1 -R$RANGE -I0.02+e/0.02+e -Sc -Z2 -G$GRD1 
	gmt grdimage $GRD1 -J$J -t50 -E500 -CHVp.cpt
	gmt plot didiaoyuan_fault1.dat -W4p,red -Sqn1:+Lh+f26p,black+n0c/0.5c
	gmt plot -R$R -J$J guangdong_3.gmt -W4p,black,dashdot
	gmt text area_list  -F+a+f
	gmt colorbar -CHVp.cpt -Ba20+l"K value"
	
gmt end show