"
Load a set of already saved queries into the queries browser.

Width of popover is forced in #initializeLayout
"
Class {
	#name : #MiLoadQueriesPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'filteringListPresenter',
		'directoryPathInput',
		'directorySelectionButton',
		'queriesListPresenter'
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

{ #category : #accessing }
MiLoadQueriesPresenter class >> tilte [

	^ self defaultName
]

{ #category : #actions }
MiLoadQueriesPresenter >> acceptAction [

	^ [ 
	  self withWindowDo: [ :window | window close ].
	  queriesListPresenter constructQueries: self loadQueries ]
]

{ #category : #actions }
MiLoadQueriesPresenter >> chooseDirectory [

	| newDirectory |
	newDirectory := UIManager default
		                chooseDirectory: 'Select saved queries folder'
		                path: MiSaveQueriesCommand directory.

	newDirectory ifNotNil: [ 
		self setDirectory: newDirectory.
		directoryPathInput text: newDirectory pathString ]
]

{ #category : #initialization }
MiLoadQueriesPresenter >> initializeDialogWindow: aDialogWindow [

	aDialogWindow initialExtent: 250 @ 300.
	aDialogWindow title: self class title.
	aDialogWindow
		addButton: 'Ok' do: self acceptAction;
		addButton: 'Cancel' do: [ :dialog | dialog close ]
]

{ #category : #initialization }
MiLoadQueriesPresenter >> initializeDirectorySelectionButton [

	directorySelectionButton := self newButton
		                            action: [ self chooseDirectory ];
		                            icon: (self iconNamed: #mooseFolder);
		                            yourself
]

{ #category : #initialization }
MiLoadQueriesPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: (SpBoxLayout newLeftToRight
					  spacing: 5;
					  add: directoryPathInput;
					  add: directorySelectionButton width: 25;
					  yourself)
			 height: self class toolbarHeight;
			 add: filteringListPresenter;
			 yourself)
]

{ #category : #initialization }
MiLoadQueriesPresenter >> initializeList [

	filteringListPresenter := self newFilteringList.

	filteringListPresenter
		items: (MiSaveQueriesCommand directory exists
				 ifTrue: [ 
					 MiSaveQueriesCommand directory allChildrenMatching: '*.ston' ]
				 ifFalse: [ #(  ) ]);
		display: [ :each | each basename withoutPeriodSuffix ].

	filteringListPresenter listPresenter sortingBlock:
		#basename ascending.

	filteringListPresenter listPresenter
		activateOnDoubleClick;
		whenActivatedDo: self acceptAction
]

{ #category : #initialization }
MiLoadQueriesPresenter >> initializePathInputField [

	directoryPathInput := self newTextInput
		                      placeholder: MiSaveQueriesCommand directory pathString;
		                      whenSubmitDo: [ 
			                      directoryPathInput text ifNotEmpty: [ 
					                      self setDirectory:
							                      directoryPathInput text asFileReference ] ];
		                      yourself
]

{ #category : #initialization }
MiLoadQueriesPresenter >> initializePresenters [

	self initializePathInputField.
	self initializeDirectorySelectionButton.
	self initializeList.

	self initializeLayout
]

{ #category : #actions }
MiLoadQueriesPresenter >> loadQueries [

	^ [ 
	  self selectedFile readStreamDo: [ :stream | 
		  STON fromStream: stream ] ] onErrorDo: [ #(  ) ]
]

{ #category : #accessing }
MiLoadQueriesPresenter >> selectedFile [

	^ filteringListPresenter selectedItem
]

{ #category : #actions }
MiLoadQueriesPresenter >> setDirectory: aFileReference [

	aFileReference exists ifFalse: [ 
		self inform: 'This directory does not exist'.
		filteringListPresenter items: #(  ).
		^ self ].

	MiSaveQueriesCommand directory: aFileReference.
	filteringListPresenter items:
		(MiSaveQueriesCommand directory allChildrenMatching: '*.ston')
]

{ #category : #'accessing - model' }
MiLoadQueriesPresenter >> setModelBeforeInitialization: aQueriesListPresenter [

	queriesListPresenter := aQueriesListPresenter
]
