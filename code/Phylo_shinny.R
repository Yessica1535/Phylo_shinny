# Load required libraries
library(shiny)
library(ggplot2)

# Sample ASV data 
#asv_data <- data.frame(
#            ASV = c("ASV_1", "ASV_2", "ASV_3", "ASV_4"),
#  zr2757_10V3V4 = c(37, 55, 8, 47) 
#   zr2757_1V3V4 = c(250, 100, 75, 125),
#   zr2757_2V3V4 = c(180, 95, 80, 345),
#   zr2757_3V3V4 = c(300, 120, 90, 78),
#   zr2757_4V3V4 = c(200, 110, 85, 80)
#)

# Read CSV file as a data frame
asv_data <- read.csv("C:/Users/yessi/OneDrive/Documentos/Calakmul/data/OtuTable.csv", header = TRUE)

# Reshape data to long format for ggplot
asv_long <- reshape2::melt(asv_data, id.vars = "ASV", variable.name = "Sample", value.name = "Read_Count")

# Filter data for the selected ASV
filtered_data <- asv_long[asv_long$ASV == "ASV_1", ]

# Create a grouping variable for samples
filtered_data$Group <- ifelse(filtered_data$Sample %in% c("zr2757_2V3V4", "zr2757_8V3V4", "zr2757_9V3V4"), "Ag-NP1",
                              ifelse(filtered_data$Sample %in% c("zr2757_10V3V4", "zr2757_6V3V4", "zr2757_5V3V4"), "Ag-NP2", 
                                     "Ag-SU3"))

filtered_data$GroupYear <- ifelse(filtered_data$Sample %in% c("zr2757_2V3V4", "zr2757_10V3V4", "zr2757_1V3V4"), "2017",
                              ifelse(filtered_data$Sample %in% c("zr2757_8V3V4", "zr2757_6V3V4", "zr2757_3V3V4"), "2018", 
                                     "2019"))

# Crear una tabla de grupos para las muestras
#groups_data <- data.frame(
#  Sample = c("zr2757_2V3V4", "zr2757_10V3V4", "zr2757_1V3V4", 
#             "zr2757_8V3V4", "zr2757_6V3V4", "zr2757_3V3V4", 
#             "zr2757_5V3V4", "zr2757_9V3V4", "zr2757_7V3V4", "zr2757_4V3V4"),
#  Group = c("Ag-NP1", "Ag-NP2", "Ag-SU3", "Ag-NP1", "Ag-NP2", 
#            "Ag-SU3", "Ag-NP2", "Ag-NP1", "Ag-SU3", "Ag-SU3")
#)

# Generate the boxplot using ggplot
ggplot(filtered_data, aes(x = Group, y = Read_Count, fill = Group)) +
  geom_boxplot() +
  labs(title = paste("Boxplot for", "ASV_1"),
       x = "Group", y = "Read Count") +
  scale_fill_manual (values = c("Ag-NP1" = "#B57EDC", "Ag-NP2" = "#BFF7DC", "Ag-SU3" = "#FFC0CB")) + theme_minimal()
################################################################################################################

# Define UI for the Shiny app
ui <- fluidPage(
  titlePanel("ASV Boxplot"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selected_asv", "Select ASV:", choices = unique(asv_data$ASV))
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
    filtered_data <- asv_long[asv_long$ASV == input$selected_asv, ]
    
    # Create a grouping variable for samples
    filtered_data$Group <- ifelse(filtered_data$Sample %in% c("zr2757_2V3V4", "zr2757_8V3V4", "zr2757_9V3V4"), "Ag-NP1",
                                  ifelse(filtered_data$Sample %in% c("zr2757_10V3V4", "zr2757_6V3V4", "zr2757_5V3V4"), "Ag-NP2", 
                                         "Ag-SU3"))
    
    filtered_data$GroupYear <- ifelse(filtered_data$Sample %in% c("zr2757_2V3V4", "zr2757_10V3V4", "zr2757_1V3V4"), "2017",
                                      ifelse(filtered_data$Sample %in% c("zr2757_8V3V4", "zr2757_6V3V4", "zr2757_3V3V4"), "2018", 
                                             "2019"))
    
    # Generate the boxplot using ggplot
    ggplot(filtered_data, aes(x = Group, y = Read_Count, fill = Group)) +
      geom_boxplot() +
      labs(title = paste("Boxplot for", input$selected_asv),
           x = "Group", y = "Read Count") +
      scale_fill_manual (values = c("Ag-NP1" = "#B57EDC", "Ag-NP2" = "#BFF7DC", "Ag-SU3" = "#FFC0CB")) + theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)

#Falta ver porque se corta hasta 1000 ASV

