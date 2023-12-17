import { UpdateParentUserProfileDto } from "src/core/dto/parents/parents.update.dto";
import { PaginationParamsDto } from "src/core/dto/pagination-params.dto";
import { ApiResponseModel } from "src/core/models/api-response.model";
import { Parents } from "src/db/entities/Parents";
import { ParentsService } from "src/services/parents.service";
export declare class ParentsController {
    private readonly parentsService;
    constructor(parentsService: ParentsService);
    getDetails(parentCode: string): Promise<ApiResponseModel<Parents>>;
    getPaginated(params: PaginationParamsDto): Promise<ApiResponseModel<{
        results: Parents[];
        total: number;
    }>>;
    updateProfile(parentCode: string, dto: UpdateParentUserProfileDto): Promise<ApiResponseModel<Parents>>;
    approveAccessRequest(parentCode: string): Promise<ApiResponseModel<Parents>>;
    delete(parentCode: string): Promise<ApiResponseModel<Parents>>;
}
