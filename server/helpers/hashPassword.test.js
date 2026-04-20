// File: server/helpers/hashPassword.test.js
const { hashPassword, comparePassword } = require('./hashPassword');

describe('Unit Test: Hàm hashPassword và comparePassword', () => {
  
  it('Phải mã hóa mật khẩu thành một chuỗi (hash) khác với mật khẩu gốc', async () => {
    const rawPassword = 'mySuperSecretPassword';
    const hashedPassword = await hashPassword(rawPassword);

    expect(hashedPassword).not.toBe(rawPassword);
    expect(hashedPassword).toBeDefined();
    expect(typeof hashedPassword).toBe('string');
  });

  it('Phải trả về true khi so sánh đúng mật khẩu gốc với chuỗi hash', async () => {
    const rawPassword = 'mySuperSecretPassword';
    const hashedPassword = await hashPassword(rawPassword);
    
    const isMatch = await comparePassword(rawPassword, hashedPassword);
    expect(isMatch).toBe(true);
  });

  it('Phải trả về false khi so sánh sai mật khẩu', async () => {
    const rawPassword = 'mySuperSecretPassword';
    const wrongPassword = 'wrongPassword123';
    const hashedPassword = await hashPassword(rawPassword);
    
    const isMatch = await comparePassword(wrongPassword, hashedPassword);
    expect(isMatch).toBe(false);
  });
});