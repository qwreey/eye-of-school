import {
    type instance
} from "../index"
import { Type, Static } from '@sinclair/typebox'

export async function getRecentEvents(instance: instance,period: number,type?: string) {
    let collection = instance.db.collection("events")
    let now = +(new Date())

    return (await collection.find({
        type: type,
        date: {
            $gte: now - period
        }
    }).toArray()).forEach(element=>{
        element.date = (new Date(element.date)).toUTCString()
    })
}

export const eventType = Type.Intersect([
    Type.Object({
        eventId: Type.String(),
        deviceId: Type.String(),
        date: Type.String(),
        type: Type.String({
            examples: ["InstallState", "VpnState"],
        }),
    }),
    Type.Object({ // installState
        publisher: Type.String(),
        appName: Type.String(),
        installLocation: Type.String(),
    }),
    Type.Object({ // vpnState
        publicIp: Type.String(),
    })
])
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