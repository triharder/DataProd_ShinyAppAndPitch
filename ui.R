
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Major League Baseball Batting Statistics"),
  helpText("Based on a minimum of 300 plate appearances per year."),

  # Sidebar with checbox input
  sidebarLayout(
    sidebarPanel(
        helpText("Only selected values will show on table. Defaults to triple crown statistics."),
        checkboxGroupInput('stats', 'Batting statistics to show:',
                           names(playerStats), selected = c("Player","Teams","BA","HR","RBI")),
        helpText("Notes: XBH = Extra Base Hits; BBadj includes intentional walks and hit by pitch; SAC includes sacrifice flies and hits.")
    ),

    # Show table based on checkbox selections, default to triple crown stats
    mainPanel(
        helpText("Click on arrows to sort statistic of interest. Click twice for max number to show at top. Use top right search bar to search within results.  Use bottom text entry bars to filter respective fields."),
        dataTableOutput("maxStat"),
        helpText("Note: In Major League Baseball, a player earns the Triple Crown when he leads a league in three specific statistical categories. When used without a modifier, the Triple Crown generally refers to a batter who leads either the National or American leagues in batting average, home runs, and runs batted in (RBI) over a full regular season.[1] The Triple Crown epitomizes three separate attributes of a good hitter: hitting for average, hitting for power, and producing runs. It has been accomplished 17 times, most recently in 2012 with Miguel Cabrera producing the first such achievement in 45 years, after Carl Yastrzemski in 1967. (Wikipedia)
")
    )
  )
))
