import { createStore, applyMiddleware, compose } from 'redux';
import finderReducer from '../reducers/finderReducer';
import thunk from 'redux-thunk';

const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

const configureStore = (railsProps) => (
  createStore(finderReducer, railsProps, composeEnhancers(applyMiddleware(thunk)))
);

export default configureStore;
