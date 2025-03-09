# Etiquetas ambientales de la DGT
# www.overfitting.net
# https://www.overfitting.net/

library(data.table)


# Microdatos DGT distintivo ambiental:
# https://www.dgt.es/menusecundario/dgt-en-cifras/dgt-en-cifras-resultados/
# dgt-en-cifras-detalle/Microdatos-de-Distintivo-Ambiental-de-Vehiculos-diarios/

# https://pegatinasdgt.net/

# IDENTIFICADOR DE ETIQUETA	DESCRIPCIÓN DE LA ETIQUETA:
# -----------------------------------------------------
# 16TB, 16MB	Etiqueta Ambiental B Amarilla
# 16TC, 16MC	Etiqueta Ambiental C Verde
# 16T0, 16M0	Etiqueta Ambiental 0 Azul
# 16TE, 16ME    Etiqueta Ambiental ECO
# TIV0	        Sin distintivo


# Read DGT data
dgt1=fread("export_distintivo_ambiental_20250103.txt", sep='|')
dgt2=fread("export_distintivo_ambiental_20250307.txt", sep='|')

# Table cleaning
setnames(dgt1, "TIPO DE ETIQUETA", "ETIQUETA1")
setnames(dgt2, "TIPO DE ETIQUETA", "ETIQUETA2")

dgt1[ETIQUETA1 %in% c('16TB', '16MB'), ETIQUETA1:="4_Etiqueta B"]
dgt1[ETIQUETA1 %in% c('16TC', '16MC'), ETIQUETA1:="3_Etiqueta C"]
dgt1[ETIQUETA1 %in% c('16T0', '16M0'), ETIQUETA1:="1_Etiqueta 0"]
dgt1[ETIQUETA1 %in% c('16TE', '16ME'), ETIQUETA1:="2_Etiqueta ECO"]
dgt1[ETIQUETA1 %in% c('SIN DISTINTIVO'), ETIQUETA1:="5_Sin Etiqueta"]

dgt2[ETIQUETA2 %in% c('16TB', '16MB'), ETIQUETA2:="4_Etiqueta B"]
dgt2[ETIQUETA2 %in% c('16TC', '16MC'), ETIQUETA2:="3_Etiqueta C"]
dgt2[ETIQUETA2 %in% c('16T0', '16M0'), ETIQUETA2:="1_Etiqueta 0"]
dgt2[ETIQUETA2 %in% c('16TE', '16ME'), ETIQUETA2:="2_Etiqueta ECO"]
dgt2[ETIQUETA2 %in% c('SIN DISTINTIVO'), ETIQUETA2:="5_Sin Etiqueta"]

dgt1[, .N, by=ETIQUETA1][order(ETIQUETA1)]
dgt2[, .N, by=ETIQUETA2][order(ETIQUETA2)]

# Full outer join
dgtcruce=merge(dgt1, dgt2, by="MATRICULA", all=TRUE)
dgtcruce[is.na(ETIQUETA1), ETIQUETA1:="6_Alta"]  # nueva matriculación
dgtcruce[is.na(ETIQUETA2), ETIQUETA2:="6_Baja"]  # matrícula dada de baja

# Save
write.csv2(dgtcruce[, .N, by=.(ETIQUETA1, ETIQUETA2)][order(-N)],
           "dgt.csv", quote=FALSE, row.names=FALSE)


