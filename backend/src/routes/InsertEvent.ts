import {
    type instance
} from "../index"
import { Type, Static } from '@sinclair/typebox'
import { eventType } from "./GetRecentEvents"

type eventType = Static<typeof eventType>

export async function insertEvent(instance: instance,eventObject: eventType) {
    let collection = instance.db.collection("events")
    let data:any = {}

    data.eventId = eventObject.eventId
    data.type = eventObject.type
    data.deviceId = eventObject.deviceId
    data.date = eventObject.date ? +(new Date(eventObject.date)) : Date.now()
    if (eventObject.appName) data.appName = eventObject.appName
    if (eventObject.installLocation) data.installLocation = eventObject.installLocation
    if (eventObject.publicIp) data.publicIp = eventObject.publicIp
    if (eventObject.publisher) data.publisher = eventObject.publisher

    await collection.insertOne(eventObject)
}

export default function (instance: instance, _options:any, done:VoidFunction) {

    instance.post("/api/insert-event",{
        schema: {
            body: eventType,
            response: {
                200: Type.Undefined()
            }
        } as const,
        async handler(request, reply) {
            await insertEvent(instance,request.body)
            reply.send()
        }
    })

    done()
}
