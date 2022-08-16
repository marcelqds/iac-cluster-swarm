import { Pool, Client } = require('pg')
const connectionString = 'postgresql://toshiro:toshiro@localhost:5342/toshiro_db'

const pool = new Pool({
  connectionString,
})

pool.query('SELECT NOW()', (err, res) => {
  console.log(err, res)
  pool.end()
})

const client = new Client({
  connectionString,
})
client.connect()

client.query('SELECT NOW()', (err, res) => {
  console.log(err, res)
  client.end()
}) 
