<!--- 
   Copyright 2007 Paul Marcotte

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   Recordset.cfc (.2)
   [2007-05-31] Added Apache license.
				Fixed bug in currentRow method.
				Dropped cfscript blocks in favour of tags in all methods but queryRowToStruct().
   [2007-05-27] Initial release.
				Acknowlegement to Aaron Roberson for suggesting inheritable iteration.
				Acknowlegement also to Peter Bell for the "Iterating Business Object" concept that Recordset seeks to provide.
 --->
<cfcomponent displayname="Recordset" output="false" hint="I am a Recordset object.  Beans extend me to implement iterator methods.">

	<cffunction name="init" access="public" output="false" returntype="com.fancybread.util.list.Recordset">
		<cfset variables.recordIndex = 0 />
		<cfset variables.pageIndex = 1 />
		<cfreturn THIS />
	</cffunction>
	
	<cffunction name="currentIndex" access="private" output="false" returntype="numeric">
		<cfreturn variables.recordIndex*variables.pageIndex />
	</cffunction>
	
	<cffunction name="currentRow" access="public" output="false" returntype="numeric">
    	<cfreturn variables.recordIndex />
    </cffunction>
		
	<cffunction name="hasNext" access="private" output="false" returntype="boolean">
		<cfreturn (currentIndex() lt (recordCount()/pageCount())) />
	</cffunction>
	
	<cffunction name="next" access="public" output="false" returntype="boolean">
		<cfset var next = false />
		<cfif hasNext()>
			<cfset variables.recordIndex = currentIndex() + 1 />
			<cfset variables.instance = variables.records[currentIndex()] />
			<cfset next = true />
		</cfif>
		<cfreturn next />
	</cffunction>
	
	<cffunction name="hasPrevious" access="private" output="false" returntype="boolean">
		<cfreturn (currentIndex() gt (recordCount()/pageCount())) />
	</cffunction>
	
	<cffunction name="previous" access="public" output="false" returntype="boolean">
		<cfset var previous = false />
		<cfif hasPrevious()>
			<cfset variables.recordIndex = currentIndex() - 1 />
			<cfset variables.instance = variables.records[currentIndex()] />
			<cfset previous = true />
		</cfif>
		<cfreturn previous />
	</cffunction>
	
	<cffunction name="reset" access="public" output="false" returntype="void">
		<cfset variables.recordIndex = 0 />
	</cffunction>

	<cffunction name="end" access="public" output="false" returntype="void">
		<cfset variables.recordIndex = ArrayLen(variables.records) + 1 />
	</cffunction>

	<cffunction name="pageCount" access="public" output="false" returntype="numeric">
		<cfset var pageCount = 1 />
		<cfif structKeyExists(variables,"maxRecordsPerPage")>
			<cfset pageCount = Ceiling(recordCount()/variables.maxRecordsPerPage) />
		</cfif>
		<cfreturn pageCount />
	</cffunction>
	
	<cffunction name="recordCount" access="public" output="false" returntype="numeric">
		<cfset var recordCount = 0 />
		<cfif structKeyExists(variables,"records")>
			<cfset recordCount = ArrayLen(variables.records) />
		</cfif>
		<cfreturn recordCount />
	</cffunction>
	
	<cffunction name="setPage" access="public" output="false" returntype="void">
		<cfargument name="pageIndex" type="numeric" required="true">
		<cfset variables.pageIndex = arguments.pageIndex />
	</cffunction>
	
	<cffunction name="loadQuery" access="public" output="false" returntype="void">
		<cfargument name="rs" type="query" required="true">
		<cfargument name="maxRecordsPerPage" type="numeric" required="false">
		<cfset var i = 0 />
		<cfset var query = arguments.rs />
		<cfset variables.records = ArrayNew(1) />
		<cfloop index="i" from="1" to="#query.recordCount#">
			<cfset ArrayAppend(variables.records,queryRowToStruct(query,i)) />
		</cfloop>
		<cfif structKeyExists(arguments,"maxRecordsPerPage")>
			<cfset variables.maxRecordsPerPage = arguments.maxRecordsPerPage />
		</cfif>
	</cffunction>
	
	<cffunction name="queryRowToStruct" access="private" output="false" returntype="struct">
		<cfargument name="qry" type="query" required="true">
		
		<cfscript>
			/**
			 * Makes a row of a query into a structure.
			 * 
			 * @param query 	 The query to work with. 
			 * @param row 	 Row number to check. Defaults to row 1. 
			 * @return Returns a structure. 
			 * @author Nathan Dintenfass (nathan@changemedia.com) 
			 * @version 1, December 11, 2001 
			 */
			//by default, do this to the first row of the query
			var row = 1;
			//a var for looping
			var ii = 1;
			//the cols to loop over
			var cols = listToArray(qry.columnList);
			//the struct to return
			var stReturn = structnew();
			//if there is a second argument, use that for the row number
			if(arrayLen(arguments) GT 1)
				row = arguments[2];
			//loop over the cols and build the struct from the query row
			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
				stReturn[cols[ii]] = qry[cols[ii]][row];
			}		
			//return the struct
			return stReturn;
		</cfscript>
	</cffunction>
	
</cfcomponent>