import {Request, Response } from 'express';

class ProductController{
    find(req: Request, res:Response){
        
        res.send({});
    }

    findAll(req:Request, res:Response){

        res.send({});       
    }

    create(req:Request, res:Response){
         res.status(201).send({});       
    }

    update(req:Request, res:Response){
        
        res.send({});
    }

    delete(req:Request, res:Response){
        res.sendStatus(204);
    }
}

export {
    ProductController,
}
