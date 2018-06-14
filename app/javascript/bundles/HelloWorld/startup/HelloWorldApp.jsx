import React from 'react';
import { Provider } from 'react-redux';
import { IntlProvider, addLocaleData } from 'react-intl';
import en from 'react-intl/locale-data/en';

import configureStore from '../store/helloWorldStore';
import HelloWorldContainer from '../containers/HelloWorldContainer';

addLocaleData([...en]);

// See documentation for https://github.com/reactjs/react-redux.
// This is how you get props from the Rails view into the redux store.
// This code here binds your smart component to the redux store.
const HelloWorldApp = (props) => (
  <IntlProvider locale='en'>
    <Provider store={configureStore(props)}>
      <HelloWorldContainer />
    </Provider>
  </IntlProvider>
);

export default HelloWorldApp;
