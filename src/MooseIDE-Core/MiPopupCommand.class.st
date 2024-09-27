Class {
	#name : #MiPopupCommand,
	#superclass : #MiCommand,
	#instVars : [
		'toolbarButton',
		'buttonIsPressed'
	],
	#category : #'MooseIDE-Core-Command'
}

{ #category : #converting }
MiPopupCommand >> asSpecCommand [

	| specCommand |
	specCommand := super asSpecCommand.

	specCommand buildPresenterBlock: [ :cmd |
		toolbarButton := SpToolbarToggleButtonPresenter new
			                 icon: (self iconNamed: self class defaultIconName);
			                 help: self dynamicDescription;
			                 label: self dynamicName;
			                 whenActivatedDo: [ self execute ];
			                 yourself.
		toolbarButton eventHandler
			whenMouseDownDo: [ :evt | buttonIsPressed := true ];
			whenMouseUpDo: [ :evt | buttonIsPressed := false ].
		toolbarButton ].

	^ specCommand
]

{ #category : #executing }
MiPopupCommand >> execute [

	self newPopover popup
]

{ #category : #initialization }
MiPopupCommand >> initialize [

	super initialize.
	buttonIsPressed := false
]

{ #category : #executing }
MiPopupCommand >> newPopover [

	| helpPopover |
	helpPopover := (SpPopoverPresenter newApplication:
			                self context application)
		               relativeTo: toolbarButton;
		               presenter: self popupContent;
		               yourself.

	helpPopover eventHandler whenFocusLostDo: [
		buttonIsPressed ifFalse: [ toolbarButton beUnselected ] ].

	^ helpPopover
]

{ #category : #converting }
MiPopupCommand >> popupContent [

	self subclassResponsibility
]
