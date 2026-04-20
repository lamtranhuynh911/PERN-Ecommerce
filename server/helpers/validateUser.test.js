// File: server/helpers/validateUser.test.js
const validateUser = require('./validateUser');

describe('Unit Test: Hàm validateUser', () => {
  // 🟢 Trường hợp đúng (Happy Path)
  it('Phải trả về true khi email và password hợp lệ', () => {
    const result = validateUser('test@email.com', '123456');
    expect(result).toBe(true);
  });

  // 🔴 Các trường hợp sai (Edge Cases)
  it('Phải trả về false khi email bị bỏ trống', () => {
    const result = validateUser('', '123456');
    expect(result).toBe(false);
  });

  it('Phải trả về false khi password ngắn hơn 6 ký tự', () => {
    const result = validateUser('test@email.com', '12345');
    expect(result).toBe(false);
  });

  it('Phải trả về false khi email không phải là chuỗi (string)', () => {
    const result = validateUser(12345, '123456'); // Truyền số thay vì chuỗi
    expect(result).toBe(false);
  });

  it('Phải trả về false khi password chỉ chứa khoảng trắng', () => {
    const result = validateUser('test@email.com', '      ');
    expect(result).toBe(false);
  });
});