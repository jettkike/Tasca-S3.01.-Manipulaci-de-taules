-- Nivell 1
-- Exercici 1
-- Tu tarea es diseñar y crear una tabla llamada "credit_card" que almacene detalles cruciales sobre las tarjetas de crédito. 
-- La nueva tabla debe ser capaz de identificar de forma única cada tarjeta y establecer una relación adecuada con las otras dos tablas ("transaction" y "company"). 
-- Después de crear la tabla será necesario que ingreses la información del documento denominado "datos_introducir_credit". 
-- Recuerda mostrar el diagrama y realizar una breve descripción del mismo.

CREATE TABLE credit_card (
    id VARCHAR(255) PRIMARY KEY,
    iban VARCHAR(255),
    pan VARCHAR(255),
    pin VARCHAR(255),
    cvv VARCHAR(255),
    expiring_date VARCHAR(255)
);

-- Insertamos datos de credit_card

ALTER TABLE transaction 
ADD CONSTRAINT fk_transaction_credit_card 
FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);

-- - Exercici 2
-- El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938. 
-- La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999. Recorda mostrar que el canvi es va realitzar.

UPDATE credit_card 
SET iban = 'R323456312213576817699999'
WHERE ID = 'CcU-2938';
			  
SELECT *
FROM credit_card
WHERE ID = 'CcU-2938';


-- Exercici 3
-- En la taula "transaction" ingressa un nou usuari amb la següent informació:
-- id				108B1D1D-5B23-A76C-55EF-C568E49A99DD
-- credit_card_id	CcU-9999
-- company_id		b-9999
-- user_id			9999
-- lat				829.999
-- longitude		-117.999
-- amount			111.11
-- declined			0

SELECT COUNT(*)
FROM transaction;

INSERT INTO company (id) VALUES ('b-9999');

INSERT INTO credit_card (id) VALUES ('CcU-9999');

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
values ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '111.11','0');

SELECT COUNT(*)
FROM transaction;

-- Exercici 4
-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card DROP COLUMN pan;

SHOW COLUMNS FROM credit_card;

-- *************************************************************************************************************
-- ** NIVELL 2 **

-- Exercici 1
-- Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.

SELECT COUNT(*) FROM transaction;

DELETE FROM transaction 
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

SELECT COUNT(*) FROM transaction;

-- Exercici 2
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives.
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació:
-- Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW VistaMarketing AS
SELECT c.company_name, c.phone, c.country, round(AVG(t.amount),2) AS MediaVentas
FROM company c
INNER JOIN transaction t ON c.id = t.company_id -- where company_name is not null
GROUP BY c.id
ORDER BY MediaVentas DESC;

SELECT * FROM VistaMarketing;


-- Exercici 3
-- Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

SELECT vm.company_name
FROM vistamarketing vm
WHERE vm.country = 'Germany';

-- **************************************************************************************************************
-- ** Nivell 3 **
-- Exercici 1
-- La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. 
-- Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar. 
-- demana que l'ajudis a deixar els comandos executats per a obtenir el diagrama:

DESC credit_card;

ALTER TABLE credit_card MODIFY id VARCHAR(20);
ALTER TABLE credit_card MODIFY iban VARCHAR(50);
ALTER TABLE credit_card MODIFY pin VARCHAR(4);
ALTER TABLE credit_card MODIFY cvv INT;
ALTER TABLE credit_card MODIFY expiring_date VARCHAR(20);


ALTER TABLE credit_card ADD fecha_actual DATE;
DESC credit_card;


  -- Creamos la tabla user
 
CREATE TABLE IF NOT EXISTS user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255)
    );
    
-- Insertamos datos de user

-- cambiamos nombre a tabla
RENAME TABLE user to data_user;

-- cambiamos nombre a columna
ALTER TABLE data_user CHANGE email personal_email VARCHAR(150);
DESC data_user;

-- agregamos el constraint de foreign key para relacionarla con transaction
ALTER TABLE transaction
ADD CONSTRAINT fk_trans_data_user
FOREIGN KEY(user_id) REFERENCES data_user(id);

-- al crear la constraint de FK no nos deja da error
-- Este error nos indica que hay un valor en transaction que no está referido en la tabla data_user (id), que es primary key 

-- Entonces buscamos el valor que no existe en la tabla data_user y que sí está en transaction: Y es el user_id = 9999 
SELECT t.user_id
FROM transaction t 
WHERE t.user_id NOT IN (SELECT d.id FROM data_user d);

-- insertamos este valor en la tabla data_user: user_id = 9999 
INSERT INTO data_user (id) 
SELECT t.user_id
FROM transaction t 
WHERE t.user_id NOT IN (SELECT d.id FROM data_user d);

-- Y verificamos que no haya datos en la tabla transaction que no esten en la tabla data_user 
SELECT t.user_id
FROM transaction t 
WHERE t.user_id NOT IN (SELECT d.id FROM data_user d);

-- Ahora si , Creamos la relacion entre la tabla data_user y transaction de uno a muchos
ALTER TABLE transaction
ADD CONSTRAINT fk_trans_data_user
FOREIGN KEY(user_id) REFERENCES data_user(id);

-- ELIMINAMOS COLUMNA DE COMPANY
ALTER TABLE company DROP website;

SELECT * FROM data_user;

-- Exercici 2
-- L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:

  -- ID de la transacció
  -- Nom de l'usuari/ària
  -- Cognom de l'usuari/ària
  -- IBAN de la targeta de crèdit usada.
  -- Nom de la companyia de la transacció realitzada.
  
-- Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.
-- Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.

CREATE VIEW InformeTecnico AS
SELECT t.id AS Transaccion, d.name AS Nombre_usuario, d.surname AS Apellido_usuario, cr.iban AS Numero_tarjeta, c.company_name AS Nombre_company
FROM transaction t
INNER JOIN data_user d ON t.user_id = d.id
INNER JOIN credit_card cr ON t.credit_card_id = cr.id
INNER JOIN company c ON t.company_id = c.id
ORDER BY t.id DESC;

SELECT *
FROM InformeTecnico;

