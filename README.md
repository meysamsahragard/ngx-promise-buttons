# ngx-promise-buttons

Add a loading spinner to Angular buttons from a **promise**, **RxJS subscription**, or **boolean**. Standalone directive for modern Angular (tested through Angular 22).

[Live demo](https://meysamsahragard.github.io/ngx-promise-buttons/) · [npm](https://www.npmjs.com/package/ngx-promise-buttons) · [Changelog](https://github.com/meysamsahragard/ngx-promise-buttons/blob/master/CHANGELOG.md)

<p align="center">
  <img src="logo.png" alt="ngx-promise-buttons logo" width="280">
</p>

<p align="center">
  <a href="https://www.npmjs.com/package/ngx-promise-buttons"><img src="https://img.shields.io/npm/v/ngx-promise-buttons.svg" alt="npm version"></a>
  <a href="https://www.npmjs.com/package/ngx-promise-buttons"><img src="https://img.shields.io/npm/dm/ngx-promise-buttons.svg" alt="npm downloads"></a>
  <a href="https://www.npmjs.com/package/ngx-promise-buttons"><img src="https://img.shields.io/npm/dt/ngx-promise-buttons.svg" alt="npm total downloads"></a>
  <a href="https://lbesson.mit-license.org"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="MIT license"></a>
  <a href="https://angular.dev/"><img src="https://img.shields.io/badge/Angular-9%E2%80%9322-dd0031" alt="Angular 9 to 22"></a>
  <a href="https://www.typescriptlang.org/"><img src="https://img.shields.io/badge/TypeScript-ready-3178c6" alt="TypeScript"></a>
</p>

## Install

```bash
npm install ngx-promise-buttons
```

## Quick start

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

  someAction() {
    this.promiseSetBySomeAction = new Promise((resolve) => {
      setTimeout(resolve, 2000);
    });
  }
}
```

Optional global config at bootstrap:

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

## Why this package instead of `angular2-promise-buttons`?

This library is a maintained fork of [`angular2-promise-buttons`](https://github.com/johannesjo/angular2-promise-buttons). The original package stopped keeping pace with Angular’s platform changes, so apps on newer Angular versions hit friction: outdated peer/tooling support, NgModule-only setup (`forRoot`), and little ongoing maintenance for current releases.

**Use `ngx-promise-buttons` when you need:**

- Support for modern Angular (upgraded through Angular 22)
- A standalone API via `provideNgxPromiseButtons()` and `PromiseBtnDirective` (no NgModule required)
- An actively maintained drop-in for the same promise/boolean/subscription button loading behavior

If you are still on a very old Angular / View Engine setup and already depend on `angular2-promise-buttons`, you can keep using that package. For Angular 13+ projects—especially standalone apps—prefer this one.

## Works with

| Input | Behavior |
|--------|----------|
| `Promise` | Spinner while pending |
| RxJS `Subscription` | Spinner until unsubscribed/complete |
| `boolean` | Spinner while `true` |

Compatible with Angular **9-22**, standalone components, and TypeScript.

## Styling the button

No base styles ship with the directive, so you can match your design system. Add any CSS spinner to your global stylesheet.

**Resources:**
- https://cssload.net/
- https://projects.lukehaas.me/css-loaders/
- https://tobiasahlin.com/spinkit/

Selectors:
- `.is-loading` on the button while pending
- `<span class="btn-spinner"></span>` inside the button

## Configuration

Pass a config object to `provideNgxPromiseButtons`:

```typescript
provideNgxPromiseButtons({
  spinnerTpl: '<span class="btn-spinner"></span>',
  disableBtn: true,
  btnLoadingClass: 'is-loading',
  handleCurrentBtnOnly: false,
  minDuration: null,
});
```

`provideNgxPromiseButtons()` is optional — omit it if the defaults are fine.

## Using observables

Pass a **subscription** to the directive, not the observable itself.

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

// DON'T:
const observable = FAKE_FACTORY.initObservable();
this.passedToDirective = observable;
```

## Using booleans

```html
<button (click)="someAction()"
   [promiseBtn]="isShowBoolean">Click!</button>
```

## Links

- Demo: https://meysamsahragard.github.io/ngx-promise-buttons/
- npm: https://www.npmjs.com/package/ngx-promise-buttons
- Issues: https://github.com/meysamsahragard/ngx-promise-buttons/issues
- Changelog: https://github.com/meysamsahragard/ngx-promise-buttons/blob/master/CHANGELOG.md

## Contributing

Contribution guidelines: [CONTRIBUTING.md](https://github.com/meysamsahragard/ngx-promise-buttons/blob/master/CONTRIBUTING.md)
