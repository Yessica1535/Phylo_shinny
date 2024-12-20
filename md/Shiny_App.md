# Uso de la Shiny App  
### Define la interfaz de usuario (UI) para la Shiny app  
Se define la estructura de la interfaz de usuario:
- **titlePanel**: Muestra el título de la aplicación ("ASV Boxplot").
- **sidebarLayout**: Estructura principal de la interfaz con dos paneles.
  - sidebarPanel: Contiene un menú desplegable (```selectInput```) que permite al usuario seleccionar una ASV específica.
    - ```inputId = "selected_otu"```: Identificador que el servidor usará para obtener la OTU seleccionada.
    - ```choices = unique(otu_data$OTU)```: Crea la lista de opciones con los nombres únicos de OTUs en el conjunto de datos.
  - **mainPanel**: Contiene el ```plotOutput("boxplot")``` que muestra el gráfico generado.
```
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
```
### Definición del servidor

El servidor define las funciones que crean y actualizan el contenido de la aplicación en función de la selección del usuario.

- **input$selected_asv**: Toma el valor seleccionado en ```selectInput```, filtrando el ```data frame``` ```asv_long``` para obtener solo los datos de la ASV elegida.

- **filtered_data$Group**: Agrupa las muestras en tres grupos dependiendo de las muestras que pertenecen a cada uno:

  - **fill = Group**: Usa el color para diferenciar los grupos. 
  - ```scale_fill_manual()```: Especifica colores personalizados para cada grupo.
  - ```labs()```: Etiquetas para el título, eje X, y eje Y.

    **La siguiente tabla explica los datos por sitio y año del ejemplo que estamos trabajando del artículo Diversity of bacterial communities in wetlands of Calakmul Biosphere Reserve: a comparative analysis between conserved and semiurbanized zones in pre-Mayan Train era**

| Muestra          | Tratamiento | Año |
|------------------|-------------|------|
| zr2757_2V3V4     | Ag-NP1      | 2017 |
| zr2757_10V3V4    | Ag-NP2      | 2017 |
| zr2757_1V3V4     | Ag-SU3      | 2017 |
| zr2757_8V3V4     | Ag-NP1      | 2018 |
| zr2757_6V3V4     | Ag-NP2      | 2018 |
| zr2757_3V3V4     | Ag-SU3      | 2018 |
| zr2757_5V3V4     | Ag-NP2      | 2019 |
| zr2757_9V3V4     | Ag-NP1      | 2019 |
| zr2757_7V3V4     | Ag-SU3      | 2019 |
| zr2757_4V3V4     | Ag-SU3      | 2019 |

    
```
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
```
### Ejecutar la aplicación

Esta línea ejecuta la aplicación de Shiny utilizando las definiciones de ```ui``` y ```server```. Cuando la aplicación se ejecuta, se abrirá una interfaz en la que el usuario podrá:

Seleccionar una ASV.
Ver un boxplot actualizado de acuerdo con la selección y la agrupación establecida.
```
shinyApp(ui = ui, server = server)
```
