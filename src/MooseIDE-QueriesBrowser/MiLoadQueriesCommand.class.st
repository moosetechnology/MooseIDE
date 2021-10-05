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

	| allFiles stonFiles filteringList |
	allFiles := MiSaveQueriesCommand path asFileReference files.
	stonFiles := allFiles select: [ :each | 
		             each basename endsWith: '.ston' ].
	filteringList := self newListForPopoverExtent: 150 @ 150.
	filteringList
		items: stonFiles;
		display: [ :each | each basename ].
	Halt now
]

{ #category : #'instance creation' }
MiLoadQueriesCommand >> newListForPopoverExtent: aPoint [

	^ SpFilteringListPresenter new layout: (SpBoxLayout newTopToBottom
			   add: SpFilteringListPresenter defaultSpec
			   withConstraints: [ :c | 
				   c
					   height: aPoint x;
					   width: aPoint y ];
			   yourself)
]
