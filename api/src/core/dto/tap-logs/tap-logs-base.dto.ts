import { ApiProperty } from "@nestjs/swagger";
import { Transform, Type } from "class-transformer";
import {
  ArrayNotEmpty,
  IsArray,
  IsBooleanString,
  IsIn,
  IsNotEmpty,
  IsNumberString,
  IsOptional,
  IsUppercase,
  ValidateNested,
} from "class-validator";

export class DefaultTapLogDto {
  @ApiProperty()
  @IsNotEmpty()
  sender: string;
  
  @ApiProperty()
  @IsOptional()
  @IsIn(["LOG IN", "LOG OUT"])
  @IsUppercase()
  status: "LOG IN" | "LOG OUT";

  @ApiProperty()
  @IsNotEmpty()
  cardNumber: string;
  
  @ApiProperty()
  @IsOptional()
  @IsIn(["STUDENT", "EMPLOYEE"])
  @IsUppercase()
  userType: "STUDENT" | "EMPLOYEE";

  @ApiProperty()
  @IsNotEmpty()
  dateTime: Date;
}