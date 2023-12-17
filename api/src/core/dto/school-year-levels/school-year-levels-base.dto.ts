import { ApiProperty } from "@nestjs/swagger";
import { Transform, Type } from "class-transformer";
import {
  ArrayNotEmpty,
  IsArray,
  IsBooleanString,
  IsNotEmpty,
  IsNumberString,
  IsOptional,
  ValidateNested,
} from "class-validator";

export class DefaultSchoolYearLevelDto {
  @ApiProperty()
  @IsNotEmpty()
  name: string;

  @ApiProperty({
    default: false,
    type: Boolean
  })
  @IsNotEmpty()
  @Type(() => Boolean)
  @Transform(({ obj, key }) => {
    return obj[key].toString();
  })
  @IsBooleanString()
  canSelectCourses = false;
}