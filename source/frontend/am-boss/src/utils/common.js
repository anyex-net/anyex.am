import defaultSettings from '@/settings';

const title = defaultSettings.title || 'Bitalk运营平台';

export function getPageTitle(pageTitle) {
  if (pageTitle) {
    return `${pageTitle} - ${title}`;
  }
  return `${title}`;
}

export function formatJson(filterVal, jsonData) {
  return jsonData.map(v => filterVal.map(j => {
    if (j.indexOf('.') > -1) {
      return v[j.split('.')[0]][j.split('.')[1]];
    } else {
      return v[j];
    }
  }));
}

