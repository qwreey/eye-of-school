export type id = string
export type deviceId = id
export type groupId  = id
export type eventId  = id

export type FullVpnStatus = {
  deviceId: deviceId,
  groupId:  groupId,
  eventId:  eventId,
  groupDisplayName: string,
  deviceDisplayName: string,
  displayName: string,
  publicIp: string,
  dateDisplayString: string,
}

export type group = {
  groupId: groupId,
  displayName: string,
}

export type devices = {
  groupId: groupId,
  deviceId: deviceId,
  displayName: string,
}

export type vpnState = {
  eventId: eventId,
  deviceId: deviceId,
  publicIp: string,
  date: string,
}
