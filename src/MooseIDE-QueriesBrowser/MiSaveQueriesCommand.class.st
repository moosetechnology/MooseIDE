"
I am a command that saves all current queries on disk as a STON file. The path is determined on the class side method
"
Class {
	#name : #MiSaveQueriesCommand,
	#superclass : #CmCommand,
	#instVars : [
		'afterCreationAction'
	],
	#category : #'MooseIDE-QueriesBrowser-Commands'
}

{ #category : #'accessing - defaults' }
MiSaveQueriesCommand class >> defaultDescription [

	^ 'Save all current queries on disk as a STON file'
]

{ #category : #'accessing - defaults' }
MiSaveQueriesCommand class >> defaultName [

	^ 'Save queries on disk'
]

{ #category : #'accessing - defaults' }
MiSaveQueriesCommand class >> iconName [

	^ #smallSaveAs
]

{ #category : #'accessing - defaults' }
MiSaveQueriesCommand class >> path [

	^ './pharo-local/queries-browser-saved-queries/'
]

{ #category : #'as yet unclassified' }
MiSaveQueriesCommand class >> stonFiles [

	| fileReference allFiles stonFiles |
	fileReference := self path asFileReference.
	allFiles := fileReference exists
		ifTrue: [ fileReference files ]
		ifFalse: [ #( ) ].
	stonFiles := allFiles select: [ :each | 
		             each basename endsWith: '.ston' ].
	^ stonFiles
]

{ #category : #accessing }
MiSaveQueriesCommand >> afterCreationAction: aBlock [

	afterCreationAction := aBlock
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

	| fileName file |
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
	file := self createFile: fileName.
	self write: self queriesToStore toFile: file.
	self triggerAfterCreationAction ] asJob run
]

{ #category : #initialization }
MiSaveQueriesCommand >> initialize [

	super initialize.
	afterCreationAction := [  ]
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
		TreeQueryHolder tree: each asOrderedCollection index: (topSortQueries indexOf: each) ].

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

	sortedTrees := trees sorted: [ :a :b | (a index) < (b index) ].
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

{ #category : #executing }
MiSaveQueriesCommand >> triggerAfterCreationAction [

	afterCreationAction value
]

{ #category : #'write on disk' }
MiSaveQueriesCommand >> write: queriesToStore toFile: file [

	file writeStreamDo: [ :stream | 
		STON put: queriesToStore onStream: stream ]
]
