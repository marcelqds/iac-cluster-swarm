import express,{ Router } from 'express';
import { routes } from './routes';
import { connect } from "./db";

let app = express();
app.use(express.json());
app.use(routes);

let port = 3000;

app.listen(port, async()=>{
    await connect();
    console.info("API Rest Toshiro - start in port "+port);
});

//https://node-postgres.com/features/connecting
//https://github.com/brianc/node-postgres-docs/blob/master/content/features/1-connecting.mdx

