```
# Load required libraries
library(shiny)
library(ggplot2)
```

# Sample OTU data (replace this with your actual data)
otu_data <- data.frame(
  OTU = c("OTU_1", "OTU_2", "OTU_3"),
  Sample_1 = c(120, 90, 60),
  Sample_2 = c(250, 100, 75),
  Sample_3 = c(180, 95, 80),
  Sample_4 = c(300, 120, 90),
  Sample_5 = c(200, 110, 85)
)

# Reshape data to long format for ggplot
otu_long <- reshape2::melt(otu_data, id.vars = "OTU", variable.name = "Sample", value.name = "Read_Count")

# Define UI for the Shiny app
ui <- fluidPage(
  titlePanel("OTU Boxplot"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selected_otu", "Select OTU:", choices = unique(otu_data$OTU))
    ),
    mainPanel(
      plotOutput("boxplot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  output$boxplot <- renderPlot({
    
    # Filter data for the selected OTU
    filtered_data <- otu_long[otu_long$OTU == input$selected_otu, ]
    
    # Create a grouping variable for samples
    filtered_data$Group <- ifelse(filtered_data$Sample %in% c("Sample_1", "Sample_2"), "Group 1", "Group 2")
    
    # Generate the boxplot using ggplot
    ggplot(filtered_data, aes(x = Group, y = Read_Count)) +
      geom_boxplot() +
      labs(title = paste("Boxplot for", input$selected_otu),
           x = "Group", y = "Read Count") +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
