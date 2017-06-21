Class API.JWT Extends %RegisteredObject
{

ClassMethod SignJWT(header As %DynamicObject, payload As %DynamicObject, key As %String) As %String
{
	s header.alg="HS256"
	s header.typ="JWT"
	s text=$SYSTEM.Encryption.Base64Encode(header.%ToJSON())_"."_$SYSTEM.Encryption.Base64Encode(payload.%ToJSON())
	s signature=$SYSTEM.Encryption.Base64Encode(##class(%SYSTEM.Encryption).HMACSHA(256,text,key))
	q text_"."_signature
}

ClassMethod VerifyJWT(jwt As %String, secret As %String) As %Status
{
	s result=0
	s header=$P(jwt,".",1)
	s payload=$P(jwt,".",2)
	s signature=$P(jwt,".",3)
	s text=header_"."_payload
	s signaturenew=$SYSTEM.Encryption.Base64Encode(##class(%SYSTEM.Encryption).HMACSHA(256,text,secret))
	if (signaturenew=signature) {
		s result=$$$OK
	}
	q result
}

ClassMethod GetJWT(userid As %String, key As %String) As %String
{
	s header={}
	s payload={}
	s payload.userid=userid
	q ..SignJWT(header,payload,key)
}

ClassMethod TestJWT()
{

	s key="something"
	
	s jose("sigalg")="HS256"
	s usero={}
	s usero.user=##class(%PopulateUtils).Name()
	
	s user=usero.%ToJSON()
	s sc=##class(%OAuth2.JWT).ObjectToJWT(.jose,usero,key,.jwt)
	w sc,!
	w jwt,!
}

}
