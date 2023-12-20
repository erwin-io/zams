import { Module } from "@nestjs/common";
import { TapLogsController } from "./tap-logs.controller";
import { TapLogs } from "src/db/entities/TapLogs";
import { TapLogsService } from "src/services/tap-logs.service";
import { TypeOrmModule } from "@nestjs/typeorm";
import { FirebaseProviderModule } from "src/core/provider/firebase/firebase-provider.module";
import { PusherService } from "src/services/pusher.service";
import { FirebaseCloudMessagingService } from "src/services/firebase-cloud-messaging.service";

@Module({
  imports: [FirebaseProviderModule, TypeOrmModule.forFeature([TapLogs])],
  controllers: [TapLogsController],
  providers: [TapLogsService, PusherService, FirebaseCloudMessagingService],
  exports: [TapLogsService, PusherService, FirebaseCloudMessagingService],
})
export class TapLogsModule {}
