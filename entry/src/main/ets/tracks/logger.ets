import { SafeWriteFileOutput } from "logger"
import { SafeConsoleOutput } from "logger"
import { SafeMultiOutput } from "logger"
import { logger } from "logger"

logger.reset({
  output: new SafeMultiOutput([
    new SafeWriteFileOutput({ storage: 'dompet/logger/cache' }),
    new SafeConsoleOutput()
  ]),
})

export { logger }