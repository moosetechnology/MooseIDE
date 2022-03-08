"
Load a set of already saved queries into the queries browser
"
Class {
	#name : #LoadQueriesPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'filteringListPresenter',
		'closeButton'
	],
	#category : #'MooseIDE-QueriesBrowser-Widgets'
}

{ #category : #default }
LoadQueriesPresenter class >> defaultDescription [

	^ 'Load a set of saved queries into the browser'
]

{ #category : #default }
LoadQueriesPresenter class >> defaultName [

	^ 'Load saved queries'
]

{ #category : #accessing }
LoadQueriesPresenter class >> iconName [

	^ #smallLoadProject
]

{ #category : #initialization }
LoadQueriesPresenter >> initializeButtons [

	closeButton := self newButton.
	closeButton label: 'Ok'
]

{ #category : #initialization }
LoadQueriesPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: filteringListPresenter;
			 add: closeButton expand: false;
			 yourself)
]

{ #category : #initialization }
LoadQueriesPresenter >> initializeList [

	filteringListPresenter := self newFilteringList.
	filteringListPresenter
		items: MiSaveQueriesCommand stonFiles;
		display: [ :each | each basename withoutPeriodSuffix ].
	filteringListPresenter listPresenter
		sortingBlock: #basename ascending
]

{ #category : #initialization }
LoadQueriesPresenter >> initializePresenters [

	self initializeList.
	self initializeButtons.
	self initializeLayout
]

{ #category : #accessing }
LoadQueriesPresenter >> okAction: aBlock [

	closeButton action: aBlock
]

{ #category : #actions }
LoadQueriesPresenter >> resetItems [

	filteringListPresenter items: MiSaveQueriesCommand stonFiles
]

{ #category : #accessing }
LoadQueriesPresenter >> selectedFile [

	^ filteringListPresenter selectedItem
]
