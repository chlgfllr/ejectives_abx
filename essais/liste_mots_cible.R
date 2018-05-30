mes_mots_cible <- readr::read_delim("/Users/chloe/geo/acoustic_measures.txt", "\t")
mes_mots_cible_comptes <- group_by(mes_mots_cible, word) 
mes_mots_cible_comptes <- summarise(mes_mots_cible_comptes, word_n = n())

write.csv(mes_mots_cible_comptes, "/Users/chloe/OneDrive/Documents/M2/2017-2018/georgian_suite/compte_mots_2_3_syllabes.csv")

dplyr::summarize(mes_mots_cible, word, n())

ddply(mes_mots_cible,~word,summarise)
