import { ApiProperty } from '@nestjs/swagger';

export class GoogleLoginDto {
  @ApiProperty({ description: 'ID Token de Google enviado desde el cliente' })
  token: string;
}
