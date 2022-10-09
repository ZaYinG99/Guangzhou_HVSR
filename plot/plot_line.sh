# ==== 設定變數 ====
out_ps="line1.ps"
in_tif="n13_e123_1arc_v3.tif"   # 地形資料輸入檔，Geotiff 格式 (轉檔前)
in_grd2="pseudo_h.grd"
in_grd1="topo_line.grd"   # 地形資料輸入檔，NetCDF 格式 (轉檔後)
master_cpt=globe        # cpt 來源
in_cpt="mayon.cpt"              # cpt 輸入檔
in_shadow1="mayon_shade.grd"     # 陰影的輸入檔
in_track1="topo_track.xy"
in_track2="br_track.xy"       # 剖面座標的輸入檔
pen="thick,black"               # 畫筆 - 一般
pen_grid="thick,black,--"       # 畫筆 - 網格
pen_track1="2p,black"
pen_track2="2p,darkred"           # 畫筆 - 剖面
font="14p,25,black"             # 字型 - 一般
font_title="24p,25,black"       # 字型 - 標題
font_text="14p,25,black"      # 字型 - 剖面
font_contour="8p,25,darkred"    # 字型 - 等高線
B1=113.33/23.05
E1=113.33/23.21
B2=113.290/23.330
E2=113.40/23.20
B3=113.26/22.83
E3=113.34/22.98
B4=113.32/22.98
E4=113.4/22.88
R1=23.04/23.22
R2=23.17/23.38
R3=22.82/22.99
# ==== 使用 GDAL 轉檔 ====
#     如果你的電腦有安裝 GDAL，可把底下指令的註解取消，如此一來就可從 Geotiff 檔直接轉檔繪圖
#     如果沒有安裝 GDAL，請直接下載 NetCDF 格式 (.grd) 的輸入檔
# gdal_translate $in_tif -of NetCDF $in_grd

# ==== 製作輸入檔===
gmt grdcut @earth_relief_01s.grd -R113.248333333/113.418333333/22.8075/23.375 -G$in_grd1 
gmt grdgradient $in_grd1 -G$in_shadow1 -A310 -Nt0.5
gmt grd2cpt $in_grd1 -C$master_cpt -T-500/500/1 -Z > $in_cpt
gmt grdcut @earth_relief_01m.grd -R113.248333333/113.418333333/22.8075/23.375 -Gtopo1.grd 
# ==== 調整 GMT 預設參數 ====
gmt gmtset MAP_FRAME_TYPE=plain \
       FONT_ANNOT_PRIMARY=$font \
       FONT_LABEL=$font \
       FONT_TITLE=$font_title \
       MAP_GRID_PEN_PRIMARY=$pen_grid \
       MAP_TICK_PEN_PRIMARY=$pen \
       MAP_TICK_PEN_SECONDARY=$pen \
       FORMAT_GEO_MAP ddd.xx    # 此設定會讓座標刻度以「度、分、WNES」的方式顯示

# ==== 開門 (寫入 PS 檔頭) ====

gmt psxy -R0/1/0/1 -JX1c -T -K -P > $out_ps

# ==== 等高線圖 ====
    # 繪製底圖，順便使用 -Y 把地圖上移 10 公分，預留空間給之後的剖面圖
gmt grdimage $in_grd1 -R113.248333333/113.418333333/$R1 -JM12c -O -K -C$in_cpt -I$in_shadow1 -E300 -Y8c >> $out_ps
gmt pscoast -R -J -O -K -Df -Sgray -Wthin >> $out_ps
    # 主要等高線是 500 單位間隔，並加上數值標籤 (-A) ；次要等高線則是 100 單位間隔 (-C)
#gmt grdcontour $in_grd1 -R -J -O -K -C25 -Q20 -A50+f$font_contour+o >> $out_ps


# ==== 製作剖面然後繪製在等高線圖上 ====
    # 給定起終點的經緯度，以每 0.1 公里為距離，對輸入的網格取樣
gmt project -C$B1 -E$E1 -G0.05 -Q |\
gmt grdtrack -Gtopo1.grd > $in_track1
gmt project -C$B1 -E$E1 -G0.05 -Q |\
gmt grdtrack -G$in_grd2 > $in_track2
    # 輸出的檔是四欄：經度、緯度、距離、輸入網格的 z 值
    # psxy 預設使用前兩欄繪圖
gmt psxy $in_track1 -R -J -O -K -W$pen_track1 >> $out_ps
    # 擺上剖面兩端的編號文字，使用不同對齊方式
gmt psxy "didiaoyuan_fault.dat" -W4p,red -R -J -O -K  >>$out_ps

gmt pstext -R -J -O -K -F+j+f$font_text >> $out_ps << TEXTEND
113.33 23.05 RT A
113.33 23.21 LT B


TEXTEND
gmt psbasemap -R -J -O -K -Ba0.1f0.02 -B+t"Line 1" >> $out_ps

# ==== 剖面圖 ====
    # 使用 gmtinfo 取得 -R 的適當設定
R=$(gmt gmtinfo $in_track2 -i2,3 -I1/100)
    # 使用 -Y 把剖面圖下移 8 公分
gmt psxy $in_track1 -i2,3 $R -JX12c/6c -O -K -W$pen_track1 -Y-8c >> $out_ps
gmt psxy $in_track2 -i2,3 $R -JX12c/6c -O -K -W$pen_track2 -L+y-200 -Ggray >> $out_ps
    # 先畫 NE 兩面 (沒有座標軸標籤) 的外框，再畫 WS 兩面的外框
gmt psbasemap -R -J -O -K -BNE -Bxa5f1 -Bya50f25g100 >> $out_ps
gmt psbasemap -R -J -O -K -BWS -Bxa5f1+l"Distance of A-B profile (km)" -Bya50f25+l"Height (m)" >> $out_ps

# ==== 關門 (寫入 EOF) ====
gmt psxy -R -J -O -T >> $out_ps
# rm -rf gmt.conf    # <---- 此行可用於消除舊的組態設定檔