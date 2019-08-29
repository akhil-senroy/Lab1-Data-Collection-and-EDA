library(shiny)
shinyUI(fluidPage(
  titlePanel("Analysis of frequency of tweets"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
            position="right",
    # Sidebar panel for inputs ----
    sidebarPanel(),
    
    # Main panel for displaying outputs ----
    mainPanel(
      tabsetPanel(type="tabs",
                  
                  tabPanel("keyword FLU",  headerPanel("HEAT MAP - FLU"),tags$img(src= "USmap _flu")),
                  tabPanel("keyword INFLUENZA",headerPanel("HEAT MAP - INFLUENZA"),tags$img(src="USmap _influ")),
                  tabPanel("keyword SWINE ", headerPanel("HEAT MAP - SWINE FLU"),tags$img(src="USmap _swine")),
                  tabPanel("keyword CANINE ", headerPanel("HEAT MAP - CANINE FLU"),tags$img(src="USmap _canine")),
                  tabPanel("keyword AVIAN ", headerPanel("HEAT MAP - AVIAN FLU"),tags$img(src="USmap _avian"))
            
        )
      )
    )
  )
)