"
Load a set of already saved queries into the queries browser
"
Class {
	#name : #MiLoadQueriesPresenter,
	#superclass : #SpPresenter,
	#category : #'MooseIDE-QueriesBrowser-Commands'
}

{ #category : #default }
MiLoadQueriesPresenter class >> defaultDescription [

	^ 'Load a set of saved queries into the browser'
]

{ #category : #default }
MiLoadQueriesPresenter class >> defaultName [

	^ 'Load saved queries'
]

{ #category : #accessing }
MiLoadQueriesPresenter class >> iconName [

	^ #smallLoadProject
]

{ #category : #executing }
MiLoadQueriesPresenter >> execute [

	| stonFiles filteringList |
	stonFiles := self getQueriesStonFiles.
	filteringList := self newListForPopoverExtent: 150 @ 150.
	filteringList
		items: stonFiles;
		display: [ :each | each basename ]
]

{ #category : #executing }
MiLoadQueriesPresenter >> getQueriesStonFiles [

	| allFiles stonFiles |
	allFiles := MiSaveQueriesCommand path asFileReference files.
	stonFiles := allFiles select: [ :each | each basename endsWith: '.ston' ].
	^ stonFiles
]
