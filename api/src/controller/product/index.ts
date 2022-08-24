import {Request, Response } from 'express';
import { ProductModel,IInsertProduct } from '../../model';

class ProductController{

    async find(req: Request, res:Response){
        const { id } = req.params;
        const product = new ProductModel();
        const result = await product.find(id);
        console.log({data: result});
        res.send({data:result});
    }

    async findAll(req:Request, res:Response){
        console.log("Requisitando");
        const product = new ProductModel();
        let result = await product.findAll();
        console.log(result);
        res.send({data: result });       
    }

    async create(req:Request, res:Response){
        let data:IInsertProduct = req.body as IInsertProduct;
        const product = new ProductModel();
        const result = await product.create(data);
        console.log(result);
        res.status(201).send({data: result});       
    }

    async update(req:Request, res:Response){
        const { id } = req.params;
        const data:IInsertProduct = req.body as IInsertProduct;
        const product = new ProductModel();
        const result = await product.update(id,data);
        console.log(result);
        res.send({data: result});
    }

    async delete(req:Request, res:Response){
        const { id } = req.params;
        const product = new ProductModel();
        const result = await product.delete(id);
        res.sendStatus(204);
    }
}

export {
    ProductController,
}
