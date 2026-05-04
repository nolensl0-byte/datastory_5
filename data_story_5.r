setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(shiny)
library(lubridate)
library(DT)

# Function for saving data to a CSV file
log_line <- function(newdata, filename = 'tree_data.csv'){
  (newline <- c(newdata) %>% paste(collapse=',') %>% paste0('\n'))
  cat(newline, file=filename, append=TRUE)
  print('Data stored!')
}


################################################################################
################################################################################


ui <- fluidPage(
  titlePanel(h4("Data entry app")),
  br(),
  fluidRow(
    column(4,
           radioButtons(
              'site_number',
              label='Site Number',
              choices = paste('site', 0:6),
              inline = TRUE,
              width='40%')),
    
    column(4,
           selectInput(
             'select',
             'Select options below:',
             choices = c('No Arundinaria', 'Arundinaria'),
             width = '40%')
    ),
    column(4,
           textInput('location', 
                     'Location', 
                     value = '', 
                     width = '40%')
    ),
    column(4,
           textInput('tree_id', 
                     'Tree ID', 
                     value = '', 
                     width = '40%')
    ),
    column(4,
           textInput('dbh', 
                     'DBH', 
                     value = '', 
                     width = '40%')
    ),
    column(4,
           textInput('height', 
                     'Height', 
                     value = '', 
                     width = '40%')
    )
  ),
  
  br(),
  br(),
  
  fluidRow(column(2),
           # Save button!
           column(8, actionButton('save',
                                  h2('Save!'),
                                  width='100%')),
           column(2)),
  br(),
  br(),
 
  fluidRow(column(12, DTOutput('data')))
)


# =============================================================================
# SERVER
# =============================================================================
server <- function(input, output) {
  rv <- reactiveValues()
  #rv$df <- read.csv('tree_data.csv', header=FALSE)
  
  output$data <- renderDT({
    #df <- read.csv('tree_data.csv')
    #rv$df
  })
  
  # Save button ================================================================
  observeEvent(input$save, {
    newdata <- c(input$site_number, input$select, input$location, input$tree_id, 
                 input$dbh, input$height)
    log_line(newdata)
    showNotification("Save successful!")
  })
  #=============================================================================
  
}
#=============================================================================
shinyApp(ui, server)
