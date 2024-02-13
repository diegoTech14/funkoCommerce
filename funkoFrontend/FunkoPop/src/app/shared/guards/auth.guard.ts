import { CanActivateFn, Router } from '@angular/router';
import { inject } from '@angular/core';
import { AuthService } from '../services/auth.service';

export const authGuard: CanActivateFn = (route, state) => {
  const srvAuth = inject(AuthService);
  const router = inject(Router);
  if(srvAuth.issLogged()){
    console.log(route.data);
    if(Object.keys(route.data).length !== 0 &&
      route.data['roles'].indexOf(srvAuth.valorUserActual.rol)=== -1){
        router.navigate(['/']);
        return false;
      }
    return true;
  }
  srvAuth.logout();
  router.navigate(['/login']);
  return false;
};
