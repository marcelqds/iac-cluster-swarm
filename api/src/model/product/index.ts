import { connect } from "../../db";

interface IInsertProduct{
    brand: string;
    name: string;
    price: number;
}

interface IResponseProduct{
    id: string;
    brand: string;
    name: string;
    price: number;
    created_at: Date;
    updated_at: Date;
    status: boolean;
}

class ProductModel{

    async find(id: String):Promise<IResponseProduct|{}>{
        try{
            const client = await connect();
            const result = await client.query("SELECT * FROM product WHERE id = $1;",[id]);
            return result.rows[0];
        }catch(error){
            return {};
        }
    }

    async findAll():Promise<IResponseProduct[]>{        
         const client = await connect();
         const result = await client.query("SELECT * FROM product WHERE status = $1;",[true]);
         return result.rows;
    }

    async create(data: IInsertProduct):Promise<IResponseProduct|Error>{
        if(!(data.name && data.price)) throw new Error("Informe os dados obrigatórios");
        try{
            const client = await connect();
            const result = await client.query("INSERT INTO product(brand,name, price) VALUES($1,$2,$3) RETURNING *;",[data.brand,data.name,data.price]);
            return result.rows[0];
        }catch(error){
            let message = "Ocorreu um problema";
            if(error instanceof Error)
                message = error.message;
            return new Error(message);
        }
    }

    async update(id: string, data:IInsertProduct): Promise<IResponseProduct|Error>{
        if(!(data.name && data.price))throw new Error("Os valores não podem ser nulos");
        try{
            const client = await connect();
            const result = await client.query("UPDATE product SET name = $1, price = $2, brand = $3 WHERE id like $4 RETURNING *;",[data.name,data.price,data.brand,id]);
            return result.rows[0];

        }catch(error){
            let message = "Ocorreu um problema";
            if(error instanceof Error)
                message = error.message;
            return new Error(message);
        }
    }

    async delete(id:string){
        try{
            const client = await connect();
            return await client.query("UPDATE product SET status = false WHERE id like $1 RETURNING true",[id]);
        }catch(error){
            let message = "Ocorreu um problema";
            if(error instanceof Error)
                message = error.message;
            return new Error(message);
        }
   } 

   async getConn(){
     return await connect();
   }
}

export {
    ProductModel,
    IInsertProduct,
    IResponseProduct
}
