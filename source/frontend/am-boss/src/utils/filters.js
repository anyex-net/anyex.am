const filters = {
  keepNumTwo(value) {
    value = Number(value);
    return value.toFixed(2);
  },
  addPercentage(value) {
    return value + '%';
  }
};
export default filters;
