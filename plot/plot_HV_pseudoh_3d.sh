J=m100c

RANGE=113.258635/113.407799/22.817701/23.364731
R=113.248333333/113.418333333/22.8075/23.375
B1=113.33/23.05/113.33/23.21
B2=113.290/23.330/113.40/23.20
B3=113.26/22.83/113.34/22.98
B4=113.32/22.98/113.4/22.88


gmt makecpt -Chaxby  -T-100/200/10 -Z >g1.cpt
gmt begin guangdong_psudo_h_3d png
	gmt gmtset FORMAT_GEO_MAP ddd.xx
	gmt gmtset FONT_ANNOT_PRIMARY 30p
#	gmt basemap -J$J -R$R -Ba0.1f0.02
	gmt blockmean altitude.txt -R$R -I0.015+e/0.015+e >pseudo_h_mean.txt
	gmt surface pseudo_h_mean.txt -R$R -I0.01+e/0.01+e -Gpseudo_h.grd -T0.1
	gmt grdtrack -R$R -Gpseudo_h.grd didiaoyuan_fault.dat >faults.xyz
	gmt grdgradient pseudo_h.grd -Ne0.8 -A330 -Gpseudo_h.grad
	gmt grdview pseudo_h.grd -R$R/-100/200 -J$J -JZ30c -N-100+ggray -Qi -I -BWSZ -Bxya0.1f0.02 -Bza100f50 -p230/45 -Cg1.cpt #-Ipseudo_h.grad
	gmt plot3d faults.xyz -W4p,red -p 
#    gmt colorbar -C -Ba -DJTC+o0/1c -p

#	gmt grdimage pseudo_h.grd -Cg1.cpt -R$R -J$J -E300 -Ipseudo_h.grad 

	gmt colorbar -Cg1.cpt -Ba100 -p
#	gmt basemap -TdjLB+w1.5c+l+o1c -p60/25/100
gmt end show
