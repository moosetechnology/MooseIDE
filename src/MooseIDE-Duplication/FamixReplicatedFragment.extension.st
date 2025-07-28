Extension { #name : #FamixReplicatedFragment }

{ #category : #'*MooseIDE-Duplication' }
FamixReplicatedFragment >> displayStringOn: aStream [
	"Display string for MiDuplicatinBrowser:
	 - number of members
	 - number of lines of code
	 - beginning of replicated fragment code"

	aStream
		<< self replicas size asString;
		<< 'x';
		<< self replicas anyOne length asString;
		<< ':';
		<< (self replicas anyOne codeText withSeparatorsCompacted
				 truncateWithElipsisTo: 25)
]
