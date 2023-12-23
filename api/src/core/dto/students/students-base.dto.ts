import { ApiProperty } from "@nestjs/swagger";
import { Transform, Type } from "class-transformer";
import {
  ArrayNotEmpty,
  IsArray,
  IsDateString,
  IsEmail,
  IsIn,
  IsNotEmpty,
  IsNumberString,
  IsOptional,
  IsUppercase,
  ValidateNested,
} from "class-validator";

export class DefaultStudentUserDto {
  @ApiProperty()
  @IsNotEmpty()
  firstName: string;

  @ApiProperty()
  @IsOptional()
  middleInitial: string;

  @ApiProperty()
  @IsNotEmpty()
  lastName: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsNumberString()
  @Transform(({ obj, key }) => {
    return obj[key].toString();
  })
  mobileNumber: string;

  @ApiProperty()
  @IsOptional()
  lrn: string;

  @ApiProperty()
  @IsNotEmpty()
  cardNumber: string;

  @ApiProperty()
  @IsOptional()
  @IsEmail()
  email: string;

  @ApiProperty()
  @IsOptional()
  @IsDateString({ strict: true } as any)
  birthDate: Date;
  
  @ApiProperty()
  @IsOptional()
  @IsIn(["MALE", "FEMALE", "OTHERS"])
  @IsUppercase()
  gender: "MALE" | "FEMALE" | "OTHERS";

  @ApiProperty()
  @IsOptional()
  address: string;

  @ApiProperty()
  @IsOptional()
  courseId: string;

  @ApiProperty()
  @IsOptional()
  sectionId: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsNumberString()
  @Transform(({ obj, key }) => {
    return obj[key]?.toString();
  })
  departmentId: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsNumberString()
  @Transform(({ obj, key }) => {
    return obj[key]?.toString();
  })
  schoolYearLevelId: string;

  @ApiProperty()
  @IsNotEmpty()
  orgStudentId: string;
}