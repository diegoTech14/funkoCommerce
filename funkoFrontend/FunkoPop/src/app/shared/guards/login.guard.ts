import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

export const loginGuard: CanActivateFn = (route, state) => {
  const authsrv = inject(AuthService);
  const router = inject(Router);
  if (authsrv.issLogged()) {
    router.navigate(['/index']);
  }
  return !authsrv.issLogged();
};