/**
*	Script que realiza la insercci?n de la auditoria de la tabla Mascotas.
*	Autor: Daniela Prado Chaparro
*	Fecha: 12-09-2021
*	Universidad El Bosque
*	Base de Datos 2
*	Taller 2 Punto 1
*/

DROP TABLE MASCOTAAUDITORIA;
/**
 * Creaci?n de la tabla.
 */
CREATE TABLE MASCOTAAUDITORIA(
	codigoAuditoria SERIAL UNIQUE,
	codigoMascota VARCHAR(10) NOT NULL,
	documentoUsuario VARCHAR(15) NOT NULL,
	nombreUsuario VARCHAR(100) NOT NULL,
	nombreMascota VARCHAR(30) NOT NULL,
	edad INT NOT NULL,
	especie VARCHAR(30) NOT NULL,
	sexo VARCHAR(2) NOT NULL,
	tamano NUMERIC NOT NULL,
	peligroso BIT NOT NULL,
	foto VARCHAR(50) NOT NULL,
	activo BIT NOT NULL,
	accionAuditoria VARCHAR(15) NOT NULL,
	fechaAuditoria TIMESTAMP DEFAULT NOW() NOT NULL
);

/**
 * Funci?n que ejecutara el trigger que sera disparado cuando se actualice o inserte un registro, la eliminaci?n de datos
 * no esta permitida en la tabla.
 */
CREATE OR REPLACE FUNCTION fcnAuditoriaMascota()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$ DECLARE
	varNombreUsuario VARCHAR(100);
	BEGIN
		
		SELECT 	NOMBREUSUARIO
		INTO	varNombreUsuario	
		FROM 	USUARIO
		WHERE 	DOCUMENTOUSUARIO = CASE WHEN TG_OP = 'INSERT' THEN NEW.DOCUMENTOUSUARIO ELSE OLD.DOCUMENTOUSUARIO END;
		
		IF(TG_OP = 'DELETE') THEN
			RAISE 'Accion no permitida';
		END IF;
	
		IF EXISTS(SELECT CODIGOMASCOTA FROM MASCOTA WHERE CODIGOMASCOTA = NEW.CODIGOMASCOTA AND TG_OP = 'INSERT') THEN
			INSERT INTO MASCOTAAUDITORIA
						(CODIGOMASCOTA, DOCUMENTOUSUARIO, NOMBREUSUARIO, NOMBREMASCOTA, EDAD, ESPECIE, SEXO, TAMANO, PELIGROSO, FOTO,
						ACTIVO, ACCIONAUDITORIA, FECHAAUDITORIA)
					VALUES
						(NEW.CODIGOMASCOTA, NEW.DOCUMENTOUSUARIO, varNombreUsuario, NEW.NOMBREMASCOTA, NEW.EDAD, NEW.ESPECIE, NEW.SEXO,
						NEW.TAMANO, NEW.PELIGROSO, NEW.FOTO, NEW.ACTIVO, TG_OP, NOW());
			RETURN NEW;
		ELSEIF (TG_OP = 'UPDATE') THEN
			INSERT INTO MASCOTAAUDITORIA
						(CODIGOMASCOTA, DOCUMENTOUSUARIO, NOMBREUSUARIO, NOMBREMASCOTA, EDAD, ESPECIE, SEXO, TAMANO, PELIGROSO, FOTO,
						ACTIVO, ACCIONAUDITORIA, FECHAAUDITORIA)
					VALUES
						(OLD.CODIGOMASCOTA, OLD.DOCUMENTOUSUARIO, varNombreUsuario, OLD.NOMBREMASCOTA, OLD.EDAD, OLD.ESPECIE, OLD.SEXO,
						OLD.TAMANO, OLD.PELIGROSO, OLD.FOTO, OLD.ACTIVO, TG_OP, NOW());
			RETURN NEW;
		ELSE
			RAISE 'La mascota no existe.';			
		END IF;
	
	END;
$$;

/**
 * Creaci?n del trigger.
 */
DROP TRIGGER IF EXISTS trgAuditoriaMascota ON Mascota;
CREATE TRIGGER trgAuditoriaMascota
	AFTER INSERT OR UPDATE OR DELETE ON Mascota
	FOR EACH ROW
	EXECUTE PROCEDURE fcnAuditoriaMascota();

/**
* Prueba del trigger
*/
INSERT INTO MASCOTA
		(CODIGOMASCOTA, DOCUMENTOUSUARIO, NOMBREMASCOTA, EDAD, ESPECIE, SEXO, TAMANO, PELIGROSO, FOTO, ACTIVO)
	VALUES
		('MAS005', '123456789', 'Mascota 4', 8, 'Hamster', 'F', '10.5', '0', 'aqui va la ruta de la foto', '1');
		
UPDATE 	MASCOTA
SET		NOMBREMASCOTA = 'Hams 1', EDAD = 8, SEXO = 'M', TAMANO = 10.7, PELIGROSO = '0'
WHERE 	CODIGOMASCOTA = 'MAS005';