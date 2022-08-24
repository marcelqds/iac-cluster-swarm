declare global{
    interface IconnectDB<T> {
        connect():Promise<T>
    }
    
    namespace Nodejs{
        interface ProcessEnv {
            PORT?:number;
        }
    }
}

export{};