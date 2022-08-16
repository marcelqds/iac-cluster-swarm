import { Router } from 'express';
import { routerProduct } from './product'
let routes = Router();
routes.use("/product",routerProduct);


export {
    routes
}
