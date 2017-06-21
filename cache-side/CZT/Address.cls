Class CZT.Address Extends (%SerialObject, %Populate)
{

Property Street As %String;

Property City As %String;

Property State As %String;

Property Zip As %String;

Storage Default
{
<Data name="AddressState">
<Value name="1">
<Value>Street</Value>
</Value>
<Value name="2">
<Value>City</Value>
</Value>
<Value name="3">
<Value>State</Value>
</Value>
<Value name="4">
<Value>Zip</Value>
</Value>
</Data>
<State>AddressState</State>
<StreamLocation>^CZT.AddressS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
