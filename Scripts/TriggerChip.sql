/**
*	Script de verificación de unicidad de implantación de microchip y esterilización
*	Autor: Daniela Prado Chaparro
*	Fecha: 12-09-2021
*	Universidad El Bosque
*	Base de Datos 2
*	Taller 2 Punto 2
*/

/**
 * Función que ejecutara el trigger que sera disparado cuando se actualice o inserte un registro, la eliminación de datos
 * no esta permitida en la tabla.
 */
CREATE OR REPLACE FUNCTION fcnValidacionChip()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$ DECLARE
	varChip VARCHAR(50);
	BEGIN
		
		SELECT	CHIP
		INTO	varChip
		FROM	MASCOTA
		WHERE	CODIGOMASCOTA = NEW.CODIGOMASCOTA;
	
		IF (NEW.CODITOTIPOVISITA = 'TPV003' AND COALESCE(varChip, 'N') = 'N') THEN
			RETURN NEW;
		ELSE
			RAISE 'La mascota ya tiene un chip asignado';
		END IF;
	
	END;
$$;

/**
 * Creación del trigger.
 */
DROP TRIGGER IF EXISTS trgValidacionChip ON Visita;
CREATE TRIGGER trgValidacionChip
	BEFORE INSERT ON Visita
	FOR EACH ROW
	EXECUTE PROCEDURE fcnValidacionChip();
	
/**
* Script para probar el trigger.
*/
INSERT INTO VISITA
			(CODIGOVISITA, CODIGOMASCOTA, CODITOTIPOVISITA, DOCUMENTOUSUARIO, OBSERVACION)
		VALUES
			('VIS00006', 'MAS005', 'TPV003', '987654321', 'Implantacion del chip');