import {
    type instance
} from "../index"
import { Type, Static } from '@sinclair/typebox'

export async function getGroups(instance: instance) {
    let collection = instance.db.collection("groups")
    return await collection.find({}).toArray()
}

export const responseType = Type.Array(Type.Object({
    groupId: Type.String(),
    displayName: Type.String(),
}))

export default function (instance: instance, _options:any, done:VoidFunction) {
    type responseType = Static<typeof responseType>

    instance.get("/api/get-groups",{
        schema: {
            response: {
                200: responseType
            }
        } as const,
        async handler(request, reply) {
            reply.send(await getGroups(instance) as unknown as responseType)
        }
    })

    done()
}
