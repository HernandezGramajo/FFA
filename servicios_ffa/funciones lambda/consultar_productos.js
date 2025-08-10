const { Client } = require('pg');

exports.handler = async (event) => {
  
  const client = new Client({
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT, 10) || 5432,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: {
      rejectUnauthorized: false
    }
  });
  

  try {
    await client.connect();

    const res = await client.query('SELECT nombre, codigo_producto FROM productos ORDER BY nombre ASC');

    return {
      statusCode: 200,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        productos: res.rows,
      }),
    };
  } catch (error) {
    console.error('Error fetching products:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ mensaje: 'Error al obtener producto', error: error.message }),
    };
  } finally {
    await client.end().catch(err => {
      console.error('Error closing client:', err);
    });
  }
};
