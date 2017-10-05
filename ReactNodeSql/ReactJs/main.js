import React from 'react';
import ReactDOM from 'react-dom';
import Products from './Products.jsx';
import Prices from './Prices.jsx';
import Stores from './Stores.jsx';

if (document.getElementById('products'))
	ReactDOM.render(<Products />, document.getElementById('products'));

if (document.getElementById('prices'))
	ReactDOM.render(<Prices />, document.getElementById('prices'));

if (document.getElementById('stores'))
	ReactDOM.render(<Stores />, document.getElementById('stores'));