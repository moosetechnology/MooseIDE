Extension { #name : #FamixReplicatedFragment }

{ #category : #'*MooseIDE-Duplication' }
FamixReplicatedFragment >> formatForDuplicationBrowser [
	"display string for the MiDuplicatinBrowser tool :
	 - number of members
	 - number of lines of code
	 - beginning of replicated fragment code"

	^String streamContents: [ :str |
		str
			<< self replicas size asString ;
			<< 'x' ;
			<< (self replicas anyOne length asString) ;
			<< ':' ;
			<< (self replicas anyOne codeText withSeparatorsCompacted truncateWithElipsisTo: 25)
	]
]
