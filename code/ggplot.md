# __Uso de ggplot__  
En esta primera parte están los paquetes que utilizaremos:  
- **Shiny**: Nos permitirá crear aplicaciones que se pueden usar para la visualización de datos, análisis estadístico, y paneles de control y funciona de forma **reactiva** pues responde automaticamente a la interacción del usuario.  
- **ggplot2**: Es para generar visualizaciones de datos, permite crear gráficos de forma modular y personalizable.
```
# Load required libraries
library(shiny)
library(ggplot2)
```
Despues están declarados los datos de las Unidades Taxonómicas Operacionales "OTUs" con la función **data.frame** para generar tablas, ahí se asigna **otu_data** como la variable para guardar el conjunto de datos que se puede usar despues.  
- **OTU**: contiene los nombres de las OTUs y cada uno encabeza una fila diferente.  
- **Sample_n**: Son las diferentes muestras en las que se midieron los OTUs.  
- **c()**: genera vectores que en **data.frame** serán columnas.  
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
![(https://raw.githubusercontent.com/Yessica1535/Phylo_shinny/refs/heads/main/data/TablaChGPT.csv)
Posteriormente trasformamos el data frame de un formato ancho a uno largo, con la función **melt()** del paquete **reshape2**, esto para preparar los datos para visualizarlos con **ggplot2**.  
- **otu_long**: data frame de los datos trasformados.
- **otu_data**: es el data frame de entrada para transformar.
- **id.vars**: declara que "OTU" es la variable identificadora.  
- **variable.name** = declara que "Sample" es en nombre de la nueva columna, ahí estarán Sample_1, Sample 2, etc.  
- **Read_Count**: Le da el nombre a la nueva columna en donde estarán los valores de cada muestra.
```
# Reshape data to long format for ggplot
otu_long <- reshape2::melt(otu_data, id.vars = "OTU", variable.name = "Sample", value.name = "Read_Count")
```
![Aquí se podría insertar una imagen de la tabla que queda

Ahora filtramos al **otu_long** para obtener solo las filas de **OTU_1** y crear un nuevo data frame llamado **filtered_data**.  
```
# Filter data for the selected OTU
filtered_data <- otu_long[otu_long$OTU == "OTU_1", ]
```
Aquí  creamos una nueva columna de agrupación en **filtered_data**  
- **ifelse()**: es una función que permite hacer una evaluación condicional basada en verdadero o falso.
- **filtered_data$Sample**: Accede a la columna **Sample** del **filtered_data**, que contiene los nombres de las muestras.
- **%in%** operador que verifica si los valores de **filtered_data$Sample** están en el vector **c("Sample_1", "Sample_2")**.
- **Grupo 1** -> TRUE: Filas donde el nombre de la muestra sea "Sample_1" o "Sample_2".
- **Grupo 2** -> FALSE = Las demás muestras.
```
# Create a grouping variable for samples
filtered_data$Group <- ifelse(filtered_data$Sample %in% c("Sample_1", "Sample_2"), "Group 1", "Group 2")
```
Finalmente generamos el **boxplot** utilizando el paquete **ggplot2**  
- **ggplot()**: Función para la creación de un gráfico.
- **filtered_data**: Data frame a usar.
- **aes(...)**: Función que define las variables que se usarán en los ejes.
  - **Group**: se usará en el eje x.
  - **Read_Count**: se usará en el eje y.
  - **fill = Group**: Indica que los colores del gráfico se basarán en la variable **Group**.
- **geom_boxplot()**: Función que agrega un **boxplot** con la mediana, los cuartiles y los valores atípicos de los datos de la variable **Group** al gráfico.
- **labs()**: Para agregar títulos y etiquetas al gráfico.
  - **title = paste("Boxplot for", "OTU_1")**: título del gráfico.
  - **x = "Group"**: Etiqueta del eje x.
  - **y = "Read Count"**: Etiqueta del eje y.
- **scale_fill_manual(...)**: Función para personalizar los colores de los boxplots.
- **theme_minimal()**:Función que aplica un tema minimalista al gráfico (elimina elementos innecesarios).
```
# Generate the boxplot using ggplot
ggplot(filtered_data, aes(x = Group, y = Read_Count, fill = Group)) +
  geom_boxplot() +
  labs(title = paste("Boxplot for", "OTU_1"),
       x = "Group", y = "Read Count") +
  scale_fill_manual (values = c("Group 1" = "#B57EDC", "Group 2" = "#BFF7DC")) + theme_minimal()
```
![image1](https://github.com/Yessica1535/Phylo_shinny/blob/main/images/Rplot01.png)
