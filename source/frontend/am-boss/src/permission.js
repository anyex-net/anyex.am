import router from './router';
import store from './store';
import { Message } from 'element-ui';
import NProgress from 'nprogress'; // progress bar
import 'nprogress/nprogress.css'; // progress bar style
import { getSid } from '@/utils/auth'; // get token from cookie
import { getPageTitle } from '@/utils/common';

NProgress.configure({ showSpinner: false }); // NProgress Configuration

const whiteList = ['/login']; // no redirect whitelist

router.beforeEach(async(to, from, next) => {
  // start progress bar
  NProgress.start();

  // set page title
  document.title = getPageTitle(to.meta.title);

  // determine whether the user has logged in
  const hasSid = getSid();

  if (hasSid) {
    if (to.path === '/login') {
      // if is logged in, redirect to the home page
      next({ path: '/' });
      NProgress.done();
    } else {
      const hasGetUserInfo = store.getters.name;
      if (hasGetUserInfo) {
        next();
      } else {
        // get info
        store.dispatch('user/getInfo').then((res) => {
          if (res.code === 200) {
            next();
          } else {
            Message.error(res.message || 'Has Error');
            next('/login');
            NProgress.done();
          }
        }).catch((error) => {
          Message.error(error || 'Has Error');
          next('/login');
          NProgress.done();
        });
      }
    }
  } else {
    // has no login
    if (whiteList.indexOf(to.path) !== -1) {
      // in the free login whitelist, go directly
      next();
    } else {
      // other pages that do not have permission to access are redirected to the login page.
      next('/login');
      NProgress.done();
    }
  }
});

router.afterEach(() => {
  // finish progress bar
  NProgress.done();
});
