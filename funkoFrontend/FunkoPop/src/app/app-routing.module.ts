import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { FeedComponent } from './components/feed/feed.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { CartComponent } from './components/cart/cart.component';
import { PayComponent } from './components/pay/pay.component';
import { FunkoCrudComponent } from './components/funko-crud/funko-crud.component';
import { IndexComponent } from './components/index/index.component';
import { CategoriesComponent } from './components/categories/categories.component';
import { RegisterComponent } from './register/register.component';
import { ChangePasswComponent } from './change-passw/change-passw.component';
import { UserCrudComponent } from './components/user-crud/user-crud.component';
import { authGuard } from './shared/guards/auth.guard';
import { Roles } from './shared/models/roles';
const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { path: 'feed', component: FeedComponent },
  {
    path: 'dashboard', component: DashboardComponent,
    canActivate: [authGuard],
    data: {
      roles: [Roles.Admin]
    }
  },
  {
    path: 'cart', component: CartComponent,
    canActivate: [authGuard],
    data: {
      roles: [Roles.Admin, Roles.Person]
    }

  },
  {
    path: 'paypage', component: PayComponent,
    canActivate: [authGuard],
    data: {
      roles: [Roles.Admin, Roles.Person]
    }
  },
  {
    path: 'funkocrud', component: FunkoCrudComponent,
    canActivate: [authGuard],
    data: {
      roles: [Roles.Admin]
    }
  },
  { path: '', component: IndexComponent },
  {
    path: 'categorycrud', component: CategoriesComponent,
    canActivate: [authGuard],
    data: {
      roles: [Roles.Admin]
    }
  },
  { path: 'register', component: RegisterComponent },
  {
    path: 'changePassw', component: ChangePasswComponent,
    canActivate: [authGuard],
    data: {
      roles: [Roles.Admin, Roles.Person]
    }
  },
  {
    path: 'usercrud', component: UserCrudComponent,
    canActivate: [authGuard],
    data: {
      roles: [Roles.Admin]
    }
  },
  { path: '**', redirectTo: '/index' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
