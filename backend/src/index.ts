import { TypeBoxTypeProvider } from '@fastify/type-provider-typebox'
import fastify from "fastify"
import { Type } from '@sinclair/typebox'
import { configDotenv } from "dotenv"
import mongodb from "mongodb"

configDotenv() // .env 불러오기

const instance = fastify({ logger: true }).withTypeProvider<TypeBoxTypeProvider>()

// DB 등록
const mongoInstance = await new mongodb.MongoClient(process.env.MONGOURL || "mongodb://localhost:19722").connect()
const db = mongoInstance.db(process.env.MONGODB || "eos")
instance.decorate("db",db)

// 라우터 등록
import
instance.register()

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
