# [file name]: CFA.R
# [file content begin]
# 
#   Copyright (C) 2025 SXMU
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

library(lavaan)
library(readxl)
library(boot)
library(openxlsx)

# Input data
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
dat <- read_excel("data_demo.xlsx", sheet = 1)


#1. Physiological domain(PHD)
md1 <- dat[,2:20]
# Defining the CFA model
model <- '
  SPE  =~ proa1 + proa2 + proa3+proa4 + proa5 + proa6+proa7 + proa8+ proa9+proa10 + proa11 
  GEN =~ proa12 + proa13+proa14 + proa15 + proa16
  IND =~ proa17 + proa18 + proa19
  '

# Function for performing CFA and calculating fit indices
fit_function <- function(data, indices) {
  d <- data[indices, ]
  fit <- cfa(model, data = d)
  return(fitMeasures(fit, c("rmr", "rmsea", "nnfi", "cfi", "gfi")))
}
set.seed(123)  # Set random seed
results <- boot(data = md1, parallel = "multicore", statistic = fit_function, R = 500)

# View the fit indices
fit_indices_df <- as.data.frame(results$t)

# Add column names
colnames(fit_indices_df) <- c("RMR", "RMSEA", "NNFI", "CFI", "GFI")

# Output
write.xlsx(fit_indices_df, file = "PHD_CFA.xlsx")


#2. Psychological domain (PSD)
md2<- dat[,21:33]

# Defining the CFA model
mode2_mod <- '
ANX =~ prob1 + prob2 + prob3 + prob4 + prob5 + prob6 + prob7 
DEP =~ prob8 + prob9 + prob10 + prob11 + prob12 + prob13 
'

# Function for performing CFA and calculating fit indices
fit2_function <- function(data, indices) {
  d2 <- data[indices, ]
  fit2 <- cfa(mode2_mod, data = d2)
  return(fitMeasures(fit2, c("rmr", "rmsea", "nnfi", "cfi", "gfi")))
}
set.seed(123)  # Set random seed
results2 <- boot(data = md2, parallel = "multicore", statistic = fit2_function, R = 500)

# View the fit indices
fit_indices_df2 <- as.data.frame(results2$t)

# Add column names
colnames(fit_indices_df2) <- c("RMR", "RMSEA", "NNFI", "CFI", "GFI")

# Output
write.xlsx(fit_indices_df2, file = "PSD_CFA.xlsx")


#3. Social domain (SOD)
md3 <- dat[,34:44]

# Defining the CFA model
mode3 <- ' COG =~ proc1 + proc2 + proc3
INF =~ proc4 + proc5+proc6 + proc7 + proc8
SUP =~ proc9 + proc10 + proc11
'

# Function for performing CFA and calculating fit indices
fit3_function <- function(data, indices) {
  d3 <- data[indices, ]
  fit3 <- cfa(mode3, data = d3)
  return(fitMeasures(fit3, c("rmr", "rmsea", "nnfi", "cfi", "gfi")))
}
set.seed(123)  # Set random seed
results3 <- boot(data = md3, parallel = "multicore", statistic = fit3_function, R = 500)

# View the fit indices
fit_indices_df3 <- as.data.frame(results3$t)

# Add column names
colnames(fit_indices_df3) <- c("RMR", "RMSEA", "NNFI", "CFI", "GFI")

# Output
write.xlsx(fit_indices_df3, file = "SOD_CFA.xlsx")


#4. Therapeutic domain (THD)
md4 <- dat[,45:53]
# Defining the CFA model
model4_modified <- '
COM =~ prod1 + prod2
DRU =~ prod3 + prod4 
SAT =~ prod5 + prod6 + prod7 + prod8 + prod9
'
# Function for performing CFA and calculating fit indices
fit4_function <- function(data, indices) {
  d4 <- data[indices, ]
  fit4 <- cfa(model4_modified, data = d4)
  return(fitMeasures(fit4, c("rmr", "rmsea", "nnfi", "cfi", "gfi")))
}
set.seed(123)  # Set random seed
results4 <- boot(data = md4, parallel = "multicore", statistic = fit4_function, R = 500)

# View the fit indices
fit_indices_df4 <- as.data.frame(results4$t)

# Add column names
colnames(fit_indices_df4) <- c("RMR", "RMSEA", "NNFI", "CFI", "GFI")

# Output
write.xlsx(fit_indices_df4, "THD_CFA.xlsx")


#5. Total Score
 md0 <- dat[,2:53]
 
# Defining the CFA model
 mode0 <- ' SPE  =~ proa1 + proa2 + proa3+proa4 + proa5 + proa6+proa7 + proa8+ proa9+proa10 + proa11 
  GEN =~ proa12 + proa13+proa14 + proa15 + proa16
  IND =~ proa17 + proa18+ proa19 
  ANX =~ prob1 + prob2 + prob3+prob4 + prob5 + prob6+prob7 
  DEP =~ prob8 + prob9+prob10 + prob11 + prob12+ prob13
  COG =~ proc1 + proc2 + proc3
  INF =~ proc4 + proc5+proc6 + proc7 + proc8
  SUP =~ proc9 + proc10 + proc11
  COM =~ prod1 + prod2
  DRU =~ prod3 + prod4 
  SAT =~ prod5 + prod6 + prod7+ prod8 + prod9
  '
 # Function for performing CFA and calculating fit indices
 fit0_function <- function(data, indices) {
   d0 <- data[indices, ]
   fit0 <- cfa(mode0 , data = d0)
  # Check if the model has converged
  if (fit0@optim$converged) {
          # If converged, return the fit indices
           return(fitMeasures(fit0, c("rmr", "rmsea", "nnfi", "cfi", "gfi")))  
         } else {
            # If not, return NA
         }
   }

set.seed(123)  # Set random seed
results0 <- boot(data = md0, parallel = "multicore", statistic = fit0_function, R = 700)

# View the fit indices
fit_indices_df0 <- as.data.frame(results0$t)

# Add column names
colnames(fit_indices_df0) <- c("RMR", "RMSEA", "NNFI", "CFI", "GFI")

# Output
write.xlsx(fit_indices_df0, "Total_CFA.xlsx")

# [file content end]