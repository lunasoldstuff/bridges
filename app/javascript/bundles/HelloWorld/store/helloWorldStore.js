import { createStore, applyMiddleware, compose } from 'redux';
import thunk from 'redux-thunk';
import finderReducer from '../reducers/finderReducer';

// eslint-disable-next-line no-underscore-dangle
const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

const configureStore = railsProps => (
  createStore(finderReducer, railsProps, composeEnhancers(applyMiddleware(thunk)))
);

export default configureStore;
