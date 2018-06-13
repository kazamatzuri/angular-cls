/// Relates a DVD with a store that carries it.
Class CZT.Inventory Extends (%Persistent, %Populate)
{

/// Link to the DVD
Relationship DVD As CZT.DVD [ Cardinality = one, Inverse = StoresInStock ];

Index DVDIndex On DVD;

/// Number of this DVD that the store currently has in stock.<br>
/// In the SQL table, this field is called DVDCount.<br>
/// Maximum: 20<br>
/// Minimum: 1<br>
Property Count As %Integer(MAXVAL = 20, MINVAL = 1) [ SqlFieldName = DVDCount ];

Index StoreDVDIndex On (Store, DVD) [ IdKey, Unique ];

/// Link to the store
Relationship Store As CZT.Store [ Cardinality = one, Inverse = DVDsInStock ];

Index StoreIndex On Store;

ClassMethod Update()
{
	do ##class(CZT.Inventory).%DeleteExtent()
	do ##class(CZT.Inventory).Populate(100)
}

Storage Default
{
<Data name="InventoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Count</Value>
</Value>
</Data>
<DataLocation>^CZT.InventoryD</DataLocation>
<DefaultData>InventoryDefaultData</DefaultData>
<ExtentSize>43</ExtentSize>
<IdLocation>^CZT.InventoryD</IdLocation>
<IndexLocation>^CZT.InventoryI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>4</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Count">
<AverageFieldSize>1.67</AverageFieldSize>
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="DVD">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="Store">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>16.6667%</Selectivity>
</Property>
<SQLMap name="DVDIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="StoreDVDIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="StoreIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^CZT.InventoryS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
