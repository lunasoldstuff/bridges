import { combineReducers } from 'redux';
import { FINDER_PROGRESS, FINDER_RESULTS, FINDER_DOMAINS } from '../constants/finderConstants';

const initialState = {
  total: 0,
  at: 0,
  status: null,
  inProgress: true,
  results: [],
  domains: [],
};

const finder = (state = initialState, action) => {
  switch (action.type) {
    case FINDER_PROGRESS:
      return { ...state, status: action.data.status, total: action.data.total, at: action.data.at };
    case FINDER_RESULTS:
      return { ...state, inProgress: false, results: action.data };
    case FINDER_DOMAINS:
      return { ...state, domains: action.data };
    default:
      return state;
  }
};

const user = (state = '', action) => {
  return state;
};

const finderReducer = combineReducers({ finder, user });

export default finderReducer;
