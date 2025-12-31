import {BrowserModule} from '@angular/platform-browser';
import {FormsModule} from '@angular/forms';
import {NgModule} from '@angular/core';

import {AppComponent} from './app.component';
import {NgxPromiseButtonModule} from "../../../ngx-promise-buttons/src";

@NgModule({
  declarations: [
    AppComponent,
  ],
  imports: [
    BrowserModule,
    FormsModule,
    NgxPromiseButtonModule
      .forRoot({
        // handleCurrentBtnOnly: true,
      }),
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {
}
