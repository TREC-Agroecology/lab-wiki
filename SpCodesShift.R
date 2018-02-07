### This script revises species codes in TRECflora to USDA Plants codes

library(stringr)
library(dplyr)

data <- read.csv("TRECflora-main.csv")
USDA <- read.csv("USDAplantDatabaseSymbols.txt")

epithet_check <- function(epithet){
  check <- str_match(epithet, "[A-Z]*")
  if (check == ""){
    return(epithet)
  } else {
    return("sp.")
  }
}

USDA <- USDA %>%
  rowwise() %>%
  mutate(Species = str_split(Scientific.Name.with.Author, " ", simplify=TRUE)[,1],
         Epithet = epithet_check(str_split(Scientific.Name.with.Author, " ", simplify=TRUE)[,2]))

USDA_rev <- distinct(USDA, Species, Epithet, Symbol)

rev_data <- left_join(data, USDA_rev, by = c("Genus" = "Species", "Species" = "Epithet"))

write.csv(rev_data, "TRECflora-USDA.csv")
