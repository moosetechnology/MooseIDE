Class {
	#name : #MiExportBrowserNewColumnPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'addButton',
		'closeButton',
		'block',
		'name',
		'exportModel'
	],
	#category : #'MooseIDE-Export-Browser'
}

{ #category : #accessing }
MiExportBrowserNewColumnPresenter >> addButtonAction [

	| producedBlock |
	producedBlock := Smalltalk compiler evaluate: block text.
	exportModel addColumnForQuery: producedBlock withName: name text.
	self window close
]

{ #category : #accessing }
MiExportBrowserNewColumnPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: name expand: false;
		  add: block;
		  add: (SpBoxLayout newLeftToRight
				   add: closeButton;
				   add: addButton;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : #accessing }
MiExportBrowserNewColumnPresenter >> defaultTitle [
	^ 'Create Query Column'
]

{ #category : #accessing }
MiExportBrowserNewColumnPresenter >> exportModel [

	^ exportModel
]

{ #category : #accessing }
MiExportBrowserNewColumnPresenter >> exportModel: anObject [

	exportModel := anObject
]

{ #category : #accessing }
MiExportBrowserNewColumnPresenter >> initializePresenters [

	addButton := self newButton.
	closeButton := self newButton.

	name := self newTextInput text: 'Custom Column'.

	addButton
		label: 'Add column';
		icon: (self iconNamed: #smallAdd);
		action: [ self addButtonAction ].

	closeButton
		label: 'Close';
		icon: (self iconNamed: #glamorousClose);
		action: [ self window close ].
	block := (self instantiate: SpCodePresenter)
		       "  beForScripting;"
		         text: '[ :entity |  ]';
		         yourself.
	self whenDisplayDo: [ block selectionInterval: (13 to: 12) ]
]

{ #category : #accessing }
MiExportBrowserNewColumnPresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle
]
