En esta primera parte están los paquetes que utilizaremos:
**Shiny**: Nos permitirá crear aplicaciones que se pueden usar para la visualización de datos, análisis estadístico, y paneles de control y funciona de forma **reactiva** pues responde automaticamente a la interacción del usuario.
**ggplot2**: Es para generar visualizaciones de datos, permite crear gráficos de forma modular y personalizable.
```
# Load required libraries
library(shiny)
library(ggplot2)
```
Despues están declarados los datos de las Unidades Taxonómicas Operacionales "OTUs" con la función **data.frame** para generar tablas, ahí se asigna **otu_data** como la variable para guardar el conjunto de datos que se puede usar despues.
**OTU**: contiene los nombres de las OTUs y cada uno encabeza una fila diferente.
**Sample_n**: Son las diferentes muestras en las que se midieron los OTUs.
**c()**: genera vectores que en **data.frame** serán columnas.
```
# Sample OTU data (replace this with your actual data)
otu_data <- data.frame(
  OTU = c("OTU_1", "OTU_2", "OTU_3", "OTU_4"),
  Sample_1 = c(120, 90, 60, 234),
  Sample_2 = c(250, 100, 75, 125),
  Sample_3 = c(180, 95, 80, 345),
  Sample_4 = c(300, 120, 90, 78),
  Sample_5 = c(200, 110, 85, 80)
)
```
Aquí se podría insertar una imagen de la tabla que queda

Posteriormente trasformamos el data frame de un formato ancho a uno largo, con la función **melt()** del paquete **reshape2**, esto para preparar los datos para visualizarlos con **ggplot2**.
**otu_long**: contiene los datos trasformados.
**id.vars**: declara que "OTU" es la variable identificadora.
**variable.name** = declara que "Sample" es en nombre de la nueva columna, ahí estarán Sample_1, Sample 2, etc.
**Read_Count**: Le da el nombre a la nueva columna en donde estarán los valores de cada muestra.
```
# Reshape data to long format for ggplot
otu_long <- reshape2::melt(otu_data, id.vars = "OTU", variable.name = "Sample", value.name = "Read_Count")
```

```
Aquí se podría insertar una imagen de la tabla que queda
# Filter data for the selected OTU
filtered_data <- otu_long[otu_long$OTU == "OTU_1", ]
```

```
# Create a grouping variable for samples
filtered_data$Group <- ifelse(filtered_data$Sample %in% c("Sample_1", "Sample_2"), "Group 1", "Group 2")
```

```
# Generate the boxplot using ggplot
ggplot(filtered_data, aes(x = Group, y = Read_Count, fill = Group)) +
  geom_boxplot() +
  labs(title = paste("Boxplot for", "OTU_1"),
       x = "Group", y = "Read Count") +
  scale_fill_manual (values = c("Group 1" = "#B57EDC", "Group 2" = "#BFF7DC")) + theme_minimal()
```
Aquí se puede insertar el gráfico
```
```
jhjhbih
```
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
```

```
# Define server logic
server <- function(input, output) {
  
  output$boxplot <- renderPlot({
```

```    
    # Filter data for the selected OTU
    filtered_data <- otu_long[otu_long$OTU == input$selected_otu, ]
```

```    
    # Create a grouping variable for samples
    filtered_data$Group <- ifelse(filtered_data$Sample %in% c("Sample_1", "Sample_2"), "Group 1", "Group 2")
```

```    
    # Generate the boxplot using ggplot
    ggplot(filtered_data, aes(x = Group, y = Read_Count)) +
      geom_boxplot() +
      labs(title = paste("Boxplot for", input$selected_otu),
           x = "Group", y = "Read Count") +
      theme_minimal()
  })
}
```

```
# Run the app
shinyApp(ui = ui, server = server)
```