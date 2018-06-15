Class API.Handler Extends %CSP.REST
{

Parameter HandleCorsRequest="1";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>

<Route Url="/dvds[/]?([^/]?)" Method="GET" Call="DVDs"/>
<Route Url="/bdvds" Method="GET" Call="BenDVDs"/>
<Route Url="/dvds" Method="DELETE" Call="DeleteDvds"/>
<Route Url="/dvds" Method="POST" Call="AddDVD"/>
<Route Url="/stores[/]?([^/]?)" Method="GET" Call="Stores" />
<Route Url="/sales[/]?([^/]?)" Method="GET" Call="Sales" />
<Route Url="/sales" Method="POST" Call="AddSale" />
<Route Url="/employees[/]?([^/]?)" Method="GET" Call="Employee" />
<Route Url="/employees/:id" Method="DELETE" Call="DeleteEmployee"/>
<Route Url="/stock/:storeid" Method="GET" Call="Stocked"/>
</Routes>
}
ClassMethod AddSale() as %Status {
	
}

ClassMethod DeleteDvds() As %Status
{
	s ids=$G(%request.Data("ids",1))
	s ^%kdebug($I(^%kdebug))="deleting:"_ids
	s err={}
	s err.text=""
	if (ids'="") {
		for i=1:1:$L(ids,",") {
			s currentid=$P(ids,",",i)
			if ##class(CZT.DVD).%ExistsId(currentid) {
				s sc=##class(CZT.DVD).%DeleteId(currentid)
				i '$$$ISOK(sc){
				s %response.Status=400
				s err.text=err.text_$SYSTEM.Status.GetErrorText(sc)
			}
			}
		}
	} 
	d err.%ToJSON()
	q $$$OK
}


ClassMethod AddDVD() as %Status{
	Set %response.ContentType="application/json"
	try {
	       set obj = ##class(%DynamicAbstractObject).%FromJSON(%request.Content)
	       d %request.Content.Rewind()
	       s ^%kdebug($I(^%kdebug))=%request.Content.Read(1000)
	       s dvd=##class(CZT.DVD).%New()
	       s dvd.Title=obj.Title
	       s dvd.Price=obj.Price
	       s dvd.Length=obj.Length
	       s dvd.Rating=obj.Rating
	       s sc=dvd.%Save()
	       i '$$$ISOK(sc){
				s %response.Status=400
				s err={}
				s err.text=$SYSTEM.Status.GetErrorText(sc)
				w err.%ToJSON()
				return $$$OK
		   } else {
		   	s %response.Status=200
		   	return $$$OK
		   }

	} catch ex {
		//TODO: add fancy error handling ;)
	       set obj = ""
	}
    
	return $$$OK
}
ClassMethod DeleteEmployee(id As %String) As %Status
{
	if (id'="") {
		if ##class(CZT.Employee).%ExistsId(id) {
			s sc=##class(CZT.Employee).%DeleteId(id)
			i '$$$ISOK(sc){
				s %response.Status=400
				w $SYSTEM.Status.GetErrorText(sc)
				q $$$OK
			}
		} else {
			s %response.Status=404
			q $$$OK
		}
	} 
	q $$$OK
}

ClassMethod Employee(id As %String) As %Status
{
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

ClassMethod Sales(id As %String) As %Status
{
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

ClassMethod Stores(id As %String) As %Status
{
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

ClassMethod Stocked(storeid As %String) As %Status
{
	w ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,"select DVD->Title,DVDCount from CZT.Inventory where Store='"_storeid_"'")
	q $$$OK
}

ClassMethod DVDs(id As %String) As %Status
{
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

ClassMethod BenDVDs() as %Status {
    #dim st as %Status = $$$OK
        #dim e as %Exception.AbstractException
       
        try {
            if $get(%request.CgiEnvs("HTTP_ACCEPT"))["application/json" {
                set %response.ContentType="application/json"
                set inventory = ##class(%DynamicArray).%New()
               
                &sql(declare c cursor for
                     select *
                     from CZT.DVD)
                &sql(open c)
                for {
                    set dvd = ##class(%DynamicObject).%New()
                    &sql(fetch c into :dvd.ID, :dvd.Length, :dvd.Price, :dvd.Rating, :dvd.Title)
                    quit:(SQLCODE '= 0)
                    do inventory.%Push(dvd)
                }
               
                write inventory.%ToJSON()
                &sql(close c)
            }
        }
        catch e {
            set st = e.AsStatus()
            write st
        }
        quit $$$OK
	return $$$OK
}
	

}
