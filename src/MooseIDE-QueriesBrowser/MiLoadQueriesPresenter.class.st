"
Load a set of already saved queries into the queries browser.

Width of popover is forced in #initializeLayout
"
Class {
	#name : #MiLoadQueriesPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'filteringListPresenter',
		'closeButton',
		'directoryPathInput',
		'directory',
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

{ #category : #initialization }
MiLoadQueriesPresenter >> acceptAction [

	^ [ 
	  owner dismiss.
	  queriesListPresenter constructQueries: self loadQueries ]
]

{ #category : #actions }
MiLoadQueriesPresenter >> chooseDirectory [

	| newDirectory popupOwner |
	"Opening the file tool will dismiss the popup. We need to open it again."
	popupOwner := owner.

	newDirectory := UIManager default
		                chooseDirectory: 'Select saved queries folder'
		                path: directory.

	newDirectory ifNotNil: [ 
		self setDirectory: newDirectory.
		directoryPathInput text: newDirectory pathString ].

	popupOwner popup
]

{ #category : #initialization }
MiLoadQueriesPresenter >> initialize [

	directory := MiSaveQueriesCommand directory.
	super initialize
]

{ #category : #initialization }
MiLoadQueriesPresenter >> initializeButton [

	closeButton := self newButton.
	closeButton
		label: 'Ok';
		action: self acceptAction
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
			 add: filteringListPresenter width: 200; "This forces the popover to have this width"
			 add: closeButton expand: false;
			 yourself)
]

{ #category : #initialization }
MiLoadQueriesPresenter >> initializeList [

	filteringListPresenter := self newFilteringList.

	filteringListPresenter
		items: (directory allChildrenMatching: '*.ston');
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
		                      placeholder: directory pathString;
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
	self initializeButton.
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

	directory := aFileReference.
	filteringListPresenter items:
		(directory allChildrenMatching: '*.ston')
]

{ #category : #'accessing - model' }
MiLoadQueriesPresenter >> setModelBeforeInitialization: aQueriesListPresenter [

	queriesListPresenter := aQueriesListPresenter
]
