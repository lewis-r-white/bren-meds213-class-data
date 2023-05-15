library(EML)
library(emld)

# Starting our EML Record

# Describing the Coverage (Temporal and Geographic)

# Title

title <- "Plant-pollinator observations for: An experimental approach to assessing the 
  impact of ecosystem engineers on biodiversity and ecosystem functions"


geographicDescription <- "Loma del Mulhacen, Sierra Nevada, Andalucia, Spain"

coverage <- 
  set_coverage(begin = '2015-07-01', end = '2015-07-31',
               geographicDescription = geographicDescription,
               west = -3.30, east = -3.30, 
               north = 37.05, south = 37.05,
               altitudeMin = 600, altitudeMaximum = 3396,
               altitudeUnits = "meter")

methods_file <- "./methods.md"
methods <- set_methods(methods_file)

# Creating parties

# Persons and Organizations appear in multiple places in and EML document. R has a native object class R_person

#R_person <- person("Giabalberto", "Losapio"," ","losapiog@stanford.edu",c(ORCID = "0000-0001-7589-8706"))giadalberto <- as_emld(R_person)

# Another way of creating parties

losapio <- eml$creator(
  individualName = eml$individualName(
    givenName ="Gianalberto",
    surName = "Losapio"),
  electronicMailAddress = "losapiog@stanford.edu")


publisher <- "Stanford University"

contact <- 
  list(
    individualName = giadalberto$individualName,
    electronicMailAddress = giadalberto$electronicMailAddress,
    organizationName = "Stanford University")

# Time for some keywords! As we learned these are important for findability.
# We will create a keywordSet which is essentially a list of lists
# We may also refer to controlled vocabularies and specific thesaurus for terms such as LTER's (https://vocab.lternet.edu/)

keywordSet <- list(     
  list(
    keyword = list("plant-insect interaction",
                   "pollinators",
                   "herbivores",
                   "parasitoid")
  ))

# Publication Date

pubDate <- "2021"


# Abstract
# You may copy it or call the .md file

abstract_file <-  "./abstract.md"
abstract <- set_TextType(abstract_file)

# Licensing and Rights

intellectualRights <- "Creative Commons Zero (CC0) waiver"

# Attributes

attributes <-
  tibble::tribble(
    ~attributeName,          ~attributeDefinition,                                  ~formatString,   ~definition,                     
    "id",                    "insect id",                                           NA,              NA,
    "Order",                 "order of the species",                                NA,              NA,
    "Suborder",              "suborder of the species",                             NA,              NA,                    
    "Family",                "family one or more genra",                            NA,              NA,                 
    "Species",               "species name",                                        NA,              NA,               
    "Phylogenetic.taxon",    "evolutionary tree with evolutionary relationships",   NA,              NA,            
    "Guild",                 "resources exploitation group",                        NA,              NA,               
    "Plant.species",         "name of the plant species",                           NA,              NA,              
    "Dates",                 "date of collection",                                  "YYYYMMDD",      "ISO format",)             


attributeList <- set_attributes(attributes, col_classes = 
                                  c("character", "character", "character", "character", "character", "character", "character", "character", "Date"))

# Data file format

physical <- set_physical("insect-record.csv")


# Assembling the dataTable

dataTable <- list(
  entityName = "insect-record.csv",
  entityDescription = "Insect observations",
  physical = physical,
  attributeList = attributeList)

dataset <- list(
  title = title,
  creator = giadalberto,
  pubDate = pubDate,
  intellectualRights = intellectualRights,
  abstract = abstract,
  keywordSet = keywordSet,
  coverage = coverage,
  contact = contact,
  methods = methods,
  dataTable = dataTable)

eml <- list(
  packageId = uuid::UUIDgenerate(),
  system = "uuid", # type of identifier - Universally Unique Identifiers
  dataset = dataset)

write_eml(eml, "losapio.xml")
eml_validate("losapio.xml")


#Getting the JSON file for easier queries in R and linked data 

f <- "losapio.xml"
emld <- as_emld(f)
json <- as_json(emld)


json_losapio <- "losapio.json"
as_json(emld, json_losapio)

write(json_losapio)