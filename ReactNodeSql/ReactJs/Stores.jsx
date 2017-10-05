import React from 'react';
import axios from 'axios';

class Stores extends React.Component {
	constructor(){
		super();
		this.state = { storedata: []};
		this.handleAdd = this.handleAdd.bind(this);
		this.handleChange = this.handleChange.bind(this);
		this.handleSelect = this.handleSelect.bind(this);
		this.handleDelete = this.handleDelete.bind(this);
	}
	
	componentDidMount(){	
		axios.get('http://localhost:5000/Store')
		.then(res => {
			var res1 = [];
			res.data.map((val)=>val.map(v=>res1.push({pid:v.StoreId, pn:v.StoreName, pc:v.City })));
			this.setState({storedata: res1});
		}).catch(function (error) {
			alert(error);
		});
	}
	
	handleAdd(){
		axios.post('http://localhost:5000/Store', {
			StoreName: this.refs.newpname.value,
			City: this.refs.newpcity.value
		})
		.then(function (response) {
			window.location.reload();
		})
		.catch(function (error) {
			alert(error.response.data);
		});
	}
	
	handleDelete(){
		var radios = document.getElementsByName('storecheckbox');
		var id = -1;
		for(var i=0;i<radios.length;i++)
		{
			if(radios[i].checked)
				id = radios[i].value;
		}
		
		if (id > -1)
		{
			axios.delete('http://localhost:5000/Store?id=' + id)
			.then(function (response) {
				window.location.reload();
			})
			.catch(function (error) {
				alert(error.response.data);
			});
		}
	}
	
	handleSelect(item){
		this.refs.pname.value = item.pn;
		this.refs.pcity.value = item.pc;
	}
	
	handleChange(){
		var radios = document.getElementsByName('storecheckbox');
		var id = -1;
		for(var i=0;i<radios.length;i++)
		{
			if(radios[i].checked)
				id = radios[i].value;
		}
		
		if (id > -1)
		{
			axios.put('http://localhost:5000/Store?id=' + id, {
				StoreName: this.refs.pname.value,
				City: this.refs.pcity.value
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
		const stores = this.state.storedata.map(item => (
			<tr>
				<td>{item.pn}</td>
				<td>{item.pc}</td>
				<td><input type="radio" name="storecheckbox" value={item.pid} onChange={()=>this.handleSelect({pn:item.pn, pc:item.pc})}/></td>
			</tr>
		));
	   
		const storeRows = this.state.storedata.map(item => (
			<option value={item.pid}>{item.pn}</option>
		));
		
		return (
			<div>
				<table>
					<tbody>
						<tr><th>Name</th><th>City</th></tr>
						{stores}
					</tbody>
				</table>
				<br/>
				<input type="text" placeholder="Store Name" ref="pname"/>
				<input type="text" placeholder="City" ref="pcity"/>
				<br/>
				<input type="submit" value="Change Store" onClick={this.handleChange}/>
				<br/>
				<input type="text" placeholder="Store Name" ref="newpname"/>
				<input type="text" placeholder="City" ref="newpcity"/>
				<br/>
				<input type="submit" value="Add Store" onClick={this.handleAdd}/>
				<br/>
				<input type="submit" value="Delete Store" onClick={this.handleDelete}/>
			</div>
		);
   }
}

export default Stores;