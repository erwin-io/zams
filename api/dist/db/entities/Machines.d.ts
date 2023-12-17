import { Users } from "./Users";
import { Schools } from "./Schools";
import { TapLogs } from "./TapLogs";
export declare class Machines {
    machineId: string;
    machineCode: string | null;
    description: string;
    path: string;
    domain: string;
    createdDate: Date;
    updatedDate: Date | null;
    active: boolean;
    createdByUser: Users;
    school: Schools;
    updatedByUser: Users;
    tapLogs: TapLogs[];
}
