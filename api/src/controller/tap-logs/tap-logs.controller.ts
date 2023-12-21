import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
} from "@nestjs/common";
import { ApiBody, ApiTags } from "@nestjs/swagger";
import {
  DELETE_SUCCESS,
  SAVING_SUCCESS,
  UPDATE_SUCCESS,
} from "src/common/constant/api-response.constant";
import { CreateTapLogDto } from "src/core/dto/tap-logs/tap-logs.create.dto";
import { UpdateTapLogDto } from "src/core/dto/tap-logs/tap-logs.update.dto";
import { PaginationParamsDto } from "src/core/dto/pagination-params.dto";
import { ApiResponseModel } from "src/core/models/api-response.model";
import { TapLogs } from "src/db/entities/TapLogs";
import { TapLogsService } from "src/services/tap-logs.service";

@ApiTags("tapLogs")
@Controller("tapLogs")
export class TapLogsController {
  constructor(private readonly tapLogsService: TapLogsService) {}

  @Get("/:tapLogId")
  //   @UseGuards(JwtAuthGuard)
  async getDetails(@Param("tapLogId") tapLogId: string) {
    const res = {} as ApiResponseModel<TapLogs>;
    try {
      res.data = await this.tapLogsService.getByCode(tapLogId);
      res.success = true;
      return res;
    } catch (e) {
      res.success = false;
      res.message = e.message !== undefined ? e.message : e;
      return res;
    }
  }

  @Post("")
  //   @UseGuards(JwtAuthGuard)
  async create(@Body() tapLogsDto: CreateTapLogDto) {
    const res: ApiResponseModel<TapLogs> = {} as any;
    try {
      res.data = await this.tapLogsService.create(tapLogsDto);
      res.success = true;
      res.message = `Tap Logs ${SAVING_SUCCESS}`;
      return res;
    } catch (e) {
      res.success = false;
      res.message = e.message !== undefined ? e.message : e;
      return res;
    }
  }


  @ApiBody({
    isArray: true,
    type: CreateTapLogDto,
  })
  @Post("createBatch")
  //   @UseGuards(JwtAuthGuard)
  async createBatch(@Body() tapLogsDtos: CreateTapLogDto[]) {
    const res: ApiResponseModel<any[]> = {} as any;
    try {
      res.data = await this.tapLogsService.createBatch(tapLogsDtos);
      res.success = true;
      res.message = `Tap Logs ${SAVING_SUCCESS}`;
      return res;
    } catch (e) {
      res.success = false;
      res.message = e.message !== undefined ? e.message : e;
      return res;
    }
  }
}
