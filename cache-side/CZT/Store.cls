Class CZT.Store Extends (%Persistent, %Populate) [ Inheritance = right ]
{

Property Address As CZT.Address;

Property Phone As %String(PATTERN = "3n1""-""3n1""-""4n");

Index PhoneIndex On Phone [ Unique ];

Query StoreInventory(id As %Integer) As %SQLQuery
{
SELECT DVD->Title, DVD->ID, DVDCount, DVD->Price FROM CZT.Inventory WHERE Store = :id ORDER BY Title
}

Relationship DVDsInStock As CZT.Inventory [ Cardinality = many, Inverse = Store ];

Relationship Sales As CZT.Sale [ Cardinality = many, Inverse = Store ];

Storage Default
{
<Data name="StoreDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Address</Value>
</Value>
<Value name="3">
<Value>Phone</Value>
</Value>
</Data>
<DataLocation>^CZT.StoreD</DataLocation>
<DefaultData>StoreDefaultData</DefaultData>
<ExtentSize>6</ExtentSize>
<IdLocation>^CZT.StoreD</IdLocation>
<IndexLocation>^CZT.StoreI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Address">
<AverageFieldSize>37,City:8.33,State:2,Street:16.67,Zip:5</AverageFieldSize>
<Selectivity>16.6667%,City:20.0000%,State:16.6667%,Street:16.6667%,Zip:16.6667%</Selectivity>
</Property>
<Property name="Phone">
<AverageFieldSize>12</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="PhoneIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^CZT.StoreS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
