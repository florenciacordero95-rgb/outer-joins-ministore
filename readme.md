# MiniStore — Auditoría de Datos con Outer JOINs

Este repositorio contiene el esquema de pruebas y las soluciones analíticas desarrolladas en SQL Server para auditar la calidad de los datos e identificar discrepancias entre el catálogo de productos y el registro de ventas de MiniStore.

## Preguntas y Respuestas Técnicas

### 1. ¿Por qué usaste LEFT JOIN para la Consulta 1 y no INNER JOIN? ¿Qué se perdería si usaras INNER JOIN?
Usé `LEFT JOIN` porque la tabla base a la izquierda es `productos`. Esto le indica a la base de datos que debe conservar **todos** los registros del catálogo, incluso aquellos que no tienen una coincidencia en la tabla de `ventas`. Si hubiéramos usado un `INNER JOIN`, los productos `108` (Hub USB-C 7p) y `109` (Parlante Bluetooth) habrían desaparecido por completo del resultado, ocultando el hecho crítico de que nunca se han vendido.

### 2. ¿Por qué usaste RIGHT JOIN para la Consulta 2? ¿Qué tabla está a la izquierda y cuál a la derecha en tu consulta?
Usé `RIGHT JOIN` para priorizar la tabla ubicada a la derecha (`ventas`), garantizando que se muestren todas las transacciones registradas sin importar si su `producto_id` existe o no en el catálogo. En este diseño, `productos` está a la izquierda y `ventas` a la derecha. Esto permite detectar de inmediato el error de carga de la venta `10`, cuyo `producto_id` es `999`.

### 3. ¿Qué representan los valores NULL en cada resultado?
* En la **Consulta 1** (con `LEFT JOIN`), un valor `NULL` en la columna `venta_id` significa que ese producto específico del catálogo **nunca ha registrado ninguna venta**.
* En la **Consulta 2** (con `RIGHT JOIN`), un valor `NULL` en las columnas provenientes de la tabla `productos` significa que se intentó registrar una venta apuntando a un código de producto que **no existe en nuestra base de datos oficial**.

### 4. ¿Cuándo usarías FULL OUTER JOIN en un caso real de negocio?
El `FULL OUTER JOIN` se utiliza en procesos de conciliación y auditoría integral de bases de datos. Es ideal cuando necesitas cruzar dos fuentes de información (por ejemplo, el inventario físico de un almacén frente al sistema contable) donde te interesa auditar simultáneamente los dos extremos de los errores: tanto los faltantes de un lado como los sobrantes del otro, sin perder ninguna sola fila de la revisión.
