setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(shiny)
library(lubridate)
library(DT)

# Function for saving data to a CSV file
log_line <- function(newdata, filename = 'app_data.csv'){
  (dt <- Sys.time() %>% round %>% as.character)
  (newline <- c(dt, newdata) %>% paste(collapse=',') %>% paste0('\n'))
  cat(newline, file=filename, append=TRUE)
  print('Data stored!')
}

################################################################################
################################################################################

ui <- fluidPage(

  titlePanel(h4("Data entry app")),
  br(),
  fluidRow(
    # Example input: manual text entry
    
    # Example input: toggling between options
    column(4, radioButtons('site_number',
                           label='Site number',
                           choices = paste('site', 1:6),
                           inline = TRUE,
                           width='100%')),
  column(4, selectInput( 
    "select", 
    "Select options below:", 
    list("No Arundinaria" = "No Arundinaria", "Arundinaria" = "Arundinaria"),
    width ='40%'
  )),
  
  column(4, textInput('location',
                      label='Location',
                      value='',
                      width = '75%')),

    column(4, textInput('tree_id',
                        label='Tree ID',
                        value='',
                        width = '40%')),
    column(4, textInput('dbh',
                        label='DBH',
                        value='',
                        width = '40%')),
    column(4, textInput('height',
                        label='Height',
                        value='',
                        width = '40%'))),
  
  fluidRow(column(2),
           # Save button!
           column(8, actionButton('save',
                                  h2('Save!'),
                                  width='100%')),
           column(2)),
  br(), br(), 

  fluidRow(column(12, DTOutput('data')))
  
  
  
)
  


################################################################################
################################################################################

server <- function(input, output) {
  rv <- reactiveValues()
  rv$df <- read.csv('app_data.csv', header=TRUE)
  
  output$data <- renderDT({
    df <- read.csv('app_data.csv')
    rv$df
  })
  
  
  
  
  # Save button ================================================================
  observeEvent(input$save, {
    newdata <- c(input$location, input$select, input$site_number,input$tree_id,input$dbh,input$height)
    log_line(newdata)
    showNotification("Save successful!")
    rv$df <- read.csv('app_data.csv', header=TRUE)
    

  })
  #=============================================================================
  
  
  
}


################################################################################
################################################################################

shinyApp(ui, server)