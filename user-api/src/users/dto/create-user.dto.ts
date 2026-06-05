import { ApiProperty } from '@nestjs/swagger';
import { UserRole } from '../entities/user.entity';

export class CreateUserDto {
  @ApiProperty({ description: 'Nombre completo del usuario' })
  name: string;

  @ApiProperty({ description: 'Correo electrónico del usuario' })
  email: string;

  @ApiProperty({ enum: UserRole, default: UserRole.CLIENT, required: false, description: 'Rol jerárquico del usuario' })
  role?: UserRole;

  @ApiProperty({ description: 'Contraseña de acceso del usuario' })
  password: string;
}
