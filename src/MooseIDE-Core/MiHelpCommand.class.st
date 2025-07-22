Class {
	#name : 'MiHelpCommand',
	#superclass : 'MiPopupCommand',
	#category : 'MooseIDE-Core-Command',
	#package : 'MooseIDE-Core',
	#tag : 'Command'
}

{ #category : 'default' }
MiHelpCommand class >> defaultDescription [

	^ 'What does this browser do?'
]

{ #category : 'default' }
MiHelpCommand class >> defaultIconName [

	^ #help
]

{ #category : 'default' }
MiHelpCommand class >> defaultName [

	^ 'Help'
]

{ #category : 'executing' }
MiHelpCommand >> newPopover [

	^ super newPopover
		  bePositionLeft;
		  yourself
]

{ #category : 'converting' }
MiHelpCommand >> popupContent [

	^ (SpTextPresenter newApplication: self context application)
		  text: self context helpText;
		  beNotEditable;
		  addStyle: 'help';
		  yourself
]
