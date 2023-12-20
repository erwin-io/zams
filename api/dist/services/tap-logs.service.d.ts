import { CreateTapLogDto } from "src/core/dto/tap-logs/tap-logs.create.dto";
import { FirebaseProvider } from "src/core/provider/firebase/firebase-provider";
import { TapLogs } from "src/db/entities/TapLogs";
import { Users } from "src/db/entities/Users";
import { Repository, EntityManager } from "typeorm";
import { PusherService } from "./pusher.service";
export declare class TapLogsService {
    private readonly tapLogsRepo;
    private pusherService;
    private firebaseProvoder;
    constructor(tapLogsRepo: Repository<TapLogs>, pusherService: PusherService, firebaseProvoder: FirebaseProvider);
    getPagination({ pageSize, pageIndex, order, columnDef }: {
        pageSize: any;
        pageIndex: any;
        order: any;
        columnDef: any;
    }): Promise<{
        results: TapLogs[];
        total: number;
    }>;
    getByCode(tapLogId: any): Promise<TapLogs>;
    create(dto: CreateTapLogDto): Promise<TapLogs>;
    logNotification(users: Users[], referenceId: any, entityManager: EntityManager, title: string, description: string): Promise<void>;
    firebaseSendToDevice(token: any, title: any, description: any): Promise<void>;
}
