"
I am a command that saves all current queries on disk as a STON file. The path is determined on the class side method
"
Class {
	#name : #MiSaveQueriesCommand,
	#superclass : #CmCommand,
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

	^ './pharo-local/queries-browser-cache/'
]

{ #category : #executing }
MiSaveQueriesCommand >> execute [

	| fileName file queriesToStore |
	queriesToStore := self queriesToStore.
	fileName := UIManager default
		            request: 'Name of the file: '
		            initialAnswer: ''.
	file := (self class path , fileName , '.ston') asFileReference.
	file ensureCreateFile.
	file writeStreamDo: [ :stream | 
		STON put: queriesToStore onStream: stream ]
]

{ #category : #executing }
MiSaveQueriesCommand >> queriesToStore [

	| queriesToStore queries |
	queries := self context famixQueries.
	"Since we are resetting the result and changing the parent of the queries,
	we don't want to do that on the original queries to keep the queries browser
	still running. So we will use a copy of the objects"
	
	"queriesToStore := queries collect: [ :each | each copy ]."
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
