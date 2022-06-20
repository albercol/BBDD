/*Alberto Collado Mamblona
  Beatriz Villegas Sanchez*/
--SHOW ERRORS;
-- set serveroutput on size 10000;

 begin
   dbms_output.put_line('Hola Mundo');
  end; 
  /
  
/*1. Procedimiento almacenado llamado pedidosCliente que reciba como parámetro el id de un cliente (customer_id) y
muestre por pantalla sus datos personales (customer_id, cust_first_name, cust_last_name), junto con un listado con 
los datos de los pedidos que ha realizado (order_id, order_date, order_status y order_total), ordenados crecientemente 
por fecha. En caso de error (el id del cliente no existe o no hay pedidos para ese cliente), deberá mostrarse por pantalla
un mensaje de advertencia explicando el error. Al finalizar el listado se deberá mostrar la suma de los importes de todos 
los pedidos del cliente.
Incluye un bloque de código anónimo para probar el procedimiento. Ejemplo de salida tras llamar al procedimiento
pedidosCliente con 4 ids distintos:*/

begin
 dbms_output.put_line( 'Precio total pedidos : '|| totalPedidos(102) || '. ');
end;
/

--FUNCIONA LA FUNCION.
CREATE OR REPLACE FUNCTION totalPedidos(idcliente PR5_CUSTOMERS.customer_id%type)
  RETURN pr5_orders.order_total%TYPE
IS
 total pr5_orders.order_total%TYPE;
BEGIN 
  SELECT SUM(order_total)
  INTO total
  FROM  pr5_orders JOIN pr5_customers ON pr5_orders.customer_id = pr5_customers.customer_id
  WHERE pr5_orders.customer_id = idcliente;
  
  RETURN total;

END;

CREATE OR REPLACE PROCEDURE pedidosCliente (idcliente PR5_CUSTOMERS.customer_id%type)
IS
DECLARE
  TYPE tPedido IS RECORD(
      idpedido pr5_orders.order_id%TYPE,
      fecha pr5_orders.order_date%TYPE,
      estado pr5_orders.order_status%TYPE,
      total pr5_orders.order_total%TYPE
      );
    
    miVarPedido tPedido;
    NOPEDIDO EXCEPTION;

BEGIN

  SELECT customer_id, cust_first_name, cust_last_name
  FROM pr5_customers
  WHERE customer_id = idcliente;
  
  SELECT o.order_id, o.order_date, o.order_status, o.order_total
  FROM pr5_orders o JOIN pr5_customers  c ON o.customer_id = c.customer_id
  WHERE  o.customer_id = idcliente;
  ORDER BY o.order_date ASC;
  
  
  OPEN cursorPedidos;
  FETCH cursorPedidos INTO miVarPedido;
  WHILE cursorPedidos%FOUND LOOP
    IF  (miVarPedido.idpedido == NULL) THEN
      RAISE  NOPEDIDO;
    END IF;
    
  END LOOP;
 
  CLOSE cursorPedidos;
  

  EXCEPTION 
    WHEN NOPEDIDO THEN
      DBMS_OUTPUT.put_line('El cliente con id' || idcliente || ', no tiene pedidos.');
    
END;
/