import { CreateDepartmentDto } from "src/core/dto/ueserFirebaseTokens/ueserFirebaseTokens.create.dto";
import { UpdateDepartmentDto } from "src/core/dto/ueserFirebaseTokens/ueserFirebaseTokens.update.dto";
import { UserFirebaseToken } from "src/db/entities/UserFirebaseToken";
import { Repository } from "typeorm";
export declare class UserFirebaseTokentService {
    private readonly ueserFirebaseTokensRepo;
    constructor(ueserFirebaseTokensRepo: Repository<UserFirebaseToken>);
    getByUserDevice(userId: any): Promise<UserFirebaseToken>;
    create(dto: CreateDepartmentDto): Promise<UserFirebaseToken>;
    update(ueserFirebaseTokenCode: any, dto: UpdateDepartmentDto): Promise<UserFirebaseToken>;
    delete(ueserFirebaseTokenCode: any): Promise<UserFirebaseToken>;
}
