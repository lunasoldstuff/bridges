import PropTypes from 'prop-types';
import React from 'react';

const ConnectPrompt = ({ domains }) => (
  <div className='connect-prompt'>
    <h3><i className='fa fa-check' /> Almost there!</h3>
    <p>For your friends to find you as well, you still need to login with your Mastodon account. If you need help choosing a server to create a new account on, <a href='#domains'>see where your friends have signed up</a> or click the button below.</p>
    <a target='_blank' href='/users/auth/mastodon'>Login via Mastodon</a>
    {domains.length > 0 && <a target='_blank' className='secondary' href={`https://${domains[0].uri}/auth/sign_up`}>Create Mastodon account</a>}
  </div>
);

ConnectPrompt.propTypes = {
  domains: PropTypes.array.isRequired,
};

export default ConnectPrompt;
