<p align="center"><img src="logo.png"></p>

<p align="center">
    <a href="https://www.npmjs.com/package/ngx-promise-buttons">
        <img src="https://img.shields.io/npm/v/ngx-promise-buttons.svg"
             alt="npm version"></a>
    <a href="https://lbesson.mit-license.org">
        <img alt="MIT license"
             src="https://img.shields.io/badge/License-MIT-blue.svg">
    </a>
</p>


*ngx-promise-buttons* is a simple Angular library that lets you add a loading indicator to a button of your choice. It is built as a **standalone** directive and works with modern Angular (tested up to Angular 22). Check out the [demo](http://meysamsahragard.github.io/ngx-promise-buttons/#demo)!

[Bug-reports or feature request](https://github.com/meysamsahragard/ngx-promise-buttons/issues) as well as any other kind of **feedback is highly welcome!**

## Why this package instead of `angular2-promise-buttons`?

This library is a maintained fork of [`angular2-promise-buttons`](https://github.com/johannesjo/angular2-promise-buttons). The original package stopped keeping pace with Angular’s platform changes, so apps on newer Angular versions hit friction: outdated peer/tooling support, NgModule-only setup (`forRoot`), and little ongoing maintenance for current releases.

**Use `ngx-promise-buttons` when you need:**

- Support for modern Angular (upgraded through Angular 22)
- A standalone API via `provideNgxPromiseButtons()` and `PromiseBtnDirective` (no NgModule required)
- An actively maintained drop-in for the same promise/boolean/subscription button loading behavior

If you are still on a very old Angular / View Engine setup and already depend on `angular2-promise-buttons`, you can keep using that package. For Angular 13+ projects—especially standalone apps—prefer this one.

## Getting started
Install it via npm:
```
npm install ngx-promise-buttons -S
```

Provide optional config in your application bootstrap:
```typescript
import { bootstrapApplication } from '@angular/platform-browser';
import { provideNgxPromiseButtons } from 'ngx-promise-buttons';
import { AppComponent } from './app/app.component';

bootstrapApplication(AppComponent, {
  providers: [
    provideNgxPromiseButtons({ handleCurrentBtnOnly: true }),
  ],
});
```

Import the directive in your standalone component and pass a promise (or boolean / subscription):
```typescript
import { Component } from '@angular/core';
import { PromiseBtnDirective } from 'ngx-promise-buttons';

@Component({
  selector: 'app-example',
  imports: [PromiseBtnDirective],
  template: `
    <button (click)="someAction()"
       [promiseBtn]="promiseSetBySomeAction">Click me to spin!</button>
  `,
})
export class ExampleComponent {
  promiseSetBySomeAction: Promise<unknown>;

  // some example async action, but this works with any promise
  someAction() {
    this.promiseSetBySomeAction = new Promise((resolve) => {
      setTimeout(resolve, 2000);
    });
  }
}
```

## Styling the button
To give you maximum flexibility there are no base styles coming with the directive, but it is easy to fix that! There are lots of free css-spinners out there. Just find one of your liking and add the css to your global stylesheet.

**Resources:**
* http://cssload.net/
* http://projects.lukehaas.me/css-loaders/
* http://tobiasahlin.com/spinkit/

There are selectors you can use to style. There is the `.is-loading` class on the button, which is set, when the promise is pending and there is the `<span class="btn-spinner"></span>` element inside the button.


## Configuration
You can pass a config object to `provideNgxPromiseButtons`:
```typescript
provideNgxPromiseButtons({
  // your custom config goes here
  spinnerTpl: '<span class="btn-spinner"></span>',
  // disable buttons when promise is pending
  disableBtn: true,
  // the class used to indicate a pending promise
  btnLoadingClass: 'is-loading',
  // only disable and show is-loading class for clicked button,
  // even when they share the same promise
  handleCurrentBtnOnly: false,
  // optional minimum time (ms) the spinner stays visible
  minDuration: null,
});
```

`provideNgxPromiseButtons()` is optional — omit it if the defaults are fine.

## Using observables
When you're using the directive with observables make sure to pass a subscription to the directive rather than an observable directly.
```typescript
const FAKE_FACTORY = {
  initObservable: (): Observable<number> => {
    return new Observable(observer => {
      setTimeout(() => {
        observer.complete();
      }, 4000);
    });
  }
};

// DO:
const observable = FAKE_FACTORY.initObservable();
this.passedToDirective = observable.subscribe(
// ...
);

// DON'T DO:
const observable = FAKE_FACTORY.initObservable();
this.passedToDirective = observable;

```

## Using booleans
Is now also possible.
```html
<button (click)="someAction()"
   [promiseBtn]="isShowBoolean">Click!</button>
```
## Contributing
Contribution guidelines: [CONTRIBUTING.md](https://github.com/meysamsahragard/ngx-promise-buttons/blob/master/CONTRIBUTING.md)
