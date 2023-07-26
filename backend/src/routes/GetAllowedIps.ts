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

    instance.post("/api/get-allowed-ips",{
        schema: {
            body: Type.Object({
                deviceId: Type.String()
            }),
            response: {
                200: Type.Array(Type.String())
            }
        } as const,
        async handler(request, reply) {
            reply.send(await getAllowedIps(instance,request.body.deviceId) as unknown as string[])
        }
    })

    done()
}
