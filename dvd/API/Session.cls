Class API.Session Extends %Persistent
{

Property user As %String;

Index UserIDX On user [ IdKey, PrimaryKey, Unique ];

Property key As %String;

Storage Default
{
<Data name="SessionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>user</Value>
</Value>
<Value name="3">
<Value>key</Value>
</Value>
</Data>
<DataLocation>^API.SessionD</DataLocation>
<DefaultData>SessionDefaultData</DefaultData>
<IdLocation>^API.SessionD</IdLocation>
<IndexLocation>^API.SessionI</IndexLocation>
<StreamLocation>^API.SessionS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
