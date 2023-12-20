import { ApiProperty } from "@nestjs/swagger";
import { IsNotEmpty } from "class-validator";

export class DefaultMachineDto {
  @ApiProperty()
  @IsNotEmpty()
  description: string;

  @ApiProperty()
  @IsNotEmpty()
  path: string;
  
  @ApiProperty()
  @IsNotEmpty()
  domain: string;
}
