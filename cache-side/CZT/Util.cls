Include %occStatus

Class CZT.Util
{

ClassMethod DeleteAll()
{
	d ##class(CZT.DVD).%KillExtent()
	d ##class(CZT.Inventory).%KillExtent()
	d ##class(CZT.Sale).%KillExtent()
	d ##class(CZT.Store).%KillExtent()
	d ##class(CZT.Employee).%KillExtent()
	do ..DeleteFromSecurity()
}

ClassMethod CreateAll()
{
	do ##class(CZT.Employee).Populate(10)
	do ##class(CZT.Store).Populate(6)
	&sql(select count(*) into :movies from CZT.DVD)
	if (movies = 0) {	do ##class(CZT.DVD).Load() }
	do ##class(CZT.Inventory).Populate(100)
	do ##class(CZT.Sale).Populate(500)
	// find shortest username/passwords to suggest for testing
	// making sure that both suggested employees have sales
	&sql(select salesperson->username into :username from czt.sale
	     where salesperson->ismanager = 0
	     order by len(salesperson->username) )
	do {     
		&sql(select id, username into :adminid, :adminname from czt.employee
		     where ismanager = 1
		     order by len(username) )
		do:(SQLCODE = 100) ##class(CZT.Employee).Populate(5)
	} while (SQLCODE = 100)
	// make sure that adminname has at least one sale
	// find a sale from some other employee and switch it to be for adminname instead
	&sql(select id into :saleid from czt.sale where salesperson <> :adminid)
	&sql(update czt.sale set salesperson = :adminid where id = :saleid)
	write !, "For testing, use: "
	write !, "* ", username, "/", username, " (can't change password)."
	write !, "* ", adminname, "/", adminname, " (can change password)."
	write !
	do ..AddToSecurity($lb(username), $lb(adminname))
	do ..UpdateDBUSERRole()
	write !, "Data successfully created!"
}

ClassMethod AddToSecurity(userlist, adminlist)
{
	write !, "Adding these users into Cache Security database"
	new $namespace
	set $namespace = "%SYS"
	for i = 1:1:$ll(userlist) {
		set (username, password) = $list(userlist,i)
		set st = ##class(Security.Users).Create(username,"%DB_USER",password,,,,,,,"for CZT")
		if $$$ISOK(st) {
			write !, "...", username, " added with %DB_USER role."
		}
		else {
			do $system.Status.DisplayError(st)
		}
	}
	for i = 1:1:$ll(adminlist) {
		set (username, password) = $list(adminlist,i)
		set st = ##class(Security.Users).Create(username,"%All",password,,,,,,,"for CZT")
		if $$$ISOK(st) {
			write !, "...", username, " added with %All role."
		}
		else {
			do $system.Status.DisplayError(st)
		}
	}
}

ClassMethod UpdateDBUSERRole()
{
	// add CSPSystem to %DB_USER so that Cache Login works
	&sql(grant %DB_USER to CSPSystem)
	write:(SQLCODE<0) !, "Error: ", %msg
	
	// give users full access to the CZT tables
	&sql(grant select,insert,update,delete on CZT.DVD to %DB_USER)
	write:(SQLCODE<0) !, "Error: ", %msg
	&sql(grant select,insert,update,delete on CZT.Employee to %DB_USER)
	write:(SQLCODE<0) !, "Error: ", %msg
	&sql(grant select,insert,update,delete on CZT.Inventory to %DB_USER)
	write:(SQLCODE<0) !, "Error: ", %msg
	&sql(grant select,insert,update,delete on CZT.Sale to %DB_USER)
	write:(SQLCODE<0) !, "Error: ", %msg
	&sql(grant select,insert,update,delete on CZT.Store to %DB_USER)
	write:(SQLCODE<0) !, "Error: ", %msg
}

ClassMethod DeleteFromSecurity()
{
	write !, "Deleting CZT.Employee users from Cache Security database"
	new $namespace
	set $namespace = "%SYS"
	set sql = "select name from Security.Users where comment = ?"
	set stmt = ##class(%SQL.Statement).%New()
	set st = stmt.%Prepare(sql)
	if $$$ISOK(st) {
		set rs = stmt.%Execute("for CZT")
		if rs.%SQLCODE = 0 {
			while rs.%Next() {
				set username = rs.name
				set st = ##class(Security.Users).Delete(username)
				if $$$ISOK(st) {
					write !, "...", username, " deleted."
				}
				else {
					do $system.Status.DisplayError(st)
				}
			}
		}
	}
}

}
