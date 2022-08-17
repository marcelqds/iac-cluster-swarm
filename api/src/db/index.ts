import { Pool,PoolClient } from 'pg';
const connectionString = 'postgresql://postgres:toshiro@localhost:5432/toshiro_db';

interface IPool{
    connect():Promise<PoolClient>
}
async function connect():Promise<PoolClient>{
    if(global.connectDB)
        return global.connectDB.connect();

    const pool = new Pool({ connectionString,});
    try{
        await pool.connect();
        global.connectDB = pool;
        console.info("Conectado ao banco de dados!");
        let client = await pool.connect();        
       await client.query("CREATE TABLE IF NOT EXISTS product(id UUID PRIMARY KEY DEFAULT gen_random_uuid(), brand varchar(60) not null, name varchar(50) not null, price real, status boolean DEFAULT true, created_at timestamp DEFAULT CURRENT_TIMESTAMP, UNIQUE(brand, name) );");
        return pool.connect();
    }catch(error){
        if(error instanceof Error)
            console.error(`Ocorreu:DB: ${error.message}`);
        process.exit(1);
    }
}

export {
    connect
}
