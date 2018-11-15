#
# Shinyapps.io Azure SQL Connection App
#

library(shiny)
library(odbc)
library(config)
library(DBI)

conn_args <- config::get("dataconnection")

con <- dbConnect(odbc::odbc(),
    Driver = conn_args$driver,
    Server = conn_args$server,
    UID = conn_args$uid,
    PWD = conn_args$pwd,
    Port = conn_args$port,
    Database = conn_args$database
)

ui <- fluidPage(

    titlePanel("Shiny + Azure SQL Test"),

    sidebarLayout(
        sidebarPanel(
            h4('Create an Azure SQL database in the Azure portal'),
            tags$a(href="https://docs.microsoft.com/en-us/azure/sql-database/sql-database-get-started-portal",
                   "Quickstart: Docs"),
            hr(),
            h4('SQL Query:'),
            tags$code("
                    SELECT TOP 20 pc.Name as CategoryName, p.name as ProductName
                    FROM SalesLT.ProductCategory pc
                    JOIN SalesLT.Product p
                    ON pc.productcategoryid = p.productcategoryid;
                      ")
        ),

        mainPanel(
           dataTableOutput("products")
        )
    )
)

server <- function(input, output) {

    output$products <- renderDataTable({
        dbGetQuery(con,'
            SELECT TOP 20 pc.Name as CategoryName, p.name as ProductName
            FROM SalesLT.ProductCategory pc
            JOIN SalesLT.Product p
            ON pc.productcategoryid = p.productcategoryid;
        ')
    })
}

# Run the application
shinyApp(ui = ui, server = server)
