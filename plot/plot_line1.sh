J=m100c
R=0/20/-50/80
B1=113.33/23.05
E1=113.33/23.21
B2=113.290/23.330
E2=113.40/23.20
B3=113.26/22.83
E3=113.34/22.98
B4=113.32/22.98
E4=113.4/22.88


gmt begin guangdong_psudo_h_line3 png
	gmt gmtset FONT_ANNOT_PRIMARY 30p
	gmt grdcut @earth_relief_01m.grd -R113.248333333/113.418333333/22.8075/23.375 -Gtopo1.grd 
	gmt project -C$B3 -E$E3  -G0.05 -Q | gmt grdtrack -Gtopo1.grd  > topo.xy
	gmt project -C$B3 -E$E3  -G0.05 -Q | gmt grdtrack -Gpseudo_h.grd  > pseudo_h.xy
	gmt plot pseudo_h.xy -i2,3 -R$R  -Wthick,darkred -Ggray -L+y-200
	gmt plot topo.xy -i2,3 -R$R -Wthick 
	gmt basemap -R$R -BWS -Bxa5f1+l"Distance along the @;red;Line3 profile@;; (km)" -Bya10f10g20+l"Elevation (m)"

gmt end show
