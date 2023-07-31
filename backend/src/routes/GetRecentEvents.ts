import {
    type instance
} from "../index"
import { Type, Static } from '@sinclair/typebox'

export async function getRecentEvents(instance: instance,period: number,type?: string) {
    let collection = instance.db.collection("events")
    let now = +(new Date())

    let result = (await collection.find({
        // type: type,
        date: {
            $gte: now - period*1000
        }
    }).toArray())

    result.sort((a,b)=>b.date-a.date)

    result.forEach(element=>{
        element.date = (new Date(element.date)).toUTCString()
    })

    return result
}

export const eventType = Type.Object({ // installState
    eventId: Type.String(),
    deviceId: Type.String(),
    date: Type.Optional(Type.String()),
    type: Type.String({
        examples: ["InstallState", "VpnState"],
    }),
    publisher: Type.Optional(Type.String()),
    appName: Type.Optional(Type.String()),
    installLocation: Type.Optional(Type.String()),
    publicIp: Type.Optional(Type.String()),
})
export const responseType = Type.Array(eventType)

export default function (instance: instance, _options:any, done:VoidFunction) {
    type responseType = Static<typeof responseType>

    instance.get("/api/get-recent-events",{
        schema: {
            querystring: Type.Object({
                period: Type.Number(),
                type: Type.Optional(Type.String())
            }),
            response: {
                200: responseType
            }
        } as const,
        async handler(request, reply) {
            reply.send(await getRecentEvents(instance, request.query.period, request.query.type) as unknown as responseType)
        }
    })

    done()
}
