wd<-"C:/Users/marco/IPN_BigData/Modulo2/Práctica 1"
setwd(wd)
library(reshape2)

# Carga de datos

data1<-read.csv("StatusData.csv", header=F)
data2<-read.csv("StatusData2.csv", header=F)
data3<-read.csv("StatusData3.csv", header=F)
data4<-read.csv("StatusData4.csv", header=F)
data<-rbind(data1,data2,data3,data4)

save.image("ws.RData")

colnames(data)<-c("vehiculo","fecha","diagnostico","valor")

# Limpiado de datos

tidy<-data[data$diagnostico %in% c("DiagnosticTotalFuelUsedId","DiagnosticOdometerId"),]
tidy<-tidy[!duplicated(tidy),]

tidy$fecha2<-gsub("T"," ", tidy$fecha)
tidy$fecha2<-gsub("Z","", tidy$fecha2)
tidy$fecha2<-as.POSIXct(tidy$fecha2)
tidy$fecha3<-as.Date(tidy$fecha2)

odom<-tidy[tidy$diagnostico=="DiagnosticOdometerId",]
fuel<-tidy[tidy$diagnostico=="DiagnosticTotalFuelUsedId",]

# Transformación de datos

aggodom<-aggregate(odom$valor, by=list(odom$vehiculo, odom$fecha3), min)
colnames(aggodom)<-c("vehiculo","fecha3","odom")
aggfuel<-aggregate(fuel$valor, by=list(fuel$vehiculo, fuel$fecha3),min)
colnames(aggfuel)<-c("vehiculo","fecha3","fuel")

# Normalización de valores por lag diff

for (v in unique(aggodom$vehiculo)){
  aux2<-aggodom[aggodom$vehiculo==v,]
  aux2<-aux2[order(aux2$fecha3),]
  aux2$odomdif<-c(0,diff(aux2$odom))
  if(v == "A1"){
    aux3<-aux2
  } else {
    aux3 <- rbind(aux3,aux2)
  }
}
aggodom2<-aux3
aux3<-NULL

for (v in unique(aggfuel$vehiculo)){
  aux2<-aggfuel[aggfuel$vehiculo==v,]
  aux2<-aux2[order(aux2$fecha3),]
  aux2$fueldif<-c(0,diff(aux2$fuel))
  if(v == "A1"){
    aux3<-aux2
  } else {
    aux3 <- rbind(aux3,aux2)
  }
}
aggfuel2<-aux3
aux3<-NULL

# Transforamción de datos (Unión de tablas)

dataf<-aggodom2
colnames(dataf)<-c("vehiculo","fecha3","odom","odomdif")
colnames(aggfuel2)<-c("vehiculo","fecha3","fuel","fueldif")
dataf<-merge(dataf, aggfuel2, by=c("vehiculo","fecha3"), all.x=T, all.y=T)

#plot(dataf$odomdif, dataf$fueldif, pch=20, col=dataf$vehiculo)

# Deteccíon y Tipificación de datos faltantes

dataf$rendimiento<-dataf$odomdif/dataf$fueldif

dataf$anomalia<-ifelse((dataf$fueldif==0|is.na(dataf$fueldif))&dataf$odomdif==0,"Vehículo parado/Inicio",
                              ifelse(dataf$odomdif==0&dataf$fueldif>0, "Dato inconsistente distancia",
                                     ifelse(is.na(dataf$fueldif),"Dato faltante gasolina",
                                            "No anomalía")))



# Valores anomálicos

plo<-dataf[dataf$anomalia=="No anomalía",]
bxo<-boxplot(plo$rendimiento)
dataf$anomalia<-ifelse(dataf$rendimiento %in% bxo$out[bxo$out!=0], "Valor anomálico",dataf$anomalia)
dataf$anomalia<-as.factor(dataf$anomalia)

plot(dataf$odomdif, dataf$fueldif, col=dataf$anomalia, pch=20)

tidy2<-dataf[dataf$anomalia=="No anomalía",]

# Modelo de regresión

lmod <- lm(tidy2$fueldif ~ 0+ tidy2$odomdif) 
summary(lmod)

plot(tidy2$odomdif, tidy2$fueldif, pch=20)
abline(lmod, lwd=2, col="blue")

# Imputación de valores 

supertidy<-dataf[,-c(3,5)]
supertidy$fueldif<-ifelse(supertidy$anomalia %in% c("Vehículo parado/Inicio","Dato faltante gasolina"),
                          lmod$coefficients[[1]]*supertidy$odomdif,
                          supertidy$fueldif)
supertidy$odomdif<-ifelse(supertidy$anomalia %in% c("Dato inconsistente distancia"),
                          supertidy$fueldif/lmod$coefficients[[1]],
                          supertidy$odomdif)
supertidy$rendimiento<-supertidy$odomdif/supertidy$fueldif

# vehículo con mayor rendimiento
aux<-aggregate(plo$rendimiento, by=list(plo$vehiculo), mean)
colnames(aux)<-c("Vehículo","rendimiento_promedio")
aux<-aux[order(aux$rendimiento_promedio, decreasing=T),]
aux

# Vehículo que trabajó más días
aux<-aggregate(plo$fecha3, by=list(plo$vehiculo), min)
colnames(aux)<-c("Vehículo","min")
aux2<-aggregate(plo$fecha3, by=list(plo$vehiculo), max)
colnames(aux2)<-c("Vehículo","max")
aux3<-merge(aux, aux2, by="Vehículo")
aux3$dif<-aux3$max-aux3$min
aux3<-aux3[order(aux3$dif, decreasing=T),]
aux3

# Combustible total de la flota por semana

library(lubridate)
aux<-fuel
aux$semana<-week(ymd(as.character(aux$fecha3)))

totalv<-aggregate(aux$valor, by=list(aux$vehiculo, aux$semana), min)
colnames(totalv)<-c("v","s","min")
aux2<-aggregate(aux$valor, by=list(aux$vehiculo, aux$semana), max)
colnames(aux2)<-c("v","s","max")
totalv<-merge(totalv, aux2, by=c("v","s"))
totalv$dif<-totalv$max-totalv$min

totalf<-aggregate(totalv$dif, by=list(totalv$s), sum)
colnames(totalf)<-c("Semana","Total_gasolina")
totalf

# Correlación de distancia y combustible
cor(plo$odomdif, plo$fueldif)




