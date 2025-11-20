# [file name]: SplitHalf.R
# [file content begin]
# ---
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

library(psych)
library(readxl)
library(boot)
library(writexl)

# Function for calculating split-half reliability coefficient
split_half_function <- function(data, indices) {
  sample_data <- data[indices, ]
  split_half_reliability <- splitHalf(sample_data)
  return(split_half_reliability$maxrb)
}


# Input data
dat <- read_excel("data_demo.xlsx", sheet = 1)


#1. Physiological domain(PHD)
md1 <- dat[,2:20]

# Set random seed for reproducibility
set.seed(123)

# Use the boot function for bootstrapping
num_samples <- 500
boot_results1 <- boot(data = md1, parallel = "multicore", statistic = split_half_function, R = num_samples)

# Convert results to a data frame
results_df1 <- as.data.frame(boot_results1$t)
colnames(results_df1) <- c("Maximum split half reliability (lambda 4)")

# Output
write_xlsx(results_df1, "PHD_SplitHalf.xlsx")


#2. Psychological domain (PSD)
md2 <- dat[,21:33]

# Set random seed for reproducibility
set.seed(123)

# Use the boot function for bootstrapping
num_samples <- 500
boot_results2 <- boot(data = md2, parallel = "multicore", statistic = split_half_function, R = num_samples)

# Convert results to a data frame
results_df2 <- as.data.frame(boot_results2$t)
colnames(results_df2) <- c("Maximum split half reliability (lambda 4)")

# Output
write_xlsx(results_df2, "PSD_SplitHalf.xlsx")


#3. Social domain (SOD)
md3 <- dat[,34:44]

# Set random seed for reproducibility
set.seed(123)

# Use the boot function for bootstrapping
num_samples <- 500
boot_results3 <- boot(data = md3, parallel = "multicore", statistic = split_half_function, R = num_samples)

# Convert results to a data frame
results_df3 <- as.data.frame(boot_results3$t)
colnames(results_df3) <- c("Maximum split half reliability (lambda 4)")

# Output
write_xlsx(results_df3, "SOD_SplitHalf.xlsx")


#4. Therapeutic domain (THD)
md4 <- dat[,45:53]

# Set random seed for reproducibility
set.seed(123)

# Use the boot function for bootstrapping
num_samples <- 500
boot_results4 <- boot(data = md4, parallel = "multicore", statistic = split_half_function, R = num_samples)

# Convert results to a data frame
results_df4 <- as.data.frame(boot_results4$t)
colnames(results_df4) <- c("Maximum split half reliability (lambda 4)")

# Output
write_xlsx(results_df4, "THD_SplitHalf.xlsx")


#5. Total Score
md0 <- dat[,2:53]

# Set random seed for reproducibility
set.seed(123)

# Use the boot function for bootstrapping
num_samples <- 500
boot_results0 <- boot(data = md0, parallel = "multicore", statistic = split_half_function, R = num_samples)

# Convert results to a data frame
results_df0 <- as.data.frame(boot_results0$t)
colnames(results_df0) <- c("Maximum split half reliability (lambda 4)")

# Output
write_xlsx(results_df0, "Total_SplitHalf.xlsx")

# [file content end]