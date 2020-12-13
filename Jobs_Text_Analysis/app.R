#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(jsonlite)
library(tidyr)
library(tidytext)
library(dplyr)
library(wordcloud)
library(ggplot2)
library(knitr)
library(kableExtra)
library(tm)

Adzuna_file <- jsonlite::fromJSON("https://api.adzuna.com/v1/api/jobs/us/search/1?app_id=018d3e05&app_key=c61bad16e0597343a3b672a6984062a8&results_per_page=100&what_phrase=data%20science&full_time=1", flatten=TRUE)
adzuna <- Adzuna_file$results
tidy_adzuna <- adzuna %>% unnest_tokens(word, description) %>% anti_join(stop_words)

Github_Jobs_file <- jsonlite::fromJSON("https://jobs.github.com/positions.json?utf8=%E2%9C%93&description=data+science&location=usa&full_time=on", flatten=TRUE)
github <- Github_Jobs_file
tidy_github <- github %>% unnest_tokens(word, description) %>% anti_join(stop_words) %>%
    filter(word != "li" & word != "ul")

Muse_file <- jsonlite::fromJSON("https://www.themuse.com/api/public/jobs?category=Data%20Science&page=1", flatten=TRUE)
muse <- Muse_file$results
tidy_muse <- muse %>% unnest_tokens(word, contents) %>% anti_join(stop_words) %>% filter(word != "li" & word != "br" & word != "de" & word != "ul" & word != "ml")


sites <- c("Adzuna", "Github Jobs", "The Muse")

ui <- fluidPage(
    # Application title
    titlePanel("Word Cloud"),
    
    sidebarLayout(
        # Sidebar with a slider and selection inputs
        sidebarPanel(
            selectInput("selection", "Choose a job board site:",
                        choices = sites),
            hr(),
            sliderInput("freq",
                        "Minimum Frequency:",
                        min = 1,  max = 50, value = 15),
            sliderInput("max",
                        "Maximum Number of Words:",
                        min = 1,  max = 100,  value = 20)
        ),
        
        # Show Word Cloud
        mainPanel(
            plotOutput("plot")
        )
    )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
    output$plot <- renderPlot({
        if (isTRUE(input$selection == "Adzuna")) {
            plot <- tidy_adzuna %>% count(word)
        }
        if (isTRUE(input$selection == "Github Jobs")) {
           plot <- tidy_github %>% count(word)
        }
        if (isTRUE(input$selection == "The Muse")) {
           plot <- tidy_muse %>% count(word)
        }
        plot %>% 
            with(wordcloud(word, n, scale=c(4,0.5), min.freq = input$freq, max.words=input$max))
    }) 
  
}


shinyApp(ui = ui, server = server)


