/*
 *	Copyright 2007 Paul Marcotte
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  Recordset.cfc (.2)
 *  [2007-05-31]	Added Apache license.
 *					Fixed bug in currentRow method.
 *					Dropped cfscript blocks in favour of tags in all methods but queryRowToStruct().
 *  [2007-05-27]	Initial release.
 *					Acknowlegement to Aaron Roberson for suggesting inheritable iteration.
 *					Acknowlegement also to Peter Bell for the "Iterating Business Object" concept that Recordset seeks to provide.
 */

If you prefer to use inheritance to create "Iterating Business Objects", you can now extend Recordset instead of
delegating iteration to a composite Iterator.  I chose Recordset as the name, because it provides similar traversal of
records to an ADO Recordset.  Recordset is not a query, but rather a query that is converted to an array of structs.  Extending
Recordset is useful as an alternative to maintaining an array of objects, or if you want to display a list with calculated fields (an employee has
a startdate, but display format is "years of service").

Recordset has the following public methods:

currentRow():numeric - the index of the current record.
next():boolean -  the next record is set.
previous():boolean - the previous record is set.
reset():void - reset the index.
end():void - set the index to the last record
pageCount():numeric - if pagination is desired, returns the number of pages in the Recordset
recordCount():numeric - total number of records.
loadQuery():void - accepts a ColdFusion query
setPage():void - set desired page for next iteration (used only with pagination).

How to use Recordset:

If your transient objects do not extend another class, you can simply extend Recordset.  

<cfcomponent displayname="User" extends="com.fancybread.util.list.Recordset" output="false">
	<cfset variables.instance = StructNew() />
	...
</cfcomponent>
 
To display a list of users by role, first instantiate the user list and set the user role and load the list in your controller.
 
<code>
<cfset userList = variables.UserService.getUser() />
<cfset usersByRoleQuery = variables.UserService.getUsersByRole() />
<cfset userList.loadQuery(usersByRoleQuery) />
</code>

Loop through the list in your display view while next() returns true.

<code>
<cfloop condition="userList.next()">
{display code}
</cfloop>
</code>