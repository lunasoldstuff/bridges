import PropTypes from 'prop-types';
import React, { Fragment } from 'react';
import { FormattedMessage } from 'react-intl';

const ConnectPrompt = ({ isPioneer, domains }) => (
  <div className='connect-prompt'>
    {isPioneer ? (
      <Fragment>
        <h3><i className='fa fa-binoculars' /> <FormattedMessage id='connect_prompt.pioneer.title' defaultMessage='You are a pioneer!' /></h3>
        <p><FormattedMessage id='connect_prompt.pioneer.body' defaultMessage='You might be the first among your Twitter friends to explore Mastodon. Be sure to connect your Mastodon account so they see you when they join.' /></p>
      </Fragment>
    ) : (
      <Fragment>
        <h3><i className='fa fa-check' /> <FormattedMessage id='connect_prompt.tutorial.title' defaultMessage='Almost there!' /></h3>
        <p><FormattedMessage id='connect_prompt.tutorial.body' defaultMessage='For your friends to find you as well, you still need to login with your Mastodon account. If you need help choosing a server to create a new account on, {link} or click the button below.' values={{ link: <a href='#domain'><FormattedMessage id='connect_prompt.tutorial.link' defaultMessage='see where your friends have signed up' /></a> }} /></p>
      </Fragment>
    )}
    <a target='_blank' href='/users/auth/mastodon'><FormattedMessage id='connect_prompt.login_via_mastodon' defaultMessage='Login via Mastodon' /></a>
    {domains.length > 0 && <a rel='noopener noreferrer' target='_blank' className='secondary' href={`https://${domains[0].uri}/auth/sign_up`}><FormattedMessage id='connect_prompt.create_mastodon_account' defaultMessage='Create Mastodon account' /></a>}
  </div>
);

ConnectPrompt.defaultProps = {
  isPioneer: false,
};

ConnectPrompt.propTypes = {
  isPioneer: PropTypes.bool,
  domains: PropTypes.arrayOf(PropTypes.shape({
    uri: PropTypes.string,
  })).isRequired,
};

export default ConnectPrompt;
