export{};

declare global{
    interface IconnectDB<T> {
        connect():Promise<T>
    }
}
