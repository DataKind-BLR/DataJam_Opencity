# karnataka-assembly-constituency-no-172-b-t-m-layout-mla-local-area-development-funds-2013-2018
# topic modeling

library(tm)
library(RWeka)
library(ggplot2)

files <- list.files(path="../lad_csv_files", pattern="*.csv", full.names=T, recursive=FALSE)
for (x in files) {
  t <- read.csv(x, stringsAsFactors = F) # load file
  docs <- VCorpus(VectorSource(t$Work.Name.Rough.Translation..English.))
  
  #create the toSpace content transformer
  toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, " ", x))})
  
  #Transform to lower case (need to wrap in content_transformer)
  docs <- tm_map(docs,content_transformer(tolower))
  
  docs <- tm_map(docs, toSpace, "-")
  docs <- tm_map(docs, toSpace, ":")
  docs <- tm_map(docs, toSpace, " st ")
  docs <- tm_map(docs, toSpace, " rd ")
  docs <- tm_map(docs, toSpace, "th ")
  docs <- tm_map(docs, toSpace, " no. ")
  docs <- tm_map(docs, removePunctuation)
  
  #Strip digits (std transformation, so no need for content_transformer)
  docs <- tm_map(docs, removeNumbers)
  
  #remove stopwords using the standard list in tm
  # docs <- tm_map(docs, removeWords, stopwords('smart'))
  docs <- tm_map(docs, removeWords, stopwords("english"))
  
  #Strip whitespace (cosmetic?)
  docs <- tm_map(docs, stripWhitespace)
  
  BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
  tdm <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
  freq = sort(rowSums(as.matrix(tdm)),decreasing = TRUE)
  
  freq.df = data.frame(word=names(freq), freq=freq)
  head(freq.df, 20)
  
  ggplot(head(freq.df,25), aes(reorder(word,freq), freq)) +
    geom_bar(stat = "identity") + coord_flip() +
    xlab("Bigrams") + ylab("Frequency") +
    ggtitle("Most frequent bigrams")
  
  break
  
  #out_filename = paste('../res_files/', tools::file_path_sans_ext(basename(x)), '_out.csv', sep="")
  #write.csv(file=out_filename, x=data.frame(word=names(freq), freq=freq), row.names=FALSE)
  
  # apply function
  #out <- function(t)
    # write to file
   # write.table(out, "../res_files", sep="\t", quote=F, row.names=F, col.names=T)
}

