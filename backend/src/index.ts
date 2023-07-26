import { TypeBoxTypeProvider } from '@fastify/type-provider-typebox'
import fastify from "fastify"
import { configDotenv } from "dotenv"
import mongodb, { MongoClient } from "mongodb"

configDotenv() // .env 불러오기

const instance = fastify({ logger: true }).withTypeProvider<TypeBoxTypeProvider>()

// DB 등록
instance.register(async (instance:instance, _options:any, done:VoidFunction)=>{
    const mongoInstance = await new MongoClient(process.env.MONGOURL || "mongodb://localhost:19722").connect()
    const db = mongoInstance.db(process.env.MONGODB || "eye-of-school")
    instance.decorate("db",db)

    done()
})

// 라우터 등록
import InsertEvent from "./routes/InsertEvent"
instance.register(InsertEvent)
import GetRecentEvents from "./routes/GetRecentEvents"
instance.register(GetRecentEvents)
import GetGroups from "./routes/GetGroups"
instance.register(GetGroups)
import GetDevices from "./routes/GetDevices"
instance.register(GetDevices)
import BulkFetch from "./routes/BulkFetch"
instance.register(BulkFetch)

// 시작 & 타입
instance.listen({
    port: parseInt(process.env.PORT || '3000'),
    host: process.env.HOST || 'localhost',
})
declare module 'fastify' {
    interface FastifyInstance {
        db: mongodb.Db
    }
}
export type instance = typeof instance
