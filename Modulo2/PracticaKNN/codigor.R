setwd("C:/Users/marco/IPN_BigData/Modulo2/Práctica_KNN")

train<-read.csv("Ejercicio Knn.csv", skip=1, nrows= 12)
eval<-read.csv("Ejercicio Knn.csv", skip=16, nrows=4, header=F)
colnames(eval)<-colnames(train)

train$Invertir<-ifelse(as.character(train$Invertir)=="Si",1,0)
eval$Invertir<-ifelse(as.character(eval$Invertir)=="Si",1,0)

dats<-rbind(train,eval)

Normalizar<- function (x){
  if (all(is.na(x))){
    return(rep(NA, length(x)))
  } else if (sum(x)==0){
    return(rep(0,length(x)))
  } else if (min(x)==max(x) & max(x)!=0){
    return(rep(1,length(x)))
  } else
  return((x-min(x))/(max(x)-min(x)))
} 

aux<-sapply(dats[,1:(ncol(dats)-1)], Normalizar)
train2<-as.data.frame(cbind(aux[1:nrow(train),], train[,ncol(train)]))
colnames(train2)[ncol(train2)]<-"Invertir"
eval2<-as.data.frame(cbind(aux[(nrow(train)+1):nrow(aux),], eval[,ncol(eval)]))
colnames(eval2)[ncol(eval2)]<-"Invertir"

aux<-data.frame()
for(i in 1:nrow(eval2)){
  for(j in 1:nrow(train2)){
    aux[j,i]<-dist(rbind(train2[j,-ncol(train2)], eval2[i,-ncol(eval2)]), method="euclidean")    
  }
}
euclidian<-aux

aux<-data.frame()
for(i in 1:nrow(eval2)){
  for(j in 1:nrow(train2)){
    aux[j,i]<-dist(rbind(train2[j,-ncol(train2)], eval2[i,-ncol(eval2)]), method="maximum") 
  }
}
max<-aux

kesimo<-function(v,k){
  mean(train2$Invertir[which(v %in% sort(v)[1:k])])
}


matriz_inversion_e<-data.frame()
for(v in 1:nrow(eval2)){
  for(k in 1:3){
    matriz_inversion_e[v,k]<-kesimo(euclidian[,v],k*2-1)
  }
}
colnames(matriz_inversion_e)<-c("k=1","k=3","k=5")

matriz_inversion_max<-data.frame()
for(v in 1:nrow(eval2)){
  for(k in 1:3){
    matriz_inversion_max[v,k]<-kesimo(max[,v],k*2-1)
  }
}
colnames(matriz_inversion_max)<-c("k=1","k=3","k=5")







