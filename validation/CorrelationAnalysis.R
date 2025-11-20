# [file name]: CorrelationAnalysis.R
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


library(readxl)
library(dplyr)
library(openxlsx)

# Input data
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
data1 <- read_excel("./data_Corr_demo/SGRQ_demo.xlsx")
data2 <- read_excel("./data_Corr_demo/PRO_demo.xlsx")
all_colnames <- c(colnames(data1)[-1], colnames(data2)[-1])


# Confirmation of numerical variables
vars1 <- data1 %>%
  select(-1) %>%  
  mutate(across(everything(), as.numeric))

# Confirmation of numerical variables
vars2 <- data2 %>%
  select(-1) %>%  
  mutate(across(everything(), as.numeric))

# Calculating the correlation coefficient matrix and p-value matrix.
n1 <- ncol(vars1)
n2 <- ncol(vars2)
cor_matrix <- matrix(NA, nrow = n1 + n2, ncol = n1 + n2,
                     dimnames = list(all_colnames, all_colnames))
p_matrix <- matrix(NA, nrow = n1 + n2, ncol = n1 + n2,
                   dimnames = list(all_colnames, all_colnames))

# Correlation coefficient of vars1 and vars2
for (i in 1:n1) {
  for (j in 1:n2) {
    test_result <- cor.test(vars1[[i]], vars2[[j]], method = "pearson")
    cor_matrix[i, n1 + j] <- test_result$estimate
    cor_matrix[n1 + j, i] <- test_result$estimate
    p_matrix[i, n1 + j] <- test_result$p.value
    p_matrix[n1 + j, i] <- test_result$p.value
  }
}

# Output
write.xlsx(p_matrix,"p_matrix.xlsx")
write.xlsx(cor_matrix,"cor_matrix.xlsx")

# [file content end]