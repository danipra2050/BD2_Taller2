/**
*	Script que realiza la insercción de la auditoria de la tabla Mascotas.
*	Autor: Daniela Prado Chaparro
*	Fecha: 12-09-2021
*	Universidad El Bosque
*	Base de Datos 2
*	Taller 2
*/

/**
 * Verifica la existencia de la tabla
 */
IF EXISTS DROP TABLE MascotaAudit;

/**
 * Creación de la tabla.
 */
CREATE TABLE MascotaAudit(
	codigoAuditoria INTEGER UNIQUE SERIAL,
	codigoMascota VARCHAR(10) NOT NULL,
	documentoUsuario VARCHAR(15) NOT NULL,
	nombreUsuario VARCHAR(100) NOT NULL,
	edad INT NOT NULL,
	especie VARCHAR(30) NOT NULL,
	tamano NUMERIC NOT NULL,
	peligroso BIT NOT NULL,
	foto VARCHAR(50) NOT NULL,
	activo BIT NOT NULL
	accionAuditoria VARCHAR(15) NOT NULL
	fechaAuditoria TIMESTAMP DEFAULT NOW() NOT NULL
);

/**
 * Función que ejecutara el trigger que sera disparado cuando se actualice o inserte un registro, la eliminación de datos
 * no esta permitida en la tabla.
 */
CREATE OR REPLACE FUNCTION fcnAuditoriaMascota()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$ DECLARE
	BEGIN
		
		
	END;
$$;
