rm(list = ls()) 
require(lme4)
require(texreg)
require(optimx)
require(ggplot2)
require(scales)
library(dplyr)
require(stargazer)
library(tidyr)
library(broom)
require(splines)
require(car)
require(plyr)
require(gam)

setwd("D:/abroad/Harvard/18spring courses/EDU S043/S043final")
dat <- read.csv("data/final43.csv")
ppp <- read.csv("data/PPPfinal.csv")
le <- read.csv("data/LEfinal.csv")
expsch <- read.csv("data/expschfinal.csv")

dat <- merge(dat, ppp, by = c("country", "year"), all.x = T)
dat <- merge(dat, le, by = c("country", "year"), all.x = T)
dat <- merge(dat, expsch, by = c("country", "year"), all.x = T)

list <- which(rowSums(is.na(dat)) > 0)
dat_NA <- dat[list,]

dat <- na.omit(dat)

happymean <- mean(dat$happy)
happysd <- sd(dat$happy)
agemean <- mean(dat$age)
agesd <- sd(dat$age)
religousmean <- mean(dat$religious)
religoussd <- sd(dat$religious)

dat$happy <- scale(dat$happy)
dat$religious <- scale(dat$religious)
dat$age <- scale(dat$age)
dat$child <- scale(dat$child)
dat$income <- scale(dat$income)
dat$ppp <- scale(dat$ppp)
dat$le <- scale(dat$le)
dat$expsch <- scale(dat$expsch)

dat_NA$happy <- scale(dat_NA$happy)
dat_NA$religious <- scale(dat_NA$religious)
dat_NA$age <- scale(dat_NA$age)
dat_NA$child <- scale(dat_NA$child)
dat_NA$income <- scale(dat_NA$income)
dat_NA$ppp <- scale(dat_NA$ppp)
dat_NA$le <- scale(dat_NA$le)
dat_NA$expsch <- scale(dat_NA$expsch)

dat$happy <- as.numeric(dat$happy)
dat$income <- as.numeric(dat$income)
dat$age <- as.numeric(dat$age)
dat$child <- as.numeric(dat$child)
dat$religious <- as.numeric(dat$religious)
dat$ppp <- as.numeric(dat$ppp)
dat$le <- as.numeric(dat$le)
dat$expsch <- as.numeric(dat$expsch)

dat$year <- as.factor(dat$year)

incomequant <- quantile(dat$income, c(0, 1/4, 3/4, 1))
incomequant[1] <- incomequant[1] - 100
incomequant[4] <- incomequant[4] + 100
dat$incomecat <- cut(dat$income, breaks = incomequant, labels = c("ilow","imiddle","ihigh"))
dat$incomecat <- C(dat$incomecat, contr.treatment, base = 2)  
dat$irich[dat$incomecat=='ihigh'] <- 1
dat$irich[dat$incomecat!='ihigh'] <- 0
dat$ipoor[dat$incomecat=='ilow'] <- 1
dat$ipoor[dat$incomecat!='ilow'] <- 0

pppquant <- quantile(dat$ppp, c(0, 1/4, 3/4, 1))
pppquant[1] <- pppquant[1] - 100
pppquant[4] <- pppquant[4] + 100
dat$pppcat <- cut(dat$ppp, breaks = pppquant, labels = c("plow","pmiddle","phigh"))
dat$pppcat <- C(dat$pppcat, contr.treatment, base = 2) 
dat$prich[dat$pppcat=='phigh'] <- 1
dat$prich[dat$pppcat!='phigh'] <- 0
dat$ppoor[dat$pppcat=='plow'] <- 1
dat$ppoor[dat$pppcat!='plow'] <- 0

dat6 <- subset(dat, wave == "6")
dat5 <- subset(dat, wave == "5")
dat4 <- subset(dat, wave == "4")
dat3 <- subset(dat, wave == "3")
dat2 <- subset(dat, wave == "2") 
dat <- dat[-which(dat$wave=="2"),] #wave 2 only has five countries, so I didn't include this wave

dat$wave <- as.factor(dat$wave)

save(dat, file = "data/dat.Rdata")
save(dat6, file = "data/dat6.Rdata")
save(dat5, file = "data/dat5.Rdata")
save(dat4, file = "data/dat4.Rdata")
save(dat3, file = "data/dat3.Rdata")

####descriptive statistics####
stargazer(dat, type = "html", 
          digits = 2,
          title = "Descriptive statistics for all waves",
          out = "output/descriptive statistics for all waves.doc")

stargazer(dat3, type = "html", 
          digits = 2,
          title = "Descriptive statistics for wave3",
          out = "output/descriptive statistics for wave3.doc")
stargazer(dat4, type = "html", 
          digits = 2,
          title = "Descriptive statistics for wave 4",
          out = "output/descriptive statistics for wave4.doc")
stargazer(dat5, type = "html", 
          digits = 2,
          title = "Descriptive statistics for wave 5",
          out = "output/descriptive statistics for wave5.doc")
stargazer(dat6, type = "html", 
          digits = 2,
          title = "Descriptive statistics for wave 6",
          out = "output/descriptive statistics for wave6.doc")

cwdat <- dat %>% group_by(country, wave) %>% 
  summarise(happy = mean(happy))
cdat <- cwdat %>% group_by(country) %>%
  summarise(., happy = mean(happy))

png('output/country wave.png')
ggplot(data = cwdat, mapping = aes(x = wave, y = happy, group = wave)) + 
  geom_boxplot() +
  labs(title = 'Country-level happiness by wave')
dev.off()  
png('output/country happy.png')
ggplot(cdat) +
  labs(title = 'Country-level average happiness') +
  geom_point(aes(x = reorder(country, -happy), y = happy)) +
  theme(axis.text.y = element_text(size = 5), axis.title = element_blank()) +
  coord_flip() 
dev.off() 

####Model 1####
#non-linear, bs(), not multilevel, plot to see which one is non-linear####
model2_w3 <- gam(happy ~ female + married + high + employed + 
                   s(income) + s(age) + s(child) + s(religious), 
                 data = dat3)
model2_w4 <- gam(happy ~ female + married + high + employed + 
                   s(income) + s(age) + s(child) + s(religious), 
                 data = dat4)
model2_w5 <- gam(happy ~ female + married + high + employed + 
                   s(income) + s(age) + s(child) + s(religious), 
                 data = dat5)
model2_w6 <- gam(happy ~ female + married + high + employed + 
                   s(income) + s(age) + s(child) + s(religious), 
                 data = dat6)

par(mfrow=c(1,4), cex = 0.5)
plot(model2_w3)
plot(model2_w4)
plot(model2_w5)
plot(model2_w6)

####Model 2####
#non-linear, I(X^2), multilevel
m4_2_w3 <- lmer(happy ~ female + married + high + employed + income + age + I(age^2) + child + I(child^2) + religious + I(religious^2) +
                  ppp + le + expsch + 
                  (female + married + high + employed + income + age + child + religious|country),
                control = lmerControl(optCtrl = list(maxfun = 100000)),
                data = dat3)
save(m4_2_w3, file = "data/m4_2_w3")
m4_2_w4 <- lmer(happy ~ female + married + high + employed + income + age + I(age^2) + child + I(child^2) + religious + I(religious^2) +
                  ppp + le + expsch + 
                  (female + married + high + employed + income + age + child + religious|country),
                control = lmerControl(optCtrl = list(maxfun = 100000)),
                data = dat4)
save(m4_2_w4, file = "data/m4_2_w4")
m4_2_w5 <- lmer(happy ~ female + married + high + employed + income + age + I(age^2) + child + I(child^2) + religious + I(religious^2) +
                    ppp + le + expsch + 
                    (female + married + high + employed + income + age + child + religious|country),
                  control = lmerControl(optCtrl = list(maxfun = 500000)),
                  data = dat5) 
save(m4_2_w5, file = "data/m4_2_w5")
m4_2_w6 <- lmer(happy ~ female + married + high + employed + income + age + I(age^2) + child + I(child^2) + religious + I(religious^2) +
                  ppp + le + expsch + 
                  (female + married + high + employed + income + age + child + religious|country),
                control = lmerControl(optCtrl = list(maxfun = 100000)),
                data = dat6)
save(m4_2_w6, file = "data/m4_2_w6")
htmlreg(list(m4_2_w3, m4_2_w4, m4_2_w5, m4_2_w6), file = "output/squared_mulit.doc")

####Model 3####
#interaction rich-poor
m5_w3 <- lmer(happy ~ female + married + high + employed + relevel(interaction(incomecat, pppcat), ref = 7) +
                bs(age) + bs(child) + bs(religious) +
                ppp + le + expsch + 
                (female + married + high + employed + incomecat + age + child + religious|country),
              control = lmerControl(optCtrl = list(maxfun = 100000)),
              data = dat3)
save(m5_w3, file = "data/m5_w3")
m5_w4 <- lmer(happy ~ female + married + high + employed + relevel(interaction(incomecat, pppcat), ref = 7) +
                bs(age) + bs(child) + bs(religious) +
                ppp + le + expsch + 
                (female + married + high + employed + incomecat + age + child + religious|country),
              control = lmerControl(optCtrl = list(maxfun = 100000)),
              data = dat4)
save(m5_w4, file = "data/m5_w4")
m5_w5 <- lmer(happy ~ female + married + high + employed + relevel(interaction(incomecat, pppcat), ref = 7) +
                bs(age) + bs(child) + bs(religious) +
                ppp + le + expsch +
                (female + married + high + employed + incomecat + age + child + religious|country),
              control = lmerControl(optCtrl = list(maxfun = 100000)),
              data = dat5)
save(m5_w5, file = "data/m5_w5")
m5_w6 <- lmer(happy ~ female + married + high + employed + relevel(interaction(incomecat, pppcat), ref = 7) +
                bs(age) + bs(child) + bs(religious) +
                ppp + le + expsch +
                (female + married + high + employed + incomecat + age + child + religious|country),
              control = lmerControl(optCtrl = list(maxfun = 100000)),
              data = dat6)
save(m5_w6, file = "data/m5_w6")
htmlreg(list(m5_w3, m5_w4, m5_w5, m5_w6), file = "output/poorrich.doc")

