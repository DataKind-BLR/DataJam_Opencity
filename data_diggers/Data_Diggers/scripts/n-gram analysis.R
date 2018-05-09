# karnataka-assembly-constituency-no-172-b-t-m-layout-mla-local-area-development-funds-2013-2018
# topic modeling
# setwd("C:/Users/apeksha.p/Documents/Datakind/")

library(tm)

btm <- read.csv("../csv_files/btm_layout.csv", stringsAsFactors = F)
docs <- VCorpus(VectorSource(btm$Work.Name.Rough.Translation..English.))

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



#n-gram analysis
library(RWeka)

BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
tdm <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
# tdm <- removeSparseTerms(tdm, 0.75)
# tdm <- as.matrix(tdm)
print(tdm$dimnames$Terms)

freq = sort(rowSums(as.matrix(tdm)),decreasing = TRUE)
# freq.df.1 = data.frame(word=names(freq), freq=freq)
# head(freq.df.1, 20)

write.csv(file='../csv_files/btm_test3.csv', x=data.frame(word=names(freq), freq=freq), row.names=FALSE)

# library(wordnet)
# ?getDict

