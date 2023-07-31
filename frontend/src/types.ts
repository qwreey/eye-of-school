export type id = string
export type DeviceId = id
export type GroupId  = id
export type EventId  = id

export type FullVpnState = {
  deviceId: DeviceId,
  groupId:  GroupId,
  eventId:  EventId,
  groupDisplayName: string,
  deviceDisplayName: string,
  displayName: string,
  publicIp: string,
  dateDisplayString: string,
}

export type FullInstallState = {
  deviceId: DeviceId,
  groupId:  GroupId,
  eventId:  EventId,
  groupDisplayName: string,
  deviceDisplayName: string,
  displayName: string,
  dateDisplayString: string,
  publisher: string,
  appName: string,
  installLocation:string
}

export type InstallState = {
  eventId:  EventId,
  deviceId: DeviceId,
  publisher?: string,
  appName?: string,
  date: string,
  installLocation?: string,
  type: "InstallState"
}

export type Group = {
  groupId: GroupId,
  displayName: string,
}

export type Device = {
  groupId: GroupId,
  deviceId: DeviceId,
  displayName: string,
  allowedIps: string[],
}

export type VpnState = {
  eventId: EventId,
  deviceId: DeviceId,
  publicIp: string,
  date: string,
  type: "VpnState"
}
