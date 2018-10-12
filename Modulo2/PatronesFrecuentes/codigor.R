library("arules")
library("ggplot2")
#install.packages("magrittr")
library(magrittr)
setwd("C:/Users/marco/IPN_BigData/Modulo2/Practica_patrones_frecuentes")

#productos<-read.table("product",nrows = -1,sep="|",quote="\"",header=T)
#head(productos)
#productos<-productos[,c("product_class_id","product_id","product_name")]
#productos$product_name<-as.character(productos$product_name)

ventas01<-read.table("sales_01_Jan",nrows = -1,sep="|",quote="\"",header=T)
ventas02<-read.table("sales_02_Feb",nrows = -1,sep="|",quote="\"",header=T)
ventas03<-read.table("sales_03_Mar",nrows = -1,sep="|",quote="\"",header=T)
ventas04<-read.table("sales_04_Apr",nrows = -1,sep="|",quote="\"",header=T)
ventas05<-read.table("sales_05_May",nrows = -1,sep="|",quote="\"",header=T)
ventas06<-read.table("sales_06_Jun",nrows = -1,sep="|",quote="\"",header=T)
ventas07<-read.table("sales_07_Jul",nrows = -1,sep="|",quote="\"",header=T)
ventas08<-read.table("sales_08_Aug",nrows = -1,sep="|",quote="\"",header=T)
ventas09<-read.table("sales_09_Sep",nrows = -1,sep="|",quote="\"",header=T)
ventas10<-read.table("sales_10_Oct",nrows = -1,sep="|",quote="\"",header=T)
ventas11<-read.table("sales_11_Nov",nrows = -1,sep="|",quote="\"",header=T)
ventas12<-read.table("sales_12_Dec",nrows = -1,sep="|",quote="\"",header=T)
ventas<-rbind(ventas01,ventas02,ventas03,ventas04,ventas05,ventas06,ventas07,
              ventas08,ventas09,ventas10,ventas11,
              ventas12)
#ventas$product_id<-as.character(ventas$product_id)
#ventas<-merge(ventas,productos,by="product_id",all.x=T)

aux<-ventas[,c("time_id","customer_id","product_subcategory")]
aux$llave<-paste0(aux$time_id,"-",aux$customer_id)
aux$time_id<-NULL
aux$customer_id<-NULL
aux<-aux[!duplicated(aux),]
write.table(aux[,c(2,1)],"transacciones.csv",quote=F,row.names=F,sep=",")

transacciones<-read.transactions("transacciones.csv",format="single",sep=",",cols =
                                   c("llave","product_subcategory"))

itemsets <- apriori(data = transacciones,
                    parameter = list(support = 0.02,
                                     minlen = 2,
                                     maxlen = 20,
                                     target = "frequent itemset"))

order_itemsets <- sort(itemsets, by = "support", decreasing = TRUE)
inspect(order_itemsets)
as(order_itemsets, Class = "data.frame") %>%
  ggplot(aes(x = reorder(items, support), y = support)) +
  geom_col() +
  coord_flip() +
  labs(title = "Itemsets más frecuentes", x = "itemsets") +
  theme_bw()

rules <- apriori(data = transacciones,
                    parameter = list(support = 0.02,
                                     minlen = 2,
                                     maxlen = 20,
                                     confidence = .2,
                                     target = "rules"))

order_rules <- sort(rules, by = "support", decreasing = TRUE)
inspect(order_rules)
as(order_rules, Class = "data.frame") %>%
  ggplot(aes(x = reorder(rules, confidence), y = confidence)) +
  geom_col() +
  coord_flip() +
  labs(title = "Reglas derivadas", x = "reglas") +
  theme_bw()
