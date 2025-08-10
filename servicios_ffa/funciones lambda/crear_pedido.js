const { Client } = require('pg');
const dns = require('dns');

exports.handler = async (event) => {
  const parsedEvent = JSON.parse(event.body);
  const body = JSON.parse(parsedEvent.body);  

  dns.lookup(process.env.DB_HOST, (err, address) => {
    console.log('DNS lookup:', err || address);
  });

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
    await client.connect();
    await client.query('BEGIN');

    const insertPedidoQuery = `
      INSERT INTO pedidos (cliente_id, producto, ubicacion_entrega, fecha_entrega)
      VALUES ($1, $2, $3, $4)
      RETURNING id;
    `;

    const values = [
      body.cliente_id,
      JSON.stringify(body.productos), // productos es un array de objetos [{codigo_producto, cantidad}]
      body.ubicacion,
      body.fecha_entrega
    ];

    const result = await client.query(insertPedidoQuery, values);
    const pedidoId = result.rows[0].id;

    await client.query('COMMIT');
    await client.end();

    return {
      statusCode: 200,
      body: JSON.stringify({ mensaje: 'Pedido guardado exitosamente', pedido_id: pedidoId })
    };
  } catch (error) {
    try {
      await client.query('ROLLBACK');
    } catch (rollbackError) {
      console.error('Error en rollback:', rollbackError);
    }
    try {
      await client.end();
    } catch (endError) {
      console.error('Error cerrando la conexión:', endError);
    }
    console.error('Error al guardar pedido:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ mensaje: 'Error al guardar pedido', error: error.message })
    };
  }
};
