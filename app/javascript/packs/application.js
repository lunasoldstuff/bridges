import Rails from 'rails-ujs';
import ReactOnRails from 'react-on-rails';
import '../styles/application.scss';
import '../images';
import HelloWorldApp from '../bundles/HelloWorld/startup/HelloWorldApp';

Rails.start();

// This is how react_on_rails can see the HelloWorld in the browser.
ReactOnRails.register({
  HelloWorldApp,
});
