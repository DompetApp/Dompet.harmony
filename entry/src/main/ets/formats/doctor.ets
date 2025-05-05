import { hyphenCase } from "@hitro/ark"
import { underCase } from "@hitro/ark"
import { camelCase } from "@hitro/ark"
import { upperCase } from "@hitro/ark"
import { lowerCase } from "@hitro/ark"
import { isString } from "@hitro/ark"

export class doctor {
  static hyphenCase<T extends Recorder>(json: T, first: boolean = false) {
    const refer: Recorder = json
    const arrays: [string, Object][] = Object.entries(json)

    for (const arr of arrays) {
      const key = isString(arr[0]) ? hyphenCase(arr[0], first) : arr[0]
      const value = arr[1]
      refer[key] = value
    }

    return refer as T
  }

  static underCase<T extends Recorder>(json: T, first: boolean = false) {
    const refer: Recorder = json
    const arrays: [string, Object][] = Object.entries(json)

    for (const arr of arrays) {
      const key = isString(arr[0]) ? underCase(arr[0], first) : arr[0]
      const value = arr[1]
      refer[key] = value
    }

    return refer as T
  }

  static camelCase<T extends Recorder>(json: T, first: boolean = false) {
    const refer: Recorder = json
    const arrays: [string, Object][] = Object.entries(json)

    for (const arr of arrays) {
      const key = isString(arr[0]) ? camelCase(arr[0], first) : arr[0]
      const value = arr[1]
      refer[key] = value
    }

    return refer as T
  }

  static upperCase<T extends Recorder>(json: T) {
    const refer: Recorder = json
    const arrays: [string, Object][] = Object.entries(json)

    for (const arr of arrays) {
      const key = isString(arr[0]) ? upperCase(arr[0]) : arr[0]
      const value = arr[1]
      refer[key] = value
    }

    return refer as T
  }

  static lowerCase<T extends Recorder>(json: T) {
    const refer: Recorder = json
    const arrays: [string, Object][] = Object.entries(json)

    for (const arr of arrays) {
      const key = isString(arr[0]) ? lowerCase(arr[0]) : arr[0]
      const value = arr[1]
      refer[key] = value
    }

    return refer as T
  }
}
