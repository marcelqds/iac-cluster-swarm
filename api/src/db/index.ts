import { Pool,PoolClient } from 'pg';
const connectionString = 'postgresql://postgres:toshiro@192.168.1.107:5432/toshiro_db';

interface IPool{
    connect():Promise<PoolClient>
}
async function connect():Promise<PoolClient>{
    let globalConnect = global as typeof globalThis & {pool:Pool;};

    if(globalConnect.pool)
        return globalConnect.pool.connect();    

    try{
        const pool = new Pool({ connectionString,});
        await pool.connect();        
        
        globalConnect.pool = pool;
        
        let client = await pool.connect();        
        await client.query("CREATE TABLE IF NOT EXISTS product(id UUID PRIMARY KEY DEFAULT gen_random_uuid(), brand varchar(60) not null, name varchar(50) not null, price real, status boolean DEFAULT true, created_at timestamp DEFAULT CURRENT_TIMESTAMP, UNIQUE(brand, name) );");
        console.info("Conectado ao banco de dados!");
        
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
