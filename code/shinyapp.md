# Define la interfaz de usuario (UI) para la Shiny app  

* Se define la estructura de la interfaz de usuario:

- **titlePanel**: Muestra el título de la aplicación ("OTU Boxplot").
- **sidebarLayout**: Estructura principal de la interfaz con dos paneles.
  - sidebarPanel: Contiene un menú desplegable (```selectInput```) que permite al usuario seleccionar una OTU específica.
    - ```inputId = "selected_otu"```: Identificador que el servidor usará para obtener la OTU seleccionada.
    - ```choices = unique(otu_data$OTU)```: Crea la lista de opciones con los nombres únicos de OTUs en el conjunto de datos.
  - **mainPanel**: Contiene el plotOutput("boxplot") que muestra el gráfico generado.
```
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

# Definición del servidor

El servidor define las funciones que crean y actualizan el contenido de la aplicación en función de la selección del usuario.

- **input$selected_otu**: Toma el valor seleccionado en selectInput, filtrando el data frame otu_long para obtener solo los datos de la OTU elegida.

- **filtered_data$Group**: Agrupa las muestras en dos grupos ("Group 1" y "Group 2") dependiendo de las muestras que pertenecen a cada uno:

  - "Group 1" para Sample_1 y Sample_2
  - "Group 2" para Sample_3, Sample_4 y Sample_5
- **ggplot**: Genera el gráfico de caja (boxplot):

  - **fill = Group**: Usa el color para diferenciar los grupos.
  -scale_fill_manual(): Especifica colores personalizados para cada grupo.
  -labs(): Etiquetas para el título, eje X, y eje Y.
```
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
```
# Ejecutar la aplicación

Esta línea ejecuta la aplicación de Shiny utilizando las definiciones de ui y server. Cuando la aplicación se ejecuta, se abrirá una interfaz en la que el usuario podrá:

Seleccionar una OTU.
Ver un boxplot actualizado de acuerdo con la selección y la agrupación establecida.
```
shinyApp(ui = ui, server = server)
```
