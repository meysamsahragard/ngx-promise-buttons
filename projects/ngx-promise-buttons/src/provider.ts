import { InjectionToken, EnvironmentProviders, makeEnvironmentProviders, Optional, SkipSelf, inject } from '@angular/core';
import { PromiseBtnConfig } from './promise-btn-config';

export const USER_CFG = new InjectionToken<PromiseBtnConfig>('Promise Button Config');

export const DEFAULT_CONFIG: PromiseBtnConfig = {
  // default values
};

export function provideNgxPromiseButtons(config: PromiseBtnConfig = DEFAULT_CONFIG): EnvironmentProviders {
  return makeEnvironmentProviders([
    { provide: USER_CFG, useValue: { ...DEFAULT_CONFIG, ...config } }
  ]);
}
