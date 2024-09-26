Class {
	#name : #MiHelpCommand,
	#superclass : #MiCommand,
	#instVars : [
		'toolbarButton',
		'buttonIsPressed'
	],
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiHelpCommand class >> defaultDescription [

	^ 'What does this browser do?'
]

{ #category : #default }
MiHelpCommand class >> defaultIconName [

	^ #help
]

{ #category : #default }
MiHelpCommand class >> defaultName [

	^ 'Help'
]

{ #category : #converting }
MiHelpCommand >> asSpecCommand [

	| specCommand |
	specCommand := super asSpecCommand.

	specCommand buildPresenterBlock: [ :cmd |
		toolbarButton := SpToolbarToggleButtonPresenter new
			                 icon: specCommand icon;
			                 label: self name;
			                 whenActivatedDo: [ self execute ];
			                 yourself.
		toolbarButton eventHandler
			whenMouseDownDo: [ :evt | buttonIsPressed := true ];
			whenMouseUpDo: [ :evt | buttonIsPressed := false ].
		toolbarButton ].

	^ specCommand
]

{ #category : #executing }
MiHelpCommand >> execute [

	| helpPopover |
	helpPopover := (SpPopoverPresenter newApplication:
			                self context application)
		               relativeTo: self context helpPopoverSource;
		               bePositionLeft;
		               presenter: self popupContent;
		               yourself.

	helpPopover eventHandler whenFocusLostDo: [
		buttonIsPressed ifFalse: [ toolbarButton beUnselected ] ].

	^ helpPopover popup
]

{ #category : #initialization }
MiHelpCommand >> initialize [

	super initialize.
	buttonIsPressed := false
]

{ #category : #converting }
MiHelpCommand >> popupContent [

	^ (SpTextPresenter newApplication: self context application)
		  text: self context helpText;
		  beNotEditable;
		  addStyle: 'help';
		  yourself
]
