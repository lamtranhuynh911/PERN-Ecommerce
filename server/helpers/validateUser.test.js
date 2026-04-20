// File: server/helpers/validateUser.test.js
const validateUser = require('./validateUser');

describe('Unit Test: validateUser', () => {
  //Trường hợp đúng (Happy Path)
  it('Should return true when email and password are valid', () => {
    const result = validateUser('test@email.com', '123456');
    expect(result).toBe(true);
  });

  //Các trường hợp sai (Edge Cases)
  it('Should return false when email is empty', () => {
    const result = validateUser('', '123456');
    expect(result).toBe(false);
  });

  it('Should return false when password is shorter than 6 characters', () => {
    const result = validateUser('test@email.com', '12345');
    expect(result).toBe(false);
  });

  it('Should return false when email is not a string', () => {
    const result = validateUser(12345, '123456'); // Truyền số thay vì chuỗi
    expect(result).toBe(false);
  });

  it('Should return false when password only contains whitespace', () => {
    const result = validateUser('test@email.com', '      ');
    expect(result).toBe(false);
  });
});