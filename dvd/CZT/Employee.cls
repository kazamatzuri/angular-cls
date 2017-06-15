Class CZT.Employee Extends (%Persistent, %Populate)
{

Property Username As %String [ Required ];

Index UsernameIndex On Username [ Unique ];

Property Password As %String [ Required ];

/// 20% of Employees are managers and can change their password.
Property IsManager As %Boolean [ InitialExpression = {$case($r(5),0:1, :0)} ];

Property Name As %String;

Property SSN As %String;

Property DOB As %Date(FORMAT = 3, MAXVAL = "+$h");

Property MaritalStatus As %String(VALUELIST = ",Single,Married,Divorced,Widowed,Separated");

/// All sales performed by this Employee.
Relationship Sales As CZT.Sale [ Cardinality = many, Inverse = SalesPerson ];

Property HomeAddress As CZT.Address;

Property WorkAddress As CZT.Address;

Method OnPopulate() As %Status [ ServerOnly = 1 ]
{
	set initial = $zcvt($extract($piece(..Name, ",", 2)), "L")
	set lastname = $zcvt($piece(..Name, ","), "L")
	set (..Username, ..Password) = initial_lastname
	quit $$$OK
}

Storage Default
{
<Data name="EmployeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Username</Value>
</Value>
<Value name="3">
<Value>Password</Value>
</Value>
<Value name="4">
<Value>IsManager</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>SSN</Value>
</Value>
<Value name="7">
<Value>DOB</Value>
</Value>
<Value name="8">
<Value>MaritalStatus</Value>
</Value>
<Value name="9">
<Value>HomeAddress</Value>
</Value>
<Value name="10">
<Value>WorkAddress</Value>
</Value>
</Data>
<DataLocation>^CZT.EmployeeD</DataLocation>
<DefaultData>EmployeeDefaultData</DefaultData>
<ExtentSize>10</ExtentSize>
<IdLocation>^CZT.EmployeeD</IdLocation>
<IndexLocation>^CZT.EmployeeI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>1.1</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="DOB">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="HomeAddress">
<AverageFieldSize>35.4,City:6.1,State:2,Street:16.8,Zip:5</AverageFieldSize>
<Selectivity>10.0000%,City:11.1111%,State:12.5000%,Street:10.0000%,Zip:10.0000%</Selectivity>
</Property>
<Property name="IsManager">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="MaritalStatus">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="Name">
<AverageFieldSize>16</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="Password">
<AverageFieldSize>7.8</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="SSN">
<AverageFieldSize>11</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="Username">
<AverageFieldSize>7.8</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="WorkAddress">
<AverageFieldSize>36.5,City:6.5,State:2,Street:17.8,Zip:5</AverageFieldSize>
<Selectivity>10.0000%,City:11.1111%,State:11.1111%,Street:10.0000%,Zip:10.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="UsernameIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^CZT.EmployeeS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
