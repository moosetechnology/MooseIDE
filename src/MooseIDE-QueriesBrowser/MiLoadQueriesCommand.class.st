"
Load a set of already saved queries into the queries browser
"
Class {
	#name : #MiLoadQueriesCommand,
	#superclass : #CmCommand,
	#category : #'MooseIDE-QueriesBrowser-Commands'
}

{ #category : #default }
MiLoadQueriesCommand class >> defaultDescription [

	^ 'Load a set of saved queries into the browser'
]

{ #category : #default }
MiLoadQueriesCommand class >> defaultName [

	^ 'Load saved queries'
]

{ #category : #accessing }
MiLoadQueriesCommand class >> iconName [

	^ #smallLoadProject
]

{ #category : #executing }
MiLoadQueriesCommand >> execute [

	| allFiles |
	allFiles := MiSaveQueriesCommand path asFileReference files
]
