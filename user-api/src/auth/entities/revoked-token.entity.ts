import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';

@Entity()
export class RevokedToken {
  @PrimaryGeneratedColumn()
  @ApiProperty({ description: 'ID autogenerado del token revocado' })
  id: number;

  @Column({ unique: true })
  @ApiProperty({ description: 'El token JWT invalidado' })
  token: string;

  @CreateDateColumn()
  @ApiProperty({ description: 'Fecha y hora en la que se revocó el token' })
  createdAt: Date;
}
