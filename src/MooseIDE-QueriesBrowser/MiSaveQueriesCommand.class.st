"
I am a command that saves all current queries on disk as a STON file. The path is determined on the class side method
"
Class {
	#name : #MiSaveQueriesCommand,
	#superclass : #MiCommand,
	#classVars : [
		'Directory'
	],
	#category : #'MooseIDE-QueriesBrowser-Commands'
}

{ #category : #'accessing - defaults' }
MiSaveQueriesCommand class >> defaultDescription [

	^ 'Save all current queries on disk as a STON file'
]

{ #category : #default }
MiSaveQueriesCommand class >> defaultIconName [

	^ #smallSaveAs
]

{ #category : #'accessing - defaults' }
MiSaveQueriesCommand class >> defaultName [

	^ 'Save queries on disk'
]

{ #category : #'accessing - defaults' }
MiSaveQueriesCommand class >> defaultPath [

	^ './pharo-local/queries-browser-saved-queries/'
]

{ #category : #'accessing - defaults' }
MiSaveQueriesCommand class >> directory [

	^ Directory ifNil: [ Directory := self defaultPath asFileReference ]
]

{ #category : #'accessing - defaults' }
MiSaveQueriesCommand class >> directory: aDirectory [

	Directory := aDirectory
]

{ #category : #accessing }
MiSaveQueriesCommand class >> path [

	^ self directory pathString , '/'
]

{ #category : #actions }
MiSaveQueriesCommand >> copyQueriesReferencesOf: queries [

	"We don't want to do that on the original queries to keep the queries browser still running"

	| copy |
	copy := queries veryDeepCopy.
	^ copy
]

{ #category : #'write on disk' }
MiSaveQueriesCommand >> createFile: fileName [

	| file |
	file := UIManager default
		        chooseForSaveFileReference: 'Choose directory'
		        extensions: #( 'ston' )
		        path: (self class path , fileName , '.ston') asFileReference.

	file ensureCreateFile.

	^ file
]

{ #category : #executing }
MiSaveQueriesCommand >> execute [

	| fileName |
	fileName := UIManager default
		            request: 'Name of the file: '
		            initialAnswer: ''.
	"If the user pressed the cancel button"
	fileName ifNil: [ ^ self ].

	"If user did not provide any file name"
	fileName ifEmpty: [ 
		UIManager inform: 'You need to specify a name for the file.'.
		^ self ].

	[ :job | 
	job title: 'Saving queries on disk'.
	self write: self queriesToStore toFileNamed: fileName ] asJob run
]

{ #category : #sorting }
MiSaveQueriesCommand >> putChildrenInPlace: topSortQueries [
	"This method sorts the queries to put a query directly under its parent KEEPING the topological sorting"

	| trees topSortCopy toBeAdded sortedTrees |
	trees := Dictionary new.
	topSortCopy := topSortQueries copy asOrderedCollection.
	toBeAdded := topSortCopy select: [ :each | each parent isNil ].
	trees := toBeAdded collect: [ :each |
		         topSortCopy remove: each.
		         TreeQueryHolder
			         tree: (OrderedCollection with: each)
			         index: (topSortQueries indexOf: each) ].

	[ topSortCopy isNotEmpty ] whileTrue: [
		| toBeRemoved |
		toBeRemoved := OrderedCollection new.
		topSortCopy do: [ :each |
			trees
				detect: [ :tree | tree tree includes: each parent ]
				ifFound: [ :tree |
					tree addQuery: each.
					tree index: ((topSortQueries indexOf: each) max: tree index).
					toBeRemoved add: each ] ].
		topSortCopy removeAll: toBeRemoved ].

	sortedTrees := trees sorted: [ :a :b | a index < b index ].
	^ (sortedTrees collect: #tree) flattened
]

{ #category : #actions }
MiSaveQueriesCommand >> putNilAsParentForRootQuery: aQuery [

	aQuery isUnaryQuery ifTrue: [
		aQuery parent isRootQuery ifTrue: [ aQuery parent: nil ] ]
]

{ #category : #actions }
MiSaveQueriesCommand >> queriesToStore [

	| queriesToStore topSortedQueries uiSortedQueries |
	queriesToStore := self copyQueriesReferencesOf: self context famixQueries.

	"For the unary queries that have a root query as a parent we put the parent as nil.
	Also we don't want to store the result of the queries"
	queriesToStore do: [ :each |
		self resetResultFor: each.
		self putNilAsParentForRootQuery: each ].

	topSortedQueries := self topologicalSortForQueries: queriesToStore.
	uiSortedQueries := self putChildrenInPlace: topSortedQueries.
	^ uiSortedQueries
]

{ #category : #actions }
MiSaveQueriesCommand >> resetResultFor: aQuery [

	aQuery resetResult.
	aQuery parent ifNotNil: [ :parent | self resetResultFor: parent ]
]

{ #category : #sorting }
MiSaveQueriesCommand >> topologicalSortForQueries: queries [

	"Gives the topological sort for the list of queries passed as argument. A topological sort assures that a query always comes after its dependencies.
	Note that this can cause that a query will not be directly under its parent."

	| sortedQueries queriesWithDependencies  |
	sortedQueries :=
		OrderedCollection withAll: (queries select: [ :query | query dependencies isEmpty ]).
	queriesWithDependencies :=
		(queries select: [ :query | query dependencies isNotEmpty ]) asOrderedCollection.

	[ queriesWithDependencies isNotEmpty ] whileTrue: [
		| toBeAdded |
		toBeAdded := queriesWithDependencies select: [ :firstQuery |
			firstQuery dependencies allSatisfy: [ :secondQuery |
				sortedQueries includes: secondQuery ] ].
		sortedQueries addAll: toBeAdded.
		queriesWithDependencies removeAll: toBeAdded ].
	^ sortedQueries
]

{ #category : #'write on disk' }
MiSaveQueriesCommand >> write: queriesToStore toFile: file [

	file writeStreamDo: [ :stream |
		STON put: queriesToStore onStream: stream ]
]

{ #category : #'write on disk' }
MiSaveQueriesCommand >> write: queriesToStore toFileNamed: aFilename [

	| file |
	file := UIManager default
		        chooseForSaveFileReference: 'Choose directory'
		        extensions: #( 'ston' )
		        path:
		        (self class path , aFilename , '.ston') asFileReference.

	file ifNotNil: [ 
		file ensureCreateFile.
		file writeStreamDo: [ :stream | 
			STON put: queriesToStore onStream: stream ] ]
]
