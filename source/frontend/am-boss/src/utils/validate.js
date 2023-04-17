// 验证是否是[0-9999]的小数
export function isBtnZeroToThousand(rule, value, callback) {
  if (!value) {
    return callback();
  }
  setTimeout(() => {
    if (!Number(value)) {
      callback(new Error('请输入大于0并小于10000的数字'));
    } else {
      if (value < 0 || value >= 10000) {
        callback(new Error('请输入大于0并小于10000的数字'));
      } else {
        callback();
      }
    }
  }, 100);
}

export function checkNum(rule, value, callback) {
  const reg = /(^(-)?[0-9]([0-9]+)?(\.[0-9]{1,4})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)/;
  if (!value) {
    return callback();
  } else if (!reg.test(value)) {
    return callback(new Error('请填写数字,最多4位小数'));
  } else {
    callback();
  }
}
export function checkNumTwo(rule, value, callback) {
  const reg = /(^(-)?[0-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)/;
  if (!value) {
    return callback();
  } else if (!reg.test(value)) {
    return callback(new Error('请填写数字,最多2位小数'));
  } else {
    callback();
  }
}

// 验证是否整数
export function isInteger(rule, value, callback) {
  if (!value) {
    return callback();
  }
  setTimeout(() => {
    if (!Number(value)) {
      callback(new Error('请输入正整数'));
    } else {
      const re = /^[0-9]*[1-9][0-9]*$/;
      const rsCheck = re.test(value);
      if (!rsCheck) {
        callback(new Error('请输入正整数'));
      } else {
        callback();
      }
    }
  }, 0);
}
export function isNum(rule, value, callback) {
  if (!value) {
    return callback();
  }
  setTimeout(() => {
    if (!Number(value)) {
      callback(new Error('请输入整数'));
    } else {
      const re = /^-?[1-9]\d*$/;
      const rsCheck = re.test(value);
      if (!rsCheck) {
        callback(new Error('请输入整数'));
      } else {
        callback();
      }
    }
  }, 0);
}
