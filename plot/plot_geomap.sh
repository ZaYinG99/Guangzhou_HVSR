FI=depth_vs_4f.txt
GRD=grid.grd
J=M20c
FI_MEAN=depth_mean.txt
RANGE=113.248333333/113.418333333/22.8075/23.375
R=113.2/113.5/22.7/23.46
gmt makecpt -Cglobe -T-100/500/1000+ -Z >gnew.cpt
gmt begin guangdong_geomap2 png
	gmt gmtset MAP_FRAME_TYPE fancy
	gmt gmtset FONT_ANNOT_PRIMARY +30p
	gmt basemap -J$J -R$RANGE -BWSne -Ba0.1f0.02
	gmt grdimage geo.png -J$J -R$RANGE 
	gmt plot didiaoyuan_fault.dat -W1p,red
	gmt text fault_list1  -F+a+f
	gmt legend -DjBR+w8c+o-10c/0.5c  -C4p/4p <<EOF

S 0.1i r 1i 255/255/223 0.25p 0.75i Qd
G 0.3i
S 0.1i r 1i 255/255/183 0.25p 0.75i Qm
G 0.3i
S 0.1i r 1i 255/255/93 0.25p 0.75i Qdw
G 0.3i
S 0.1i r 1i 255/255/91 0.25p 0.75i Qxs
G 0.3i
S 0.1i r 1i 255/254/166 0.25p 0.75i Eby
G 0.3i
S 0.1i r 1i 255/255/0 0.25p 0.75i Kd
G 0.3i
S 0.1i r 1i 237/115/132 0.25p 0.75i J2@%12%\\147 
G 0.3i
S 0.1i r 1i 237/103/105 0.25p 0.75i J3@%12%\\147 
G 0.3i
S 0.1i r 1i 255/77/78 0.25p 0.75i Jm
G 0.3i
S 0.1i r 1i 249/220/39 0.25p 0.75i Ts
G 0.3i
S 0.1i r 1i 183/255/0 0.25p 0.75i Pzmi
G 0.3i
S 0.1i r 1i 237/234/223 0.25p 0.75i Cds
G 0.3i
S 0.1i r 1i 249/0/0 0.25p 0.75i O@%12%\\147 
G 0.3i
S 0.1i r 1i 255/220/105 0.25p 0.75i Zd
EOF
#	gmt colorbar -Cgnew.cpt  -Ba100+l"Elevation/m" -G-100/500
gmt end show
