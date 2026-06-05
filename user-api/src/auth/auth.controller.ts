import { Controller, Post, Body, HttpCode, HttpStatus, UseGuards, Req } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { ApiTags, ApiCreatedResponse, ApiBearerAuth } from '@nestjs/swagger';
import { AuthGuard } from './auth.guard';
import * as express from 'express';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  @HttpCode(HttpStatus.CREATED)
  @ApiCreatedResponse({ description: 'Inicio de sesión exitoso. Retorna un JWT token.' })
  async login(@Body() loginDto: LoginDto) {
    return this.authService.signIn(loginDto.email, loginDto.password);
  }

  @Post('logout')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  @ApiCreatedResponse({ description: 'Cierre de sesión exitoso. Invalida el token en el servidor.' })
  async logout(@Req() req: express.Request) {
    const token = req['token'];
    await this.authService.revokeToken(token);
    return { message: 'Sesión cerrada correctamente' };
  }
}
