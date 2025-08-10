const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");
const { Client } = require('pg');
const dns = require('dns');

const s3 = new S3Client({ region: "us-east-1" });
const BUCKET_NAME = "imagenesffa";

exports.handler = async (event) => {
  const parsedEvent = JSON.parse(event.body);
  const body = JSON.parse(parsedEvent.body);  

  dns.lookup(process.env.DB_HOST, (err, address) => {
    console.log('DNS lookup:', err || address);
  });

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
    await client.query('BEGIN');

    const insertCliente = `
      INSERT INTO clientes (
        nombre, genero, edad, correo, sucursal, 
        ubicacion_lat, ubicacion_lng, hora_inicio, hora_fin, 
        dia_cobro, forma_pago, nit
      ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)
      RETURNING id;
    `;

    const values = [
      body.nombre,
      body.genero,
      body.edad,
      body.correo,
      body.sucursal,
      body.ubicacion_lat,
      body.ubicacion_lng,
      body.hora_inicio,
      body.hora_fin,
      body.dia_cobro,
      body.forma_pago,
      body.nit
    ];

    const resCliente = await client.query(insertCliente, values);
    const clienteId = resCliente.rows[0].id;

    // Teléfonos
    if (Array.isArray(body.telefonos)) {
      for (const tel of body.telefonos) {
        await client.query(
          `INSERT INTO telefonos_cliente (cliente_id, telefono) VALUES ($1, $2)`,
          [clienteId, tel]
        );
      }
    }

    // Direcciones
    if (Array.isArray(body.direcciones)) {
      for (const dir of body.direcciones) {
        await client.query(
          `INSERT INTO direcciones_cliente (cliente_id, direccion) VALUES ($1, $2)`,
          [clienteId, dir]
        );
      }
    }
   
    // Fotos
    /*if (Array.isArray(body.fotos)) {
      for (const foto of body.fotos) {
        
        if (!foto.imagen_base64 || foto.imagen_base64.trim() === "") {
          continue; // Salta esta iteración si no hay imagen
        }
        
        const base64Data = foto.imagen_base64;
        const extension = foto.extension || "jpg";
        const base64 = base64Data.replace(/^data:image\/\w+;base64,/, "");
        const buffer = Buffer.from(base64, "base64");
        const key = `uploads/${Date.now()}.${extension}`;
        const command = new PutObjectCommand({
          Bucket: BUCKET_NAME,
          Key: key,
          Body: buffer,
          ContentEncoding: 'base64',
          ContentType: `image/${extension}`, 
          ACL: 'public-read', 
        });
    
        await s3.send(command);
    
        // URL pública del archivo
        const url = `https://${BUCKET_NAME}.s3.amazonaws.com/${key}`;

        await client.query(
          `INSERT INTO fotos_cliente (cliente_id, tipo_foto, url_s3) VALUES ($1, $2, $3)`,
          [clienteId, foto.tipo_foto, url]
        );
      }
    }*/

    await client.query('COMMIT');
    await client.end();

    return {
      statusCode: 200,
      body: JSON.stringify({ mensaje: 'Cliente guardado exitosamente', cliente_id: clienteId })
    };
  } catch (error) {
    await client.query('ROLLBACK');
    await client.end();
    console.error('Error al guardar cliente:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ mensaje: 'Error al guardar', error: error.message })
    };
  }
};
