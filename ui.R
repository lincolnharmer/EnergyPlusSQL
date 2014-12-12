library(shiny)
userdata <- list('Upload a file'=c(1))
# Define UI for random distribution application 
shinyUI(fluidPage(

  # Application title
  headerPanel("E+ SQL Tool"),

  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the br()
  # element to introduce extra vertical spacing
  sidebarPanel(
  
  textInput("userName", label = h6("Enter Plotly User Name"), value = "Plotly User Name"),
  textInput("key", label = h6("Enter Plotly Key"), value = "Plotly Key"),
  br(),
  br(),
    fileInput("bugs", "Input Data"),

		br(),			  
	#selecting the oudoor air temp
	selectInput("variable","Select Output Variable(s)",names(userdata),selected="none",multiple=TRUE),

	br(),
			 	br()),
					
		

	 h6("Created By: Lincoln Harmer"),

  # Show a tabset that includes a plot, summary, and table view
  # of the generated distribution
  mainPanel(
    tabsetPanel(
	  	    tabPanel("Instructions",
			h1("Instructions"),
			p("1) select an EnergyPlus SQL Output File"),
			p("2) Choose Variable(s) to be plotted/downloaded")),

      
		
		tabPanel("Data",fluidRow(tableOutput('filetable'))),
		tabPanel("Plot",uiOutput("plot")),
        tabPanel("Download", downloadButton('downloadData', 'Download Data')))
		)

))
