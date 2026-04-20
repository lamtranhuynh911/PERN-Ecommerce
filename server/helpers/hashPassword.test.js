// File: server/helpers/hashPassword.test.js
const { hashPassword, comparePassword } = require('./hashPassword');

describe('Unit Test: hashPassword and comparePassword', () => {
  
  it('Should hash a password into a different string', async () => {
    const rawPassword = 'mySuperSecretPassword';
    const hashedPassword = await hashPassword(rawPassword);

    expect(hashedPassword).not.toBe(rawPassword);
    expect(hashedPassword).toBeDefined();
    expect(typeof hashedPassword).toBe('string');
  });

  it('Should return true when comparing the correct original password with its hash', async () => {
    const rawPassword = 'mySuperSecretPassword';
    const hashedPassword = await hashPassword(rawPassword);
    
    const isMatch = await comparePassword(rawPassword, hashedPassword);
    expect(isMatch).toBe(true);
  });

  it('Should return false when comparing an incorrect password with its hash', async () => {
    const rawPassword = 'mySuperSecretPassword';
    const wrongPassword = 'wrongPassword123';
    const hashedPassword = await hashPassword(rawPassword);
    
    const isMatch = await comparePassword(wrongPassword, hashedPassword);
    expect(isMatch).toBe(false);
  });
});