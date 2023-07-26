import { TypeBoxTypeProvider } from '@fastify/type-provider-typebox'
import fastify from "fastify"
import { configDotenv } from "dotenv"
import mongodb, { MongoClient } from "mongodb"

configDotenv() // .env 불러오기

const instance = fastify({ logger: true, trustProxy: true }).withTypeProvider<TypeBoxTypeProvider>()

// 라우터 불러오기
import InsertEvent from "./routes/InsertEvent"
import GetRecentEvents from "./routes/GetRecentEvents"
import GetGroups from "./routes/GetGroups"
import GetDevices from "./routes/GetDevices"
import BulkFetch from "./routes/BulkFetch"
import GetAllowedIps from "./routes/GetAllowedIps"
import GetMyIP from "./routes/GetMyIP"

// DB 등록
(async ()=>{
    // 몽고 연결
    const url = process.env.MONGOURL || "mongodb://localhost:19722"
    const mongoInstance = await new MongoClient(url).connect()
    const dbName = process.env.MONGODB || "eye-of-school"
    const db = mongoInstance.db(dbName)
    instance.decorate("db",db)
    instance.log.info(`DB loaded (${url} : ${dbName})`)

    // 라우터 등록
    instance.register(InsertEvent)
    instance.register(GetRecentEvents)
    instance.register(GetGroups)
    instance.register(GetDevices)
    instance.register(BulkFetch)
    instance.register(GetAllowedIps)
    instance.register(GetMyIP)

    // 시작
    instance.listen({
        port: parseInt(process.env.PORT || '3000'),
        host: process.env.HOST || 'localhost',
    })
})()

// 타입
declare module 'fastify' {
    interface FastifyInstance {
        db: mongodb.Db
    }
}
export type instance = typeof instance
