# karnataka-assembly-constituency-no-172-b-t-m-layout-mla-local-area-development-funds-2013-2018
# topic modeling
setwd("C:/Users/apeksha.p/Documents/Datakind/")

library(tm)

btm <- read.csv("btm_layout.csv", stringsAsFactors = F)
docs <- VCorpus(VectorSource(btm$Work.Name.Rough.Translation..English.))

#create the toSpace content transformer
toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, " ", x))})

docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, toSpace, ":")
docs <- tm_map(docs, removePunctuation)

#Transform to lower case (need to wrap in content_transformer)
docs <- tm_map(docs,content_transformer(tolower))

#Strip digits (std transformation, so no need for content_transformer)
docs <- tm_map(docs, removeNumbers)

#remove stopwords using the standard list in tm
docs <- tm_map(docs, removeWords, stopwords('smart'))

#Strip whitespace (cosmetic?)
docs <- tm_map(docs, stripWhitespace)



#n-gram analysis
library(RWeka)

BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
tdm <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
# tdm <- removeSparseTerms(tdm, 0.75)
# tdm <- as.matrix(tdm)
print(tdm$dimnames$Terms)

freq = sort(rowSums(as.matrix(tdm)),decreasing = TRUE)
freq.df.1 = data.frame(word=names(freq), freq=freq)
head(freq.df, 20)


library(wordnet)
?getDict
