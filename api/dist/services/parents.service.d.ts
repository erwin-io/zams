import { UpdateUserResetPasswordDto } from "src/core/dto/auth/reset-password.dto";
import { UpdateParentUserProfileDto } from "src/core/dto/parents/parents.update.dto";
import { Parents } from "src/db/entities/Parents";
import { Repository } from "typeorm";
export declare class ParentsService {
    private readonly parentRepo;
    constructor(parentRepo: Repository<Parents>);
    getPagination({ pageSize, pageIndex, order, columnDef }: {
        pageSize: any;
        pageIndex: any;
        order: any;
        columnDef: any;
    }): Promise<{
        results: Parents[];
        total: number;
    }>;
    getByCode(parentCode: any): Promise<Parents>;
    updateProfile(parentCode: any, dto: UpdateParentUserProfileDto): Promise<Parents>;
    resetPassword(parentCode: any, dto: UpdateUserResetPasswordDto): Promise<Parents>;
    delete(parentCode: any): Promise<Parents>;
    approveAccessRequest(parentCode: any): Promise<Parents>;
}