/**
*	Script de verificaci�n de unicidad de implantaci�n de microchip y esterilizaci�n
*	Autor: Daniela Prado Chaparro
*	Fecha: 12-09-2021
*	Universidad El Bosque
*	Base de Datos 2
*	Taller 2 Punto 2
*/

/**
 * Creaci�n de la tabla que obtiene las metricas de implantaci�n de chips
 */
CREATE TABLE IF NOT EXISTS MicrochipGoals(
	fechaInicial DATE NOT NULL,
	fechaFinal DATE NOT NULL,
	cantidad INT NOT NULL,
	cumplimiento VARCHAR(10) NOT NULL
);


SELECT	COUNT(CODIGOVISITA) AS cantVisitas, CONCAT((COUNT(CODIGOVISITA) * 100) / 100, '%') AS compliance,
		NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7, NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER
FROM 	VISITA
WHERE 	CODITOTIPOVISITA = 'TPV003'
AND 	FECHAREGISTRO BETWEEN NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 
AND		NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER;