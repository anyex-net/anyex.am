const getters = {
  sidebar: state => state.app.sidebar,
  device: state => state.app.device,
  sid: state => state.user.sid,
  avatar: state => state.user.avatar,
  name: state => state.user.name,
  visitedViews: state => state.tagsView.visitedViews,
  cachedViews: state => state.tagsView.cachedViews,
  ossUrl: state => state.settings.ossUrl
};
export default getters;
