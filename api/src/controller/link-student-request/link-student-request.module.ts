import { Module } from "@nestjs/common";
import { LinkStudentRequestController } from "./link-student-request.controller";
import { LinkStudentRequestService } from "src/services/link-student-request.service";
import { TypeOrmModule } from "@nestjs/typeorm";
import { LinkStudentRequest } from "src/db/entities/LinkStudentRequest";
import { PusherService } from "src/services/pusher.service";

@Module({
  imports: [TypeOrmModule.forFeature([LinkStudentRequest])],
  controllers: [LinkStudentRequestController],
  providers: [LinkStudentRequestService, PusherService],
  exports: [LinkStudentRequestService, PusherService],
})
export class LinkStudentRequestModule {}
