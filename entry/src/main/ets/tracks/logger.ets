import { SafePrettyPrinter } from "logger"
import { SafeWriteFileOutput } from "logger"
import { SafeConsoleOutput } from "logger"
import { SafeMultiOutput } from "logger"
import { logger } from "logger"

export * from "logger"

logger.reset({
  printer: new SafePrettyPrinter({ lineLength: 50 }),
  output: new SafeMultiOutput([
    new SafeWriteFileOutput({ storage: 'com.package.dompet/logger/cache' }),
    new SafeConsoleOutput()
  ]),
})

export { logger }