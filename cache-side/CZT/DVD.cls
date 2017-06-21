Class CZT.DVD Extends %Persistent
{

/// The title of the DVD movie
Property Title As %String;

Index TitleIndex On Title [ Unique ];

/// Content rating assigned by the MPAA.<br>
/// Possible values are:<br>
/// <ul><li>G - General Audience.
/// <li>PG - Parental Guidence.
/// <li>PG-13 - Parents Strongly Cautioned.
/// <li>R - Restricted.</ul>
Property Rating As %String(VALUELIST = ",G,PG,PG-13,R");

/// How much the DVD costs
Property Price As %Numeric(MAXVAL = 50.95, MINVAL = 10.95);

/// Length of the movie in minutes
Property Length As %Integer(MAXVAL = 210, MINVAL = 45);

Relationship Sales As CZT.Sale [ Cardinality = children, Inverse = DVD ];

Relationship StoresInStock As CZT.Inventory [ Cardinality = many, Inverse = DVD ];

/// Retrieves list of best-selling DVDs and saves them.<br>
ClassMethod Load(verbose As %Boolean = 0)
{
	do ##class(CZT.DVD).%KillExtent()
	
	// get popular DVDs from web
	set reqList = ##class(%Net.HttpRequest).%New()
	set reqList.Server = "www.officialcharts.com"
	set st = reqList.Get("/charts/dvd-chart/")
	return:$$$ISERR(st) "couldn't get DVD list"

	set respList = reqList.HttpResponse
	
	// find beginning of DVD listing
	for i=1:1 {
		set content = respList.Data.ReadLine()
		// if verbose { write !, content }
		quit:((content [ "<table class=""chart-positions"">") || respList.Data.AtEnd)
		if (verbose && ((i#10)=0)) { write !, i, " lines skipped..." }
	} 
	if (respList.Data.AtEnd) {
		write !, "No <table> found."
		quit
	}
				
	// request for retrieving movie rating and length
	set reqMovie = ##class(%Net.HttpRequest).%New()
	set reqMovie.Server = "www.omdbapi.com"		

	while '(respList.Data.AtEnd) {
		set content = respList.Data.ReadLine()
		// quit at the end of the <table>
		// otherwise, continue until finding an <img> tag
		if (content [ "</table>") {quit}
		if ((content '[ "<img") && (content '[ "alt=")) {continue}
		set title = $p($p(content, "alt=""", 2, *), """")
		if (title '= "") {
			if verbose { write !, title }
			set title = $zcvt(title, "W")
			set title = $zcvt(title, "I", "HTML")
		}
		
		// get movie info
		goto jump
		set query = "/?t=" _ ##class(%CSP.Page).EscapeURL(title) _ "&r=xml" _ "&apikey=2973733c"
		set st = reqMovie.Get(query)
		return:$$$ISERR(st) "couldn't get movie info"
		
		// parse the XML to get rating and length
		set respMovie = reqMovie.HttpResponse
		#dim reader as %XML.TextReader
		set st = ##class(%XML.TextReader).ParseStream(respMovie.Data, .reader)
		// if we can't parse for some reason just store this one with default rating and length
		if $$$ISERR(st) {
			if (verbose) {
				write !, title
				do $system.Status.DisplayError(st)
			}
			set rating = "G", length = 120
		}
		else {
			while reader.Read() {
				if (reader.NodeType = "element") && (reader.Name = "movie") {
					do reader.MoveToAttributeName("rated")
					set rating = reader.Value
					do reader.MoveToAttributeName("runtime")
					set length = +reader.Value // chop off " min"
					quit
				}
			}
		}
jump	set rating = "PG-13", length = 120
		// create and save each DVD object
		set dvd = ##class(CZT.DVD).%New()
		set dvd.Title = title
		set dvd.Price = ##class(%Library.PopulateUtils).Integer(10, 50) _ ".95"
		
		if ##class(CZT.DVD).RatingIsValid(rating) { set dvd.Rating = rating }
		else { set dvd.Rating = "G" }
		
		if ##class(CZT.DVD).LengthIsValid(length) { set dvd.Length = length }
		else { set dvd.Length = 120 }
		set st = dvd.%Save()
		if $$$ISOK(st) && verbose { write !, title, " saved."}
	}
}

Storage Default
{
<Data name="DVDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Title</Value>
</Value>
<Value name="3">
<Value>Rating</Value>
</Value>
<Value name="4">
<Value>Price</Value>
</Value>
<Value name="5">
<Value>Length</Value>
</Value>
</Data>
<DataLocation>^CZT.DVDD</DataLocation>
<DefaultData>DVDDefaultData</DefaultData>
<IdLocation>^CZT.DVDD</IdLocation>
<IndexLocation>^CZT.DVDI</IndexLocation>
<Property name="%%CLASSNAME"/>
<Property name="Length"/>
<Property name="Price"/>
<Property name="Rating"/>
<SQLMap name="IDKEY"/>
<SQLMap name="TitleIndex"/>
<StreamLocation>^CZT.DVDS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
