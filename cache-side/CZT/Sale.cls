/// Represents a sale of a DVD.<br>
/// Relates together the DVD, the Employee that sold it, and the Store that it was sold from.
Class CZT.Sale Extends (%Persistent, %Populate)
{

/// Simulated sales system failure rate, in %. Default is 25% for testing; change to lower number or 0 when done testing
Parameter FAILURERATE = "25
";

/// Date of sale in internal format.<br>
/// In SQL table, this field is called DateSold.
Property Date As %Date(FORMAT = 3, MAXVAL = "+$h", MINVAL = 59901, POPSPEC = "Date(59901, +$system.SYS.TimeStamp())") [ Required, SqlFieldName = DateSold ];

/// Time of sale in internal format.<br>
/// In SQL table, this field is called TimeSold.
Property Time As %Time [ Required, SqlFieldName = TimeSold ];

/// Link to the Employee that made the sale
Relationship SalesPerson As CZT.Employee [ Cardinality = one, Inverse = Sales ];

Index SalesPersonIndex On SalesPerson;

/// Link to the store where the sale took place
Relationship Store As CZT.Store [ Cardinality = one, Inverse = Sales ];

Index StoreIndex On Store;

/// Link to the DVD that was sold
Relationship DVD As CZT.DVD [ Cardinality = parent, Inverse = Sales ];

/// Sells a DVD.<br><br>
/// This class method takes in the id numbers of the DVD being sold, the store where it was sold, and the Employee that sold it.
/// The method creates a new CZT.Sale object with the correct relationships set, saves it to the database, and updates the store's inventory.<br><br>
/// Returns a status indicating success or failure.
ClassMethod SellDVD(DVDId As %Integer, StoreId As %Integer, SalesPersonId As %Integer) As %Status
{
	//check that we received a SalesPersonId
	if '$data(SalesPersonId)
	{
		return $$$ERROR($$$GeneralError, "Invalid SalesPerson")
	}
	
	//make sure the DVD is in stock
	s Inventory = ##class(CZT.Inventory).%OpenId(StoreId_"||"_DVDId)
	
	if ($isobject(Inventory) && (Inventory.Count > 0))
	{
		//sometimes you just can't sell a DVD for unknown reasons
		//change FAILURERATE parameter above for testing purposes
		if ($r(100)+1) <= ..#FAILURERATE {
			return $$$ERROR($$$GeneralError, "There was a problem selling this DVD--please try again")
		}
		
		//create a new object and set its properties
		s NewSale = ##class(CZT.Sale).%New()
		d NewSale.StoreSetObjectId(StoreId)
		d NewSale.DVDSetObjectId(DVDId)
		d NewSale.SalesPersonSetObjectId(SalesPersonId)
		
		s NewSale.Time = $p($h, ",", 2)
		s NewSale.Date = +$h
		
		//try to save
		s status = NewSale.%Save()
		if ($$$ISOK(status))
		{
			//if successful, reduce inventory count
			s Inventory.Count = Inventory.Count - 1
			if Inventory.Count <= 0
			{
				s status = ##class(CZT.Inventory).%DeleteId(Inventory.%Id())
			}
			else
			{
				s status = Inventory.%Save()
			}
		}
		
		return status
		
	}
	else
	{
		q $$$ERROR($$$GeneralError, "Store does not have DVD in its inventory")
	}
}

Storage Default
{
<Data name="SaleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Date</Value>
</Value>
<Value name="3">
<Value>Time</Value>
</Value>
<Value name="4">
<Value>SalesPerson</Value>
</Value>
<Value name="5">
<Value>Store</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Sales")</DataLocation>
<DefaultData>SaleDefaultData</DefaultData>
<ExtentSize>500</ExtentSize>
<IdLocation>^CZT.DVDC("Sales")</IdLocation>
<IndexLocation>^CZT.SaleI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>5.78</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="DVD">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="Date">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>0.2079%</Selectivity>
</Property>
<Property name="SalesPerson">
<AverageFieldSize>1.09</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="Store">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="Time">
<AverageFieldSize>4.86</AverageFieldSize>
<Selectivity>0.2000%</Selectivity>
</Property>
<Property name="childsub">
<AverageFieldSize>2.78</AverageFieldSize>
<Selectivity>0.2000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-8</BlockCount>
</SQLMap>
<SQLMap name="SalesPersonIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="StoreIndex">
<BlockCount>-8</BlockCount>
</SQLMap>
<StreamLocation>^CZT.SaleS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
