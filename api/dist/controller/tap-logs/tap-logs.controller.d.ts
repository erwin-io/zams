import { CreateTapLogDto } from "src/core/dto/tap-logs/tap-logs.create.dto";
import { ApiResponseModel } from "src/core/models/api-response.model";
import { TapLogs } from "src/db/entities/TapLogs";
import { TapLogsService } from "src/services/tap-logs.service";
export declare class TapLogsController {
    private readonly tapLogsService;
    constructor(tapLogsService: TapLogsService);
    getDetails(tapLogId: string): Promise<ApiResponseModel<TapLogs>>;
    create(tapLogsDto: CreateTapLogDto): Promise<ApiResponseModel<TapLogs>>;
    createBatch(tapLogsDtos: CreateTapLogDto[]): Promise<ApiResponseModel<any[]>>;
}
