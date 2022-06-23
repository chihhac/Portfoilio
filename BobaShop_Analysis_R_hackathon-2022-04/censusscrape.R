# call relevant libraries
library(tidyverse)
library(tidycensus)
library(zipcodeR)

#establish zip codes for LA County and OC
LAZips <- search_county("Los Angeles", "CA")
LAZips <- LAZips$zipcode

OCZips <- search_county("Orange", "CA")
OCZips <- OCZips$zipcode

# get the median household income for every census Zip in LA County
CAmedianIncomeByZip <- get_acs(
  geography = "zcta",
  variables = c(medianIncome = "B19013_001"),
  table = NULL,
  cache_table = FALSE,
  year = 2019,
  endyear = NULL,
  output = "tidy",
  state = "CA",
  zcta = NULL,
  geometry = FALSE,
  keep_geo_vars = FALSE,
  shift_geo = FALSE,
  summary_var = NULL,
  key = NULL,
  moe_level = 90,
  survey = "acs5",
  show_call = FALSE,
)

# get the median rate of household income going toward rent for every census Zip in LA County
CAmedianRentShareOfIncomeByZip <- get_acs(
  geography = "zcta",
  variables = c(rentShare = "B25071_001"),
  table = NULL,
  cache_table = FALSE,
  year = 2019,
  endyear = NULL,
  output = "tidy",
  state = "CA",
  zcta = NULL,
  geometry = FALSE,
  keep_geo_vars = FALSE,
  shift_geo = FALSE,
  summary_var = NULL,
  key = NULL,
  moe_level = 90,
  show_call = FALSE,
)

# get the median age for every census Zip in LA County
CAmedianAgeByZip <- get_acs(
  geography = "zcta",
  variables = c(overall = "B01002_001", male = "B01002_002", female = "B01002_003"),
  table = NULL,
  cache_table = FALSE,
  year = 2019,
  endyear = NULL,
  output = "tidy",
  state = "CA",
  zcta = NULL,
  geometry = FALSE,
  keep_geo_vars = FALSE,
  shift_geo = FALSE,
  summary_var = NULL,
  key = NULL,
  moe_level = 90,
  show_call = FALSE,
)

# get the population totals by gender for every census Zip in LA County
CAsexByZip <- get_acs(
  geography = "zcta",
  variables = c(overall = "B01001_001", male = "B01001_002",female = "B01001_026"),
  table = NULL,
  cache_table = FALSE,
  year = 2019,
  endyear = NULL,
  output = "tidy",
  state = "CA",
  zcta = NULL,
  geometry = FALSE,
  keep_geo_vars = FALSE,
  shift_geo = FALSE,
  summary_var = NULL,
  key = NULL,
  moe_level = 90,
  show_call = FALSE,
)

# get the number of people who've never been married for every census Zip in LA County
CAneverMarriedRateByZip <- get_acs(
  geography = "zcta",
  variables = c(male = "B12001_002", female = "B12001_012"),
  table = NULL,
  cache_table = FALSE,
  year = 2019,
  endyear = NULL,
  output = "tidy",
  state = "CA",
  zcta = NULL,
  geometry = FALSE,
  keep_geo_vars = FALSE,
  shift_geo = FALSE,
  summary_var = NULL,
  key = NULL,
  moe_level = 90,
  show_call = FALSE,
)

# get the number of people with at least a bachelor's degree for every census Zip in LA County
CAeduRateByZip <- get_acs(
  geography = "zcta",
  variables = c(maleBS = "B15002_015", 
                maleMS = "B15002_016", 
                maleMBA = "B15002_017",
                malePHD = "B15002_018",
                femaleBS = "B15002_032", 
                femaleMS = "B15002_033", 
                femaleMBA = "B15002_034",
                femalePHD = "B15002_035"),
  table = NULL,
  cache_table = FALSE,
  year = 2019,
  endyear = NULL,
  output = "tidy",
  state = "CA",
  zcta = NULL,
  geometry = FALSE,
  keep_geo_vars = FALSE,
  shift_geo = FALSE,
  summary_var = NULL,
  key = NULL,
  moe_level = 90,
  show_call = FALSE,
)

# create a table with the total survey population for every census Zip in LA County
CAtotalByZip <- CAsexByZip %>%
  filter(variable == "overall") %>%
  group_by(GEOID) %>%
  summarize(surveyPopulation = sum(estimate))

#aggregators
LAmedianIncomeByZip <- CAmedianIncomeByZip %>%
       filter(GEOID %in% LAZips) %>%
       select(GEOID, estimate)

OCmedianIncomeByZip <- CAmedianIncomeByZip %>%
  filter(GEOID %in% OCZips) %>%
  select(GEOID, estimate)

LAmedianRentShareOfIncomeByZip <- CAmedianRentShareOfIncomeByZip %>%
  filter(GEOID %in% LAZips) %>%
  select(GEOID, estimate)

OCmedianRentShareOfIncomeByZip <- CAmedianRentShareOfIncomeByZip %>%
  filter(GEOID %in% OCZips) %>%
  select(GEOID, estimate)

LAmedianAgeByZip <- CAmedianAgeByZip %>%
  filter(variable == "overall" & GEOID %in% LAZips) %>%
  select(GEOID, estimate)

OCmedianAgeByZip <- CAmedianAgeByZip %>%
  filter(variable == "overall" & GEOID %in% OCZips) %>%
  select(GEOID, estimate)

