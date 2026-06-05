import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from '../users/users.module';
import { JwtModule } from '@nestjs/jwt';
import { RevokedToken } from './entities/revoked-token.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([RevokedToken]),
    forwardRef(() => UsersModule),
    JwtModule.register({
      global: true,
      secret: 'super-secret-key-12345',
      signOptions: { expiresIn: '24h' },
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService],
  exports: [AuthService],
})
export class AuthModule {}
