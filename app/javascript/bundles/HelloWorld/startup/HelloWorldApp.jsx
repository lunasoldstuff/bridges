import React from 'react';
import { Provider } from 'react-redux';
import { IntlProvider, addLocaleData } from 'react-intl';
import ar from 'react-intl/locale-data/ar';
import de from 'react-intl/locale-data/de';
import en from 'react-intl/locale-data/en';
import ja from 'react-intl/locale-data/ja';
import pl from 'react-intl/locale-data/pl';
import { defaultLocale } from '../../../locales/default';
import { translations } from '../../../locales/translations';
import configureStore from '../store/helloWorldStore';
import HelloWorldContainer from '../containers/HelloWorldContainer';

addLocaleData([
  ...ar,
  ...de,
  ...en,
  ...ja,
  ...pl,
]);

const locale   = document.documentElement.lang || defaultLocale;
const messages = translations[locale] || translations[defaultLocale];

// See documentation for https://github.com/reactjs/react-redux.
// This is how you get props from the Rails view into the redux store.
// This code here binds your smart component to the redux store.
const HelloWorldApp = props => (
  <IntlProvider locale={locale} messages={messages}>
    <Provider store={configureStore(props)}>
      <HelloWorldContainer />
    </Provider>
  </IntlProvider>
);

export default HelloWorldApp;
