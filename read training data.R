library(arrow)
df<-read_parquet("/Users/lucyford/Downloads/training_Original.parquet")
summary(df)

library(tidyverse)
df_acl<-df%>%
  filter(corpus=='ACL')

acl_emb<-read_parquet("/Users/lucyford/Downloads/acl_emb.parquet")
acl_plus_emb<-read_parquet("/Users/lucyford/Downloads/acl_plus_emb.parquet")

emb_only<-acl_plus_emb%>%
  select(embedding)
lengths(acl_plus_emb$embedding, use.names=TRUE)
?lengths

length(unique(acl_plus_emb$author))
unique(acl_plus_emb$author)

#author pairs:
acl_training<-read_parquet("/Users/lucyford/Downloads/acl_training.parquet")
head(acl_training$emb1)

#cosine sim:
acl_cossim<-read_parquet("/Users/lucyford/Downloads/acl_cossim.parquet")

#isolate Amazon Corpus:
df_amazon<-df%>%
  filter(corpus=="Amazon")

amazon_2authors<-read_parquet("/Users/lucyford/Downloads/Amazon_2authorsemb.parquet")

amazon_weights_emb_3<-read_parquet("/Users/lucyford/Downloads/amazon_emb_weight_A.parquet")

#all embeddings for all corpora:
all_embeddings<-read_parquet("/Users/lucyford/Downloads/all_embeddings.parquet")

reddit_weights<-read_parquet("/Users/lucyford/Downloads/reddit_weights.parquet")

#columns here are dimensions, rows are individual authors 
reddit_author_weights<-read_parquet("/Users/lucyford/Downloads/reddit_author_weights_scaled.parquet")

df_reddit<-all_embeddings%>%
  filter(corpus=="Reddit")
#isolate authors and reduce to unique values:
reddit_authors<-df_reddit%>%
  select(author)
reddit_unqiue_authors<-unique(reddit_authors)
#add authors column:
reddit_unqiue_authors$weights=reddit_author_weights
#now reddit_author_weights has author column at end 
#reddit_unique_authors has author at beginning
#save data:
write_parquet(reddit_unqiue_authors, "/Users/lucyford/Desktop/UOM CCL/Semester 1/STAR Research/reddit_unique_author_weights")

#find the highest value in each row of reddit weights:
#here every column is an author and every row is a dimension
transposed_reddit_author_weights<-t(reddit_author_weights)

#new df with magnitude of weights only:
reddit_abs_weights<-read_parquet("/Users/lucyford/Downloads/reddit_abs_weights_scaled.parquet")
#transpose:
transposed_reddit_abs_weights<-t(reddit_abs_weights)

#see python notebook - weights 105 and 921 are most frequent (4 counts each) 
#add 1 to index to account for python indexing from 0
#these extract columns - so 1 dimension across 400 authors
weight_105<-reddit_abs_weights[106]   
weight_921<-reddit_abs_weights[922]


#highest and lowest author pairs:
temp<-c('Independent', 'edog321', 'fryreportingforduty', 'Donald_Keyman')
reddit_high_low<-df_reddit%>%
  filter(author %in% temp)
#'Independent' - index 379 - highest 105 weight
#' 'edog321 - index 215 - highest 921 weight
#' 'fryreportingforduty' - index 276 - lowest 105 weight 
#' 'Donald_Keyman'- index 181 - lowest 921 weight
reddit_hl_texts<-reddit_high_low%>%
  select(author, text)

temp105<-c('Independent','fryreportingforduty')
reddit_105<-reddit_high_low%>%
  filter(author %in% temp105)

temp921<-c('edog321','Donald_Keyman')
reddit_921<-reddit_high_low%>%
  filter(author %in% temp921)

#save dataframes:
write_parquet(reddit_105, "/Users/lucyford/Desktop/UOM CCL/Semester 1/STAR Research/reddit_105.parquet")
write_parquet(reddit_921, "/Users/lucyford/Desktop/UOM CCL/Semester 1/STAR Research/reddit_921.parquet")

reddit_105_original<-read_parquet("/Users/lucyford/Downloads/reddit_105_original_weights.parquet")
reddit_921_original<-read_parquet("/Users/lucyford/Downloads/reddit_921_original_weights.parquet")

range(reddit_author_weights)
summary(reddit_author_weights)

weight_ranges<-reddit_author_weights%>%
  mutate(across(everything(), range))
where(max(reddit_abs_weights))

