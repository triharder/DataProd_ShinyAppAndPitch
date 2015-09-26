
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {

    output$maxStat <- renderDataTable({

        playerStats[, input$stats]

    }, options = list(order=(list(1,'desc')), lengthMenu = c(5, 10, 20, 50), orderClasses = TRUE, pageLength=10))

    })
