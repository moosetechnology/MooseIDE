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
	"file readStreamDo: [ :stream | 
		newCollection := STON fromStream: stream ]"
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
	queriesToStore := OrderedCollection new.
	queries do: [ :each | queriesToStore add: each copy ].
	"For the unary queries that have a root query as a parent
	we put the parent as nil. Because we don't want to store root queries. 
	Also we don't want to store the result of the queries"
	queriesToStore do: [ :each | 
		each isUnaryQuery ifTrue: [ 
			each parent isRootQuery ifTrue: [ each parent: nil ] ].
		each resetResult ].
	^ queriesToStore
]
