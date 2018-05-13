# -*- coding: utf-8 -*-
"""
Created on Wed May 09 12:41:15 2018

@author: Adwaith
"""

# pip install spacy before running the following

import spacy
import pandas as pd
import easygui as eg
import string
import nltk
from nltk.corpus import stopwords
nltk.download('stopwords')
d = pd.read_csv("..\LAD_BTM_raw.csv")
d.columns = ['ID','Year','ID1','Work_vern','Work_en','Value']
#creating set of stop words to exclude
stop_words = set(stopwords.words('english'))
nlp = spacy.load('en')

def sentence_cleaner(word):
    # remove punctuations
    word = word.translate(string.maketrans("",""), string.punctuation)
    #lemmatize the sentence
    word = ' '.join([w.lemma_ for w in nlp(word.decode('utf-8'))])
    return word

d['Work_en_clean'] = d['Work_en'].apply(lambda x:sentence_cleaner(x))

d['all_obj'] = d['Work_en_clean'].apply(lambda x:list(set([str(i).strip() for i in nlp(x) if i.dep_ in ['dobj','pobj','nsubj']])))
d['all_obj'] = d['all_obj'].apply(lambda x: [i for i in x if i not in stop_words])
d['noun_obj'] = d['Work_en_clean'].apply(lambda x:[' '.join([str(k) for k in i]) for i in nlp(x).noun_chunks if i.root.dep_ in ['dobj','pobj','nsubj']])
d['noun_obj'] = d['noun_obj'].apply(lambda x:list(set([' '.join([k for k in i.split() if k not in stop_words]) for i in x])))
d.to_csv("..\LAD_BTM_Output_10May.csv",encoding = 'utf-8')

