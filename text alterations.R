#remove "":
no_quote_reddit_921<-reddit_921%>%
  mutate(text=gsub('"', '', text))

write_parquet(no_quote_reddit_921, "/Users/lucyford/Desktop/UOM CCL/Semester 1/STAR Research/no_quote_reddit_921.parquet")
#all weights are absolute value
#read new weights from nq regression:
r921_nq_weights<-read_parquet("/Users/lucyford/Downloads/reddit_921_nq_weights.parquet")

weight_difference<-(reddit_921_original)-(r921_nq_weights)
max(abs(weight_difference))
max.col(abs(weight_difference))
