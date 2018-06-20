import axios from 'axios';
import {
  FINDER_PROGRESS,
  FINDER_RESULTS,
  FINDER_DOMAINS,
} from '../constants/finderConstants';

export const fetchResults = () => dispatch => axios.get('/friends/results.json').then(({ data }) => {
  dispatch({
    type: FINDER_RESULTS,
    data,
  });
});

export const fetchDomains = () => dispatch => axios.get('/friends/domains.json').then(({ data }) => {
  dispatch({
    type: FINDER_DOMAINS,
    data,
  });
});

export const fetchProgress = () => dispatch => axios.get('/friends/status.json').then(({ data }) => {
  dispatch({
    type: FINDER_PROGRESS,
    data,
  });

  if (data.status === 'complete') {
    dispatch(fetchResults());
    dispatch(fetchDomains());
  } else if (data.status === 'failed') {
    console.error('failed'); // eslint-disable-line no-console
  } else {
    setTimeout(() => dispatch(fetchProgress()), 1000);
  }
});
