Class {
	#name : #MiHelpCommand,
	#superclass : #MiCommand,
	#instVars : [
		'helpIsOpen',
		'currentHelp',
		'toolbarButton'
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
			whenToggledDo: [ self execute ]                 
			"whenActivatedDo: [
				                 self execute.
				                 toolbarButton ];
			                 whenDeactivatedDo: [ currentHelp dismiss ]";
			                 yourself ].

	^ specCommand
]

{ #category : #executing }
MiHelpCommand >> execute [
self crTrace: toolbarButton state.
"	toolbarButton state ifFalse: [ ^ self ]."

	currentHelp := (SpPopoverPresenter newApplication:
			                self context application)
		               relativeTo: self context helpPopoverSource;
		               bePositionLeft;
		               presenter: self popupContent;
		               yourself.

	currentHelp eventHandler whenFocusLostDo: [
		toolbarButton beUnselected ].

	^ currentHelp popup
]

{ #category : #initialization }
MiHelpCommand >> initialize [

	super initialize.
	helpIsOpen := false
]

{ #category : #converting }
MiHelpCommand >> popupContent [

	^ (SpTextPresenter newApplication: self context application)
		  text: self context helpText;
		  beNotEditable;
		  addStyle: 'help';
		  yourself
]
