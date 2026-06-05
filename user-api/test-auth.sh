#!/usr/bin/env bash

# Colores para la consola
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

API_URL="http://localhost:3000"
TEST_EMAIL="tester_$(date +%s)@example.com"
TEST_PASSWORD="SuperSecretPassword123"
TEST_NAME="Usuario de Pruebas Auth"

echo -e "${CYAN}====================================================${NC}"
echo -e "${CYAN}   SCRIPT DE PRUEBA DE AUTENTICACIÓN PARA USER-API  ${NC}"
echo -e "${CYAN}====================================================${NC}"

# 1. Prueba 1: Conectividad de la API
echo -n "Prueba 1: Verificando conectividad con la API... "
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/api")
if [ "$STATUS_CODE" -eq 200 ] || [ "$STATUS_CODE" -eq 404 ]; then
  echo -e "${GREEN}[PASS] (Código $STATUS_CODE)${NC}"
else
  echo -e "${RED}[FAIL] (El servidor no responde en $API_URL)${NC}"
  echo -e "${YELLOW}Por favor, asegúrate de que NestJS esté corriendo (npm run start:dev)${NC}"
  exit 1
fi

# 2. Prueba 2: Denegación de Acceso Sin Token
echo -n "Prueba 2: Intentando acceder a GET /users sin Token JWT... "
RESPONSE=$(curl -s -w "\n%{http_code}" -X GET "$API_URL/users")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 401 ]; then
  echo -e "${GREEN}[PASS] (Código $HTTP_CODE - Acceso Denegado)${NC}"
  echo -e "   Respuesta de la API: $BODY"
else
  echo -e "${RED}[FAIL] (Código $HTTP_CODE - Se esperaba 401)${NC}"
  exit 1
fi

# 3. Prueba 3: Intento de Login Fallido
echo -n "Prueba 3: Intentando login con credenciales inválidas... "
BAD_LOGIN_BODY=$(cat <<EOF
{
  "email": "invalid_email@doesnotexist.com",
  "password": "wrongpassword"
}
EOF
)
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  -d "$BAD_LOGIN_BODY" \
  "$API_URL/auth/login")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 401 ]; then
  echo -e "${GREEN}[PASS] (Código $HTTP_CODE - Login Rechazado)${NC}"
  echo -e "   Respuesta de la API: $BODY"
else
  echo -e "${RED}[FAIL] (Código $HTTP_CODE - Se esperaba 401)${NC}"
  exit 1
fi

# 4. Prueba 4: Registro de Usuario de Pruebas
echo -n "Prueba 4: Registrando nuevo usuario de pruebas... "
REGISTER_BODY=$(cat <<EOF
{
  "name": "$TEST_NAME",
  "email": "$TEST_EMAIL",
  "password": "$TEST_PASSWORD",
  "role": "client"
}
EOF
)
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  -d "$REGISTER_BODY" \
  "$API_URL/users")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 201 ]; then
  echo -e "${GREEN}[PASS] (Código $HTTP_CODE - Creado exitosamente)${NC}"
  echo -e "   Usuario registrado: $TEST_EMAIL"
else
  echo -e "${RED}[FAIL] (Código $HTTP_CODE - Se esperaba 201)${NC}"
  echo -e "   Detalle: $BODY"
  exit 1
fi

# 5. Prueba 5: Login Exitoso
echo -n "Prueba 5: Intentando login con las credenciales registradas... "
LOGIN_BODY=$(cat <<EOF
{
  "email": "$TEST_EMAIL",
  "password": "$TEST_PASSWORD"
}
EOF
)
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  -d "$LOGIN_BODY" \
  "$API_URL/auth/login")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 201 ]; then
  echo -e "${GREEN}[PASS] (Código $HTTP_CODE - Login exitoso)${NC}"
  JWT_TOKEN=$(echo "$BODY" | jq -r '.access_token')
  echo -e "${YELLOW}   Token JWT Obtenido:${NC} ${JWT_TOKEN:0:30}...[recortado]...${JWT_TOKEN: -10}"
else
  echo -e "${RED}[FAIL] (Código $HTTP_CODE - Se esperaba 201)${NC}"
  echo -e "   Detalle: $BODY"
  exit 1
fi

# 6. Prueba 6: Acceso Autorizado con JWT
echo -n "Prueba 6: Intentando acceder a GET /users enviando el Token JWT... "
RESPONSE=$(curl -s -w "\n%{http_code}" -X GET \
  -H "Authorization: Bearer $JWT_TOKEN" \
  "$API_URL/users")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
  echo -e "${GREEN}[PASS] (Código $HTTP_CODE - Acceso Autorizado)${NC}"
  echo -e "${YELLOW}   Lista de usuarios recibida (formateada con jq):${NC}"
  echo "$BODY" | jq '.'
else
  echo -e "${RED}[FAIL] (Código $HTTP_CODE - Se esperaba 200)${NC}"
  echo -e "   Detalle: $BODY"
  exit 1
fi

# 7. Prueba 7: Cierre de Sesión en el Servidor (Logout Real)
echo -n "Prueba 7: Ejecutando Logout en la API para invalidar el token... "
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  -H "Authorization: Bearer $JWT_TOKEN" \
  "$API_URL/auth/logout")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
  echo -e "${GREEN}[PASS] (Código $HTTP_CODE - Logout exitoso)${NC}"
  echo -e "   Respuesta de la API: $BODY"
else
  echo -e "${RED}[FAIL] (Código $HTTP_CODE - Se esperaba 200)${NC}"
  echo -e "   Detalle: $BODY"
  exit 1
fi

echo -n "   Re-intentando acceder a GET /users usando el MISMO token ya invalidado... "
RESPONSE=$(curl -s -w "\n%{http_code}" -X GET \
  -H "Authorization: Bearer $JWT_TOKEN" \
  "$API_URL/users")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 401 ]; then
  echo -e "${GREEN}[PASS] (Código $HTTP_CODE - Acceso Denegado por Token Revocado)${NC}"
  echo -e "   Respuesta de la API: $BODY"
else
  echo -e "${RED}[FAIL] (Código $HTTP_CODE - Se esperaba 401 por token revocado)${NC}"
  echo -e "   Detalle: $BODY"
  exit 1
fi

echo -e "${CYAN}====================================================${NC}"
echo -e "${GREEN}  ¡TODAS LAS PRUEBAS DE AUTENTICACIÓN PASARON!      ${NC}"
echo -e "${CYAN}====================================================${NC}"
