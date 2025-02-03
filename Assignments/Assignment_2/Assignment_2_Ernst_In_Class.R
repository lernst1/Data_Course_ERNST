getwd()
list.files()
?list.files()

list.files(path = "Data", pattern = ".csv", all.files = TRUE, 
           full.names = TRUE, recursive = TRUE, ignore.case = TRUE)

csv_files <- list.files(path = "Data", pattern = ".csv", all.files = TRUE, 
                 full.names = TRUE, recursive = TRUE, ignore.case = TRUE)
class(csv_files)

csv_files[1:10]
csv_files[c(1,3,5)]
c(1,3,5)
c(1:50,53,55,57)

head(csv_files, 10)

bird <-  list.files(path = "DATA", recursive = TRUE, 
                    pattern = "cleaned_bird_data.csv", 
                    full.names = TRUE)
file.copy(bird,".") 
bird

dat <- read.csv(bird)
class(dat)
dim(dat)

dat[c(1,3,5), ]
dat$Egg_mass
keepers <- dat$Egg_mass > 10

dat[keepers,]
big_egg_mamas <- dat[keepers,]
is.na(dat$Egg_mass)

# subset where Egg_mass is > 10 and is not NA
big_egg_mamas <- 
  dat[dat$Egg_mass > 10 & !is.na(dat$Egg_mass),]
plot(big_egg_mamas$Egg_mass)
plot(density(big_egg_mamas$Egg_mass))

summary(big_egg_mamas$Egg_mass)

summary(dat$mass)
summary(dat$tarsus)

big_mass_buddies <- 
dat$mass > median(dat$mass,na.rm = TRUE) &
dat$tarsus> median(dat$tarsus,na.rm = TRUE)

plot(dat[big_mass_buddies, "Egg_mass"])
file.remove("./cleaned_bird_data.csv")
