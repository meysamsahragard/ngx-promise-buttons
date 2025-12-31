import { bootstrapApplication } from '@angular/platform-browser';
import {AppComponent} from "./app/app.component";
import {provideNgxPromiseButtons} from "../../ngx-promise-buttons/src";

bootstrapApplication(AppComponent, {
  providers: [
    provideNgxPromiseButtons({
      // handleCurrentBtnOnly: true
    }),
  ],
});
