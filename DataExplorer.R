# DataExplorer
# R Package by Boxuan Cui

#### Prepare data ####

library(dplyr)
str(starwars, max.level = 2)

data <- starwars %>% select(name:species)


#### Simply create a report ####

library(DataExplorer)
create_report(data)


#### Create individual elements of a report ####

# What does the D3 network plot do with the nested list structure in starwars?

plot_str(starwars)
# For more functions, see ?plot_


#### Adjust settings ####

# Change theme, increase font size
# Remove PCA (prcomp)

config <- configure_report(global_ggtheme = quote(ggthemes::theme_wsj(base_size = 18)),
                 add_plot_prcomp = FALSE)


create_report(data, config = config)


#### About the package: DataExplorer ####

help(package = "DataExplorer")
# See description and vignette