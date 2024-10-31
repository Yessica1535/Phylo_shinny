# __Uso de ggplot__  
### Cargar las "librerías" necesarias  
En esta primera parte se encuentra el paquete que se usará:  
- **ggplot2**: Es para generar visualizaciones de datos, permite crear gráficos de forma modular y personalizable.
```
# Load required libraries
library(ggplot2)
```
### Declaración de datos  
Están declarados los datos de Variante de Secuencia de Amplicón "ASV" con la función **data.frame** para generar tablas, ahí se asigna **asv_data** como la variable para guardar el conjunto de datos que se puede usar despues.  
- **ASV**: contiene los nombres de las ASVs y cada uno encabeza una fila diferente.  
- **Sample_n**: Son las diferentes muestras en las que se midieron los ASVs.  
- **c()**: genera vectores que en **data.frame** serán columnas.
```
# Sample ASV data 
#asv_data <- data.frame(
#            ASV = c("ASV_1", "ASV_2", "ASV_3", "ASV_4"),
#  zr2757_10V3V4 = c(37, 55, 8, 47) 
#   zr2757_1V3V4 = c(250, 100, 75, 125),
#   zr2757_2V3V4 = c(180, 95, 80, 345),
#   zr2757_3V3V4 = c(300, 120, 90, 78),
#   zr2757_4V3V4 = c(200, 110, 85, 80)
#)
```
Tambien se puede cargar los datos con la función **read.csv** para leer archivos en dicho formato.  
```
# Read CSV file as a data frame
asv_data <- read.csv("C:/Users/yessi/OneDrive/Documentos/Calakmul/data/OtuTable.csv", header = TRUE)
```
Despues de este proceso la tabla se observa en el siguiente formato  
![image1](https://github.com/Yessica1535/Phylo_shinny/blob/main/images/Captura%20de%20pantalla%202024-10-30%20014132.png)

Posteriormente trasformamos el data frame de un formato ancho a uno largo, con la función **melt()** del paquete **reshape2**, esto para preparar los datos para visualizarlos con **ggplot2**.  
- **otu_long**: data frame de los datos trasformados.
- **otu_data**: es el data frame de entrada para transformar.
- **id.vars**: declara que "OTU" es la variable identificadora.  
- **variable.name** = declara que "Sample" es en nombre de la nueva columna, ahí estarán Sample_1, Sample 2, etc.  
- **Read_Count**: Le da el nombre a la nueva columna en donde estarán los valores de cada muestra.
```
# Reshape data to long format for ggplot
asv_long <- reshape2::melt(asv_data, id.vars = "ASV", variable.name = "Sample", value.name = "Read_Count")
```
Ahora la tabla tiene un formato diferente  
![image1](https://github.com/Yessica1535/Phylo_shinny/blob/main/images/Captura%20de%20pantalla%202024-10-30%20015309.png)

### Filtrado de datos  
Filtramos al **asv_long** para obtener solo las filas de **ASV_1** y crear un nuevo data frame llamado **filtered_data**.  
```
# Filter data for the selected ASV
filtered_data <- asv_long[asv_long$ASV == "ASV_1", ]
```
AQUI FALTA MODIFICAR LOS GRUPOS
Aquí  creamos una nueva columna de agrupación en **filtered_data**  
- **ifelse()**: es una función que permite hacer una evaluación condicional basada en verdadero o falso.
- **filtered_data$Sample**: Accede a la columna **Sample** del **filtered_data**, que contiene los nombres de las muestras.
- **%in%** operador que verifica si los valores de **filtered_data$Sample** están en el vector **c("Sample_1", "Sample_2")**.
- **Grupo 1** -> TRUE: Filas donde el nombre de la muestra sea "Sample_1" o "Sample_2".
- **Grupo 2** -> FALSE = Las demás muestras.
```
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
  labs(title = paste("Boxplot for", "ASV_1"),
       x = "Group", y = "Read Count") +
  scale_fill_manual (values = c("Ag-NP1" = "#B57EDC", "Ag-NP2" = "#BFF7DC", "Ag-SU3" = "#FFC0CB")) + theme_minimal()
```
![image1](https://github.com/Yessica1535/Phylo_shinny/blob/main/images/Rplot02.png)
