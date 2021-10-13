"
Load a set of already saved queries into the queries browser
"
Class {
	#name : #MiLoadQueriesPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'filteringListPresenter',
		'closeButton'
	],
	#category : #'MooseIDE-QueriesBrowser-Widgets'
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

{ #category : #initialization }
MiLoadQueriesPresenter >> initializeButtons [

	closeButton := self newButton.
	closeButton label: 'Ok'
]

{ #category : #initialization }
MiLoadQueriesPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: filteringListPresenter;
			 add: closeButton expand: false;
			 yourself)
]

{ #category : #initialization }
MiLoadQueriesPresenter >> initializeList [

	filteringListPresenter := self newFilteringList.
	filteringListPresenter
		items: MiSaveQueriesCommand stonFiles;
		display: [ :each | each basename withoutPeriodSuffix ].
	filteringListPresenter listPresenter
		sortingBlock: #basename ascending
]

{ #category : #initialization }
MiLoadQueriesPresenter >> initializePresenters [

	self initializeList.
	self initializeButtons.
	self initializeLayout
]

{ #category : #accessing }
MiLoadQueriesPresenter >> okAction: aBlock [

	closeButton action: aBlock
]

{ #category : #actions }
MiLoadQueriesPresenter >> resetItems [

	filteringListPresenter items: MiSaveQueriesCommand stonFiles
]

{ #category : #accessing }
MiLoadQueriesPresenter >> selectedFile [

	^ filteringListPresenter selectedItem
]
