Class API.Handler Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>

<Route Url="/dvds[/]?([^/]?)" Method="GET" Call="DVDs"/>
<Route Url="/stores[/]?([^/]?)" Method="GET" Call="Stores" />
<Route Url="/sales[/]?([^/]?)" Method="GET" Call="Sales" />
<Route Url="/employees[/]?([^/]?)" Method="GET" Call="Employee" />
<Route Url="/employees/:id" Method="DELETE" Call="DeleteEmployee"/>
<Route Url="/stock/:storeid" Method="GET" Call="Stocked"/>
</Routes>
}

ClassMethod DeleteEmployee(id as %String) as %Status {
	if (id'="") {
		if ##class(CZT.Employee).%ExistsId(id) {
			d ##class(CZT.Employee).%DeleteId(id)
		} else {
			s %response.Status=404
			q $$$OK
		}
	} 
	q $$$OK
}


ClassMethod Employee(id as %String) as %Status {
	if (id'="") {
		s emp=##Class(CZT.Employee).%OpenId(id)
		if $IsObject(emp){
			s ret={}
		
			s ret.Name=emp.Name
			s ret.DOB=emp.DOB
			w ret.%ToJSON()
		} else {
			s %response.Status=404
			q $$$OK
		}
	} else {
		w ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,"select ID,Name,DOB from CZT.Employee")
	}
	q $$$OK
}


ClassMethod Sales(id as %String) as %Status {
	if (id'="") {
		s sale=##Class(CZT.Sale).%OpenId(id)
		if $IsObject(sale){
			s ret={}
			s ret.DVD=sale.DVD.Title
			s ret.DateSold=sale.DateSold
			s ret.SalesPerson=sale.SalesPerson.Name
			s ret.Store=sale.Store
			w ret.%ToJSON()
		} else {
			s %response.Status=404
			q $$$OK
		}
	} else {
		w ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,"select DVD->Title,DateSold,SalesPerson->Name,Store from CZT.Sale",,1000)
	}
	q $$$OK
}


ClassMethod Stores(id as %String) as %Status {
	if (id'="") {
		s store=##Class(CZT.Store).%OpenId(id)
		if $IsObject(store){
			s ret={}
		
			s ret.Street=store.Address.Street
			s ret.City =store.Address.City
			s ret.State=store.Address.State
			s ret.Zip=store.Address.Zip
			s ret.Phone=store.Phone
			s ret.ID=store.%Id()
			w ret.%ToJSON()
		} else {
			s %response.Status=404
			q $$$OK
		}
	} else {
		w ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,"select ID,Address_Street Street,Address_City City,Address_State State,Address_Zip Zip,Phone from CZT.Store")
	}
	q $$$OK
}

ClassMethod Stocked(storeid as %String) as %Status {
	w ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,"select DVD->Title,DVDCount from CZT.Inventory where Store='"_storeid_"'")
	q $$$OK
}

ClassMethod DVDs(id as %String) as %Status {
	if (id'="") {
		s dvd=##Class(CZT.DVD).%OpenId(id)
		if $IsObject(dvd){
			s ret={}
			s ret.Title=dvd.Title
			s ret.Rating=dvd.Rating
			s ret.Price=dvd.Price
			s ret.Length=dvd.Length
			
			w ret.%ToJSON()
		} else {
			s %response.Status=404
			q $$$OK
		}
	} else {
	w ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,"select * from CZT.DVD")
	}
	q $$$OK
}

}
