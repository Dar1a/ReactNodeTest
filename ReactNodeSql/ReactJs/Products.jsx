import React from 'react';
import axios from 'axios';

class Products extends React.Component {
	constructor(){
		super();
		this.state = { productdata: []};
		this.handleAdd = this.handleAdd.bind(this);
		this.handleChange = this.handleChange.bind(this);
		this.handleSelect = this.handleSelect.bind(this);
		this.handleDelete = this.handleDelete.bind(this);
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
	}
	
	handleAdd(){
		axios.post('http://localhost:5000/Product', {
			ProductType: this.refs.newptype.value,
			ProductName: this.refs.newpname.value,
			ProductDescription: this.refs.newpdescr.value
		})
		.then(function (response) {
			window.location.reload();
		})
		.catch(function (error) {
			alert(error.response.data);
		});
	}
	
	handleDelete(){
		var radios = document.getElementsByName('productcheckbox');
		var id = -1;
		for(var i=0;i<radios.length;i++)
		{
			if(radios[i].checked)
				id = radios[i].value;
		}
		
		if (id > -1)
		{
			axios.delete('http://localhost:5000/Product?id=' + id)
			.then(function (response) {
				window.location.reload();
			})
			.catch(function (error) {
				alert(error.response.data);
			});
		}
	}
	
	handleSelect(item){
		this.refs.ptype.value = item.pt;
		this.refs.pname.value = item.pn;
		this.refs.pdescr.value = item.pd;
	}
	
	handleChange(){
		var radios = document.getElementsByName('productcheckbox');
		var id = -1;
		for(var i=0;i<radios.length;i++)
		{
			if(radios[i].checked)
				id = radios[i].value;
		}
		
		if (id > -1)
		{
			axios.put('http://localhost:5000/Product?id=' + id, {
				ProductType: this.refs.ptype.value,
				ProductName: this.refs.pname.value,
				ProductDescription: this.refs.pdescr.value
			})
			.then(function (response) {
				window.location.reload();
			})
			.catch(function (error) {
				alert(error.response.data);
			});
		}
	}
	
    render() {
		const products = this.state.productdata.map(item => (
			<tr>
				<td>{item.pt}</td>
				<td>{item.pn}</td>
				<td>{item.pd}</td>
				<td><input type="radio" name="productcheckbox" value={item.pid} onChange={()=>this.handleSelect({pt:item.pt, pn:item.pn, pd:item.pd})}/></td>
			</tr>
		));
	   
		const productRows = this.state.productdata.map(item => (
			<option value={item.pid}>{item.pn}</option>
		));
		
		return (
			<div>
				<table>
					<tbody>
						<tr><th>Type</th><th>Name</th><th>Descr</th></tr>
						{products}
					</tbody>
				</table>
				<br/>
				<input type="text" placeholder="Product Name" ref="pname"/>
				<input type="text" placeholder="Product Type" ref="ptype"/>
				<input type="text" placeholder="Product Description" ref="pdescr"/>
				<br/>
				<input type="submit" value="Change Product" onClick={this.handleChange}/>
				<br/>
				<input type="text" placeholder="Product Name" ref="newpname"/>
				<select ref="newptype">
					<option>Toy</option>
					<option>Clothes</option>
					<option>Book</option>
				</select>
				<input type="text" placeholder="Product Description" ref="newpdescr"/>
				<input type="submit" value="Add Product" onClick={this.handleAdd}/>
				<br/>
				<input type="submit" value="Delete Product" onClick={this.handleDelete}/>
			</div>
	);
   }
}

export default Products;