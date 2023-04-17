import http from '@/utils/http';
import { getSid, setSid, removeSid } from '@/utils/auth';
import { resetRouter } from '@/router';

const state = {
  sid: getSid(),
  name: '',
  avatar: 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif'
};

const mutations = {
  SET_SID: (state, sid) => {
    state.sid = sid;
  },
  SET_NAME: (state, name) => {
    state.name = name;
  },
  SET_AVATAR: (state, avatar) => {
    state.avatar = avatar;
  }
};

const actions = {
  // user login
  login({ commit }, userInfo) {
    const { username, password } = userInfo;
    return new Promise((resolve, reject) => {
      http({
        url: '/login/submit',
        method: 'post',
        data: {
          username: username.trim(),
          password: password
        }
      }).then(res => {
        const data = res;
        if (res.code === 200) {
          commit('SET_SID', data.object);
          commit('SET_NAME', username.trim());
          setSid(data.object);
        }
        resolve(data);
      }).catch(error => {
        reject(error);
      });
    });
  },

  // get info
  getInfo({ commit, state }) {
    return new Promise((resolve, reject) => {
      http({
        url: '/system/user/info',
        method: 'get'
      }).then(res => {
        const data = res;
        if (res.code === 200) {
          commit('SET_NAME', data.object.userName);
        } else {
          commit('SET_NAME', '');
          removeSid();
          resetRouter();
        }
        resolve(data);
      }).catch(error => {
        commit('SET_NAME', '');
        removeSid();
        resetRouter();
        reject(error);
      });
    });
  },

  // user logout
  logout({ commit, state }) {
    return new Promise((resolve, reject) => {
      http({
        url: '/logout',
        method: 'post'
      }).then(() => {
        commit('SET_SID', '');
        removeSid();
        resetRouter();
        resolve();
      }).catch(error => {
        reject(error);
      });
    });
  }
};

export default {
  namespaced: true,
  state,
  mutations,
  actions
};

