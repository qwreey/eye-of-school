import {
    type instance
} from "../index"
import { Type, Static } from '@sinclair/typebox'

import { getDevices, responseType as deviceResponseType } from './GetDevices'
import { getGroups, responseType as groupResponseType } from './GetGroups'
import { getRecentEvents, responseType as recentEventResponseType } from './GetRecentEvents'


export default function (instance: instance, _options:any, done:VoidFunction) {
    const responseType = Type.Object({
        devices: Type.Optional(deviceResponseType),
        groups: Type.Optional(groupResponseType),
        recentEvents: Type.Optional(recentEventResponseType),
    })
    type responseType = Static<typeof responseType>
    type deviceResponseType = Static<typeof deviceResponseType>
    type groupResponseType = Static<typeof groupResponseType>
    type recentEventResponseType = Static<typeof recentEventResponseType>

    instance.post("/api/bulk-fetch",{
        schema: {
            body: Type.Object({
                groups: Type.Optional(Type.Boolean()),
                devices: Type.Optional(Type.Boolean()),
                recentEvents: Type.Optional(Type.Boolean()),
            }),
            response: {
                200: responseType
            }
        } as const,
        async handler(request, reply) {
            let response:responseType = {}
            if (request.body.devices) {
                response.devices = (await getDevices(instance)) as unknown as deviceResponseType
            }
            if (request.body.groups) {
                response.groups = (await getGroups(instance)) as unknown as groupResponseType
            }
            if (request.body.recentEvents) {
                response.recentEvents = (await getRecentEvents(instance,2592000)) as unknown as recentEventResponseType
            }
            reply.send(response)
        }
    })

    done()
}
