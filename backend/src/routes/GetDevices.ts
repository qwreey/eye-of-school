import {
    type instance
} from "../index"
import { Type, Static } from '@sinclair/typebox'

export async function getDevices(instance: instance) {
    let collection = instance.db.collection("devices")
    return await collection.find({}).toArray()
}

export const responseType = Type.Array(Type.Object({
    groupId: Type.String(),
    deviceId: Type.String(),
    displayName: Type.String(),
    allowedIps: Type.String(),
}))

export default function (instance: instance, _options:any, done:VoidFunction) {
    type responseType = Static<typeof responseType>

    instance.get("/api/get-devices",{
        schema: {
            response: {
                200: responseType
            }
        } as const,
        async handler(request, reply) {
            reply.send(await getDevices(instance) as unknown as responseType)
        }
    })

    done()
}
