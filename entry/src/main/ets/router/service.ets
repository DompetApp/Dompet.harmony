import { HMService } from "@hadss/hmrouter"
import { logger } from "../tracks/logger"


export class RouterGlobalService {
  @HMService({ serviceName: 'logger' })
  logger(message: Object, error?: Object, stack?: Object) {
    logger.info(message, error, stack)
  }
}