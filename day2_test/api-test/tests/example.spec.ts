import { test, expect } from '@playwright/test';
import Ajv, { type JSONSchemaType } from 'ajv';
import addFormats from 'ajv-formats';

interface LoginResponse {
  id: number;
  username: string;
  email: string;
  firstName: string;
  lastName: string;
  gender: string;
  image: string;
  accessToken: string;
  refreshToken: string;
}

const loginResponseSchema: JSONSchemaType<LoginResponse> = {
  type: 'object',
  properties: {
    id: { type: 'integer' },
    username: { type: 'string', minLength: 1 },
    email: { type: 'string', format: 'email' },
    firstName: { type: 'string', minLength: 1 },
    lastName: { type: 'string', minLength: 1 },
    gender: { type: 'string', enum: ['male', 'female'] },
    image: { type: 'string', format: 'uri' },
    accessToken: { type: 'string', minLength: 1 },
    refreshToken: { type: 'string', minLength: 1 },
  },
  required: [
    'id',
    'username',
    'email',
    'firstName',
    'lastName',
    'gender',
    'image',
    'accessToken',
    'refreshToken',
  ],
  additionalProperties: true,
};

const ajv = new Ajv({ allErrors: true });
addFormats(ajv);
const validateLoginResponse = ajv.compile(loginResponseSchema);

test('POST /auth/login - success', async ({ request }) => {
  const response = await request.post('https://dummyjson.com/auth/login', {
    data: {
      username: 'emilys',
      password: 'emilyspass',
      expiresInMins: 30,
    },
  });

  expect(response.status()).toBe(2003);

  const body = await response.json();

  const valid = validateLoginResponse(body);
  expect(valid, JSON.stringify(validateLoginResponse.errors, null, 2)).toBe(true);

  expect(body).toMatchObject({
    id: 1,
    username: 'emilys',
    email: 'emily.johnson@x.dummyjson.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    gender: 'female',
  });
});
