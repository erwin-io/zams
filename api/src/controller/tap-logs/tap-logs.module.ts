import { Module } from "@nestjs/common";
import { TapLogsController } from "./tap-logs.controller";
import { TapLogs } from "src/db/entities/TapLogs";
import { TapLogsService } from "src/services/tap-logs.service";
import { TypeOrmModule } from "@nestjs/typeorm";
import { FirebaseProviderModule } from "src/core/provider/firebase/firebase-provider.module";
import { PusherService } from "src/services/pusher.service";

@Module({
  imports: [FirebaseProviderModule, TypeOrmModule.forFeature([TapLogs])],
  controllers: [TapLogsController],
  providers: [TapLogsService, PusherService],
  exports: [TapLogsService, PusherService],
})
export class TapLogsModule {}
