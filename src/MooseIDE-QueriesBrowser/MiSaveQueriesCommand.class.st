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

{ #category : #executing }
MiSaveQueriesCommand >> afterCreationAction [

	afterCreationAction value
]

{ #category : #accessing }
MiSaveQueriesCommand >> afterCreationAction: aBlock [

	afterCreationAction := aBlock
]

{ #category : #executing }
MiSaveQueriesCommand >> createFile: fileName [

	| file |
	file := (self class path , fileName , '.ston') asFileReference.
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
	(fileName isNil or: [ fileName isEmpty ]) ifTrue: [ 
		UIManager inform: 'You need to specify a name for the file.'.
		^ self ].

	file := self createFile: fileName.
	self write: self queriesToStore toFile: file.
	self afterCreationAction.
]

{ #category : #sorting }
MiSaveQueriesCommand >> putChildrenInPlace: topSortQueries [

	| trees topSortCopy toBeAdded sortedTrees |
	trees := Dictionary new.
	topSortCopy := topSortQueries copy asOrderedCollection.
	toBeAdded := topSortCopy select: [ :each | each parent isNil ].
	toBeAdded do: [ :each |
		trees at: each asOrderedCollection put: (topSortQueries indexOf: each).
		topSortCopy remove: each ].

	[ topSortCopy isNotEmpty ] whileTrue: [ 
		| toBeRemoved newCollection |
		toBeRemoved := OrderedCollection new.
		topSortCopy do: [ :each | 
			trees keys
				detect: [ :collection | collection includes: each parent ]
				ifFound: [ :collection |
					newCollection := collection copyWith: each.
					trees
						at: newCollection
						put: ((topSortQueries indexOf: each) max: (trees at: collection)).
					trees removeKey: collection.
					toBeRemoved add: each ] ].
		topSortCopy removeAll: toBeRemoved ].
	
	sortedTrees := trees keys sorted: [ :a :b | (trees at: a) < (trees at: b) ].
	^ sortedTrees flattened

]

{ #category : #executing }
MiSaveQueriesCommand >> queriesToStore [

	| queriesToStore queries |
	queries := self context famixQueries.
	"Since we are resetting the result and changing the parent of the queries, we don't want to do that on the original queries to keep the queries browser still running.
	So, we will use a copy of the objects. We need to make an intelligent copiing of the objects. Because if a query has a parent we must change parent to the new parent. For now it's not done.  "
	
	queriesToStore := queries.
	
	"For the unary queries that have a root query as a parent
	we put the parent as nil. Because we don't want to store root queries. 
	Also we don't want to store the result of the queries"
	queriesToStore do: [ :each | 
		self resetResultFor: each.
		each isUnaryQuery ifTrue: [ 
			each parent isRootQuery ifTrue: [ each parent: nil ] ] ].
	^ queriesToStore
]

{ #category : #executing }
MiSaveQueriesCommand >> resetResultFor: aQuery [

	aQuery resetResult.
	aQuery parent ifNotNil: [ :parent | self resetResultFor: parent ]
]

{ #category : #sorting }
MiSaveQueriesCommand >> topologicalSortForQueries: queries [

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
MiSaveQueriesCommand >> write: queriesToStore toFile: file [

	file writeStreamDo: [ :stream | 
		STON put: queriesToStore onStream: stream ]
]
