const { Client } = require('pg');

exports.handler = async (event) => {
  const client = new Client({
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT, 10) ,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: {
      rejectUnauthorized: false
    }
  });

  try {
    const parsedEvent = JSON.parse(event.body);
  const body = JSON.parse(parsedEvent.body); 

    const clienteId = body.cliente_id;

    if (!clienteId) {
      return {
        statusCode: 400,
        body: JSON.stringify({ mensaje: "cliente_id es requerido en el body" }),
      };
    }

    await client.connect();

    const res = await client.query(
      'SELECT direccion FROM direcciones_cliente WHERE cliente_id = $1',
      [clienteId]
    );

    if (res.rows.length === 0) {
      return {
        statusCode: 404,
        body: JSON.stringify({ mensaje: "Cliente no encontrado" }),
      };
    }

    return {
      statusCode: 200,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        ubicacion: res.rows,
      }),
    };

  } catch (error) {
    console.error('Error fetching ubicación del cliente:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ mensaje: 'Error al obtener ubicación', error: error.message }),
    };
  } finally {
    await client.end().catch(err => {
      console.error('Error cerrando conexión:', err);
    });
  }
};
