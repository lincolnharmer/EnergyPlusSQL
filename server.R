#open libraries
library(shiny)
library(openair)
library(plotly)
library(RSQLite)
library(reshape2)
library(ggplot2)
#define ability to open large files
options(shiny.maxRequestSize = -1)
# Define server logic for random distribution application
shinyServer(function(input, output, session) {
  #opening the file
  userdata <- reactive(function(){
     if(is.null(input$bugs)){return()}
	 drv <- dbDriver("SQLite") 
con <- dbConnect(drv, dbname = "eplusout.sql") 

       bugs <- dbGetQuery(con, "select VariableName FROM ReportVariableDataDictionary")
	  
	   })
	   
	  observe({
    df <- userdata()
    str(names(df))
    if (!is.null(df)) {
      updateSelectInput(session,"variable", choices = (df))
	   
    }
  }) 
  
  query<-reactive({
  		   drv <- dbDriver("SQLite") 
  con <- dbConnect(drv, dbname = "eplusout.sql")
  

  numVars=length(input$variable)


  vars=as.data.frame(matrix(nrow=1,ncol=numVars))
  for (i in 1:numVars ) {
    vars[[i]] <- dbGetQuery(con, paste("select ReportVariableDataDictionaryIndex FROM ReportVariableDataDictionary WHERE VariableName='",input$variable[i],"'",sep=""))
  }
  
  varsDataTest <- dbGetQuery(con, paste("select VariableValue FROM ReportVariableData WHERE ReportVariableDataDictionaryIndex='",vars[[1]],"'",sep=""))
  leng=dim(varsDataTest)[1]
  
  varsData=as.data.frame(matrix(nrow=leng,ncol=numVars)) 
  vars_temp=as.data.frame(matrix(nrow=leng,ncol=numVars)) 
  
  for (i in 1:numVars ) {
     vars_temp<- dbGetQuery(con, paste("select VariableValue FROM ReportVariableData WHERE ReportVariableDataDictionaryIndex='",vars[[i]],"'",sep=""))
     varsData[[i]]=vars_temp[[1]]
  }
    
  new=gsub(":", "_", input$variable)
  names(varsData) <- new
return(varsData)

})
  
  output$filetable <- renderTable(function(){
    if (is.null(input$bugs)) {
      # User has not uploaded a file yet
      return(NULL)
    }

	query()

 })

  output$plot <- renderUI({
  {
    new=gsub(":", "_", input$variable)
	new=c("Date",input$variable)

  plotData=query()
  lengthTemp=dim(plotData[[1]])[2]
  rows=nrow(plotData)
  x=1:rows
  plotData=cbind(x,plotData)
   names(plotData) <- new
   plotData_long <- melt(plotData, id="Date")
  	
		py <- plotly(username=input$userName, key=input$key)
		viz2 <- ggplot(data=plotData_long,aes(x=Date, y=value, colour=variable)) + 
		geom_line() 
		layout <- list(legend.position = "top",legend.direction = "horizontal")
		res <- py$ggplotly(viz2,kwargs=list(filename="Plotly in Shiny",layout=layout, 
                                           fileopt="overwrite", # Overwrite plot in Plotly's website
                                           auto_open=FALSE))

    tags$iframe(src=res$response$url,
                  frameBorder="0",  # Some aesthetics
                  height=500,
                  width=1300*3/4*5/6)
		}
	  })
	  	
 #download the data
output$downloadData <- downloadHandler(
  filename = function() {
    paste("Data","csv", sep = ".")
  },
     content = function(file) {
    write.csv(query(), file)
       
 }
)
	

})

