import React from 'react';
import ReactDOM from 'react-dom';

import Travap from './components/main';
import Fetch from './fetch';

//import static html files
require.context("./assets/", true, /^\.\/.*\.html/);

ReactDOM.render(<Travap fetch={new Fetch()}/>, document.getElementById('root'));
