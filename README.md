EnergyPlusSQL
=============
Use this tool to create interactive plots and download E+ output data in a CSV format.

### Installation instructions

Download the ui.R file and the server.R file to a directory of your choice, then install the following R packages:
* shiny
* openair
* RSQLite
* reshape2
* ggplot2

All of the above can be installed by typing in R: `install.packages("Name_of_Package")`

* plotly: install devtools first in order to use install_github. In R:
```
install.packages('devtools')
devtools::instal_github('ropensci/plotly')
```

You'll also need to create an account at [Plotly](www.plotly.com) and retrieve an API Key to view the interactive plots.


### Running the program

Use the `runApp(">DirectoryOfYourChoice<")` command in RStudio to run the program.

The easiest is to change the working directory in R (Go to File > "Change dir...") to the one where you have your files and type in R command:
```
library(shiny)
runApp(appDir = getwd())
```

Open the program in a browser for best performance. 


TODO: Add support for IP units, other chart types
