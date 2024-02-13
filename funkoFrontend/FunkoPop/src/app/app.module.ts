import { NgModule } from '@angular/core'
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './login/login.component';
import { FeedComponent } from './components/feed/feed.component';
import { FunkoDetailComponent } from './components/funko-detail/funko-detail.component';
import { ShoopingCartComponent } from './shooping-cart/shooping-cart.component';
import { FontAwesomeModule, FaIconLibrary } from '@fortawesome/angular-fontawesome';
import { faCartPlus, faPencil, faTruckRampBox, faStar, faTrash, faShoppingBag, faUser, faBoxesPacking, faPlus, faList, faListCheck, faSearch } from '@fortawesome/free-solid-svg-icons';
import { NavBarComponent } from './nav-bar/nav-bar.component';
import { fas } from '@fortawesome/free-solid-svg-icons';
import {NgxPaginationModule} from 'ngx-pagination';
import { HttpClientModule } from '@angular/common/http';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { CartComponent } from './components/cart/cart.component';
import { PayComponent } from './components/pay/pay.component';
import { ReactiveFormsModule } from '@angular/forms';
import { FunkoCrudComponent } from './components/funko-crud/funko-crud.component';
import { SidebarComponent } from './components/sidebar/sidebar.component';
import { IndexComponent } from './components/index/index.component';
import { FooterComponent } from './footer/footer.component';
import { CategoriesComponent } from './components/categories/categories.component';
import { RegisterComponent } from './register/register.component';
import { ChangePasswComponent } from './change-passw/change-passw.component';
import { UserCrudComponent } from './components/user-crud/user-crud.component';
import { Error403Component } from './components/error403/error403.component';


@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    FeedComponent,
    FunkoDetailComponent,
    ShoopingCartComponent,
    NavBarComponent,
    DashboardComponent,
    CartComponent,
    PayComponent,
    FunkoCrudComponent,
    SidebarComponent,
    IndexComponent,
    FooterComponent,
    CategoriesComponent,
    RegisterComponent,
    ChangePasswComponent,
    UserCrudComponent,
    Error403Component
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FontAwesomeModule,
    HttpClientModule,
    NgxPaginationModule,
    ReactiveFormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {
  constructor(libreria: FaIconLibrary) {
    libreria.addIconPacks(fas)
    libreria.addIcons(faCartPlus, faPencil, faTruckRampBox, faStar, faTrash, faShoppingBag, faUser, faBoxesPacking, faPlus, faList, faListCheck);
  }
}
