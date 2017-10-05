import React from 'react';
import axios from 'axios';

class Prices extends React.Component {
	constructor(){
		super();
		this.state = { productdata: [], storedata: [], pricedata: []};
		this.handleCreatePrice = this.handleCreatePrice.bind(this);
		this.handleUpdatePrices = this.handleUpdatePrices.bind(this);
	}
	
	componentDidMount(){	
		axios.get('http://localhost:5000/Product')
		.then(res => {
			var res1 = [];
			res.data.map((val)=>val.map(v=>res1.push({pid:v.ProductId, pt:v.ProductType, pn:v.ProductName, pd:v.ProductDescription })));
			this.setState({productdata: res1});
		}).catch(function (error) {
			alert(error);
		});
		
		axios.get('http://localhost:5000/Store')
		.then(res => {
			var res1 = [];
			res.data.map((val)=>val.map(v=>res1.push({sid:v.StoreId, sd:v.StoreDescription, sn:v.StoreName })));
			this.setState({storedata: res1});
		}).catch(function (error) {
			alert(error);
		});
		
		axios.get('http://localhost:5000/SalePrice')
		.then(res => {
			var res1 = [];
			res.data.map((val)=>val.map(v=>res1.push({sn:v.StoreName, pn:v.ProductName, p:v.Price, sid:v.StoreId, pid:v.ProductId })));
			this.setState({pricedata: res1});
		}).catch(function (error) {
			alert(error);
		});
	}
	
	handleCreatePrice(){
		var createPriceXml = "<SalePrice><Key ProductId = \"" 
			+ this.refs.productsNewPrice.value + "\" StoreId = \""
			+ this.refs.storesNewPrice.value + "\" Price = \""
			+ this.refs.newPrice.value + "\" /></SalePrice>";
		
		axios.post('http://localhost:5000/SalePrice', {
			SalePriceXML: createPriceXml
		})
		.then(function (response) {
			window.location.reload();
		})
		.catch(function (error) {
			alert(error.response.data);
		});
	}
	
	handleUpdatePrices(){
		var priceFields = document.getElementsByName('priceupdates');
		var newPriceIds = [];
		
		for(var i=0;i<priceFields.length;i++)
		{
			if(priceFields[i].value != "")
			{
				newPriceIds.push(i);
			}
		}
		
		var newPrices = [];
		
		for(var i=0;i<newPriceIds.length;i++)
		{
			const id = newPriceIds[i];
			var newPriceData = this.state.pricedata[id];
			newPriceData.p = priceFields[id].value;
			newPrices.push(newPriceData);
		}
		
		const prices = newPrices.map((item) => (
			"<Key ProductId = \"" 
			+ item.pid + "\" StoreId = \""
			+ item.sid + "\" Price = \""
			+ item.p + "\" />"
		));
		
		axios.post('http://localhost:5000/SalePrice', {
			SalePriceXML: "<SalePrice>" + prices + "</SalePrice>"
		})
		.then(function (response) {
			window.location.reload();
		})
		.catch(function (error) {
			alert(error.response.data);
		});
	}
	
    render() {	   
		const productRows = this.state.productdata.map(item => (
			<option value={item.pid}>{item.pn}</option>
		));
		
		const storeRows = this.state.storedata.map(item => (
			<option value={item.sid}>{item.sn}</option>
		));
		
		const prices = this.state.pricedata.map(item => (
			<tr><td>{item.pn}</td><td>{item.sn}</td><td>{item.p}</td><input type="text" name="priceupdates"/></tr>
		));
		
		return (
			<div>
				<select ref="productsNewPrice">
					{productRows}
				</select>
				<select ref="storesNewPrice">
					{storeRows}
				</select>
				<input type="text" placeholder="New Price" ref="newPrice"/>
				<br/>
				<input type="submit" value="Add Price" onClick={this.handleCreatePrice}/>
				<table>
					<tbody>
						<tr><th>Product</th><th>Store</th><th>Price</th><th>New Price</th></tr>
						{prices}
					</tbody>
				</table>
				<br/>
				<input type="submit" value="Update Prices" onClick={this.handleUpdatePrices}/>
			</div>
		);
   }
}

export default Prices;