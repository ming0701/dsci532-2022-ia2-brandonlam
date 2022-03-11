library(dash)
library(ggplot2)
library(plotly)
library(tidyverse)

data <- read_csv("imdb_2011-2020.csv")
app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

app$layout(
    dbcContainer(
        list(
            dccGraph(id='plot-area'),
            dccRadioItems(
                id='col-select',
                options = list(
                    list(label = "Rating", value = "averageRating"),
                    list(label = "Runtime", value = "runtimeMinutes")), 
                value='averageRating')
        )
    )
)

app$callback(
    output('plot-area', 'figure'),
    list(input('col-select', 'value')),
    function(ycol) {
        p <- ggplot(data) +
            aes(x = genres,
                y = !!sym(ycol),
                color = genres) +
            geom_boxplot()
        ggplotly(p)
    }
)

app$run_server(host = "0.0.0.0")
