import { Router, Response, Request } from 'express';
import { ProductController } from '../../controller';

let routerProduct = Router();
const productController = new ProductController();

routerProduct.get("/",productController.findAll);
routerProduct.get("/:id",productController.find);
routerProduct.post("/",productController.create);
routerProduct.put("/",productController.update);
routerProduct.delete("/",productController.delete);

export{
    routerProduct
}
