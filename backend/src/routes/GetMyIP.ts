import {
    type instance
} from "../index"
import { Type, Static } from '@sinclair/typebox'

export async function getAllowedIps(instance: instance,deviceId: string) {
    let collection = instance.db.collection("devices")
    return (await collection.findOne({deviceId: deviceId})).allowedIps
}

export default function (instance: instance, _options:any, done:VoidFunction) {
    type responseType = Static<typeof responseType>

    instance.get("/api/get-my-ip",{
        schema: {
            response: {
                200: Type.String()
            }
        } as const,
        async handler(request, reply) {
            console.log(request.ip)
            reply.send(request.ip)
        }
    })

    done()
}
