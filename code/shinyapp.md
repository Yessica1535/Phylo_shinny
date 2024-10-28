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
      labs(title = paste("Boxplot for", "OTU_1"),
           x = "Group", y = "Read Count") +
      scale_fill_manual (values = c("Group 1" = "#B57EDC", "Group 2" = "#BFF7DC")) + theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)