LATotalPopByZip <- CAsexByZip %>%
  filter(variable == "overall" & GEOID %in% LAZips) %>%
  select(GEOID, estimate)

LATotalMaleByZip <- CAsexByZip %>%
  filter(variable == "male" & GEOID %in% LAZips) %>%
  select(GEOID, estimate)

LATotalFemaleByZip <- CAsexByZip %>%
  filter(variable == "female" & GEOID %in% LAZips) %>%
  select(GEOID, estimate)

LATotalPopByZip <- cbind(LATotalPopByZip,
                         males = LATotalMaleByZip$estimate,
                         females = LATotalFemaleByZip$estimate)

LASexRateByZip <- LATotalPopByZip %>%
  group_by(GEOID) %>%
  summarize(males = round(males/estimate*100, 1),
            females = round(females/estimate*100, 1)
            )

OCTotalPopByZip <- CAsexByZip %>%
  filter(variable == "overall" & GEOID %in% OCZips) %>%
  select(GEOID, estimate)

OCTotalMaleByZip <- CAsexByZip %>%
  filter(variable == "male" & GEOID %in% OCZips) %>%
  select(GEOID, estimate)

OCTotalFemaleByZip <- CAsexByZip %>%
  filter(variable == "female" & GEOID %in% OCZips) %>%
  select(GEOID, estimate)

OCTotalPopByZip <- cbind(OCTotalPopByZip,
                         males = OCTotalMaleByZip$estimate,
                         females = OCTotalFemaleByZip$estimate)

OCSexRateByZip <- OCTotalPopByZip %>%
  group_by(GEOID) %>%
  summarize(males = round(males/estimate*100, 1),
            females = round(females/estimate*100, 1)
  )

LAneverMarriedRateByZip <- CAneverMarriedRateByZip %>%
  filter(GEOID %in% LAZips) %>%
  group_by(GEOID) %>%
  summarize(neverMarriedTotal = sum(estimate))

LAneverMarriedRateByZip <- cbind(LAneverMarriedRateByZip, totalPop = LATotalPopByZip$estimate)

LAneverMarriedRateByZip <- LAneverMarriedRateByZip %>%
  mutate(neverMarried = round(neverMarriedTotal/totalPop*100,1)) %>%
  select(GEOID, neverMarried)

OCneverMarriedRateByZip <- CAneverMarriedRateByZip %>%
  filter(GEOID %in% OCZips) %>%
  group_by(GEOID) %>%
  summarize(neverMarriedTotal = sum(estimate))

OCneverMarriedRateByZip <- cbind(OCneverMarriedRateByZip, totalPop = OCTotalPopByZip$estimate)

OCneverMarriedRateByZip <- OCneverMarriedRateByZip %>%
  mutate(neverMarried = round(neverMarriedTotal/totalPop*100,1)) %>%
  select(GEOID, neverMarried)
  

LAeduRateByZip <- CAeduRateByZip %>%
  filter(GEOID %in% LAZips) %>%
  group_by(GEOID) %>%
  summarize(atLeastBachelorsTotal = sum(estimate))

LAeduRateByZip <- cbind(LAeduRateByZip, totalPop = LATotalPopByZip$estimate)

LAeduRateByZip <- LAeduRateByZip %>%
  mutate(hasBS = round(atLeastBachelorsTotal/totalPop*100, 1)) %>%
  select(GEOID, hasBS)

OCeduRateByZip <- CAeduRateByZip %>%
  filter(GEOID %in% OCZips) %>%
  group_by(GEOID) %>%
  summarize(atLeastBachelorsTotal = sum(estimate))

OCeduRateByZip <- cbind(OCeduRateByZip, totalPop = OCTotalPopByZip$estimate)

OCeduRateByZip <- OCeduRateByZip %>%
  mutate(hasBS = round(atLeastBachelorsTotal/totalPop*100, 1)) %>%
  select(GEOID, hasBS)

OCDemos <- cbind(zcta = OCTotalPopByZip$GEOID,
                 sampleSize = OCTotalPopByZip$estimate,
                 rateMale = OCSexRateByZip$males,
                 rateFemale = OCSexRateByZip$females,
                 medianAge = OCmedianAgeByZip$estimate,
                 medianIncome = OCmedianIncomeByZip$estimate,
                 rentShareOfIncome = OCmedianRentShareOfIncomeByZip$estimate,
                 degreeRate = OCeduRateByZip$hasBS,
                 rateNeverMarried = OCneverMarriedRateByZip$neverMarried
                 )
                 
LADemos <- cbind(zcta = LATotalPopByZip$GEOID,
            sampleSize = LATotalPopByZip$estimate,
            rateMale = LASexRateByZip$males,
            rateFemale = LASexRateByZip$females,
            medianAge = LAmedianAgeByZip$estimate,
            medianIncome = LAmedianIncomeByZip$estimate,
            rentShareOfIncome = LAmedianRentShareOfIncomeByZip$estimate,
            degreeRate = LAeduRateByZip$hasBS,
            rateNeverMarried = LAneverMarriedRateByZip$neverMarried
            )

OCDemos <- as.data.frame(OCDemos)
LADemos <- as.data.frame(LADemos)

write_csv(LADemos, "LADemos.csv")
write_csv(OCDemos, "OCDemos.csv")