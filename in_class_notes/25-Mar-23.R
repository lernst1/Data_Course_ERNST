library(tidyverse)
library(easystats)
library(caret) # machine learning package

# make 2 vectors of random numbers drawn from normal/gaussian distribution
x <- rnorm(100,100) # 100 numbers, mean of 100
y <- rnorm(100,99.9) # 100 numbers, mean of 99.9
t.test(x,y) # do a t-test to see if means are statistically different
# plot distributions
data.frame(x,y) %>%
  pivot_longer(everything()) %>% 
  ggplot(aes(x=value,fill=name)) +
  geom_density(alpha=.5)

# run a linear regression (instead of a t-test)
data.frame(x,y) %>%
  pivot_longer(everything()) %>% 
  glm(data=.,
      formula = value ~ name) %>% 
  summary()

library(palmerpenguins)
library(MASS) #
dplyr::select() # if a function is masked by another program, this lets you override it - the selct in tidyverse is used, the one in mass is not

# make 3 models predicting body_mass_g
mod1 <- glm(data = penguins, formula = body_mass_g ~ species  + sex)

mod2 <- glm(data = penguins, formula = body_mass_g ~ species * sex)

mod3 <- glm(data = penguins, formula = body_mass_g ~ .)

mod4 <- 
  glm(data = penguins, body_mass_g ~ .^2)
mod4 %>% summary


# compare_performance() of the 3 models
compare_performance(mod1, mod2, mod3, mod4) %>% plot
mod4$formula

# what is the root mean square error?
# RS = 
# RMSE = How much the model is off
# sigma = 
# remaining 3 = 

step <- stepAIC(object = mod4)
step$formula
mod2$formula
species + sex + species:sex

mod5 <- glm(data = penguins, formula = step$formula)

compare_performance(mod1, mod2, mod3, mod4, mod5) %>% plot

# In data, you want to simplify then predict
# To predict, your model will need a data frame - this can be manually made
new_penguin <- data.frame(species="Adelie", 
                          island = "Torgersen",
                          bill_length_mm=40, 
                          bill_depth_mm=20,
                          flipper_length_mm=500, 
                          sex="female",
                          year=2007)

predict(object = mod5, newdata = new_penguin)

predict(mod5, penguins) # This is predicting based off the model that was used to make it - this would not be good for any research - it's circular

penguins$preds <- predict(mod5, penguins) #this model predicts itself
ggplot(penguins,aes(x=body_mass_g,y=preds)) + 
  geom_point() +
  geom_smooth(method ='lm')

# cross-validation
skimr::sim(penguins) # can tell you where NAs are 
dat <- penguins[complete.cases(penguins),]
train_rows <- caret::createDataPartition(y = dat$body_mass_g, p = .5)

train <- dat[train_rows$Resample1,]
test <- dat[-train_rows$Resample1,]

mod_xval <- glm(data = train,
                formula = step$formula)

# predict new data that hasn't been seen by the model before
xval_preds <- predict(mod_xval, newdata = test)

test %>%
  mutate(xval_preds=xval_preds) %>%
  ggplot(aes(x = body_mass_g, y = xval_preds)) +
  geom_point() + 
  geom_smooth(method = 'lm')

model_performance(mod_xval)
model_performance(mod5)
check_model(mod_xval)
report(mod_xval)
