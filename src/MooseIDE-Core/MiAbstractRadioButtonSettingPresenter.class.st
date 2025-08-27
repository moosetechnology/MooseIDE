Class {
	#name : 'MiAbstractRadioButtonSettingPresenter',
	#superclass : 'MiAbstractSettingPresenter',
	#instVars : [
		'selectedButton',
		'buttons'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'event handling' }
MiAbstractRadioButtonSettingPresenter >> activate: anItem [

	self subclassResponsibility
]

{ #category : 'building' }
MiAbstractRadioButtonSettingPresenter >> connectButtons [

	selectedButton
		associatedRadioButtons: buttons;
		state: true
]

{ #category : 'layout' }
MiAbstractRadioButtonSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
]

{ #category : 'building' }
MiAbstractRadioButtonSettingPresenter >> helpForItem: anItem [

	^ anItem printString
]

{ #category : 'initialization' }
MiAbstractRadioButtonSettingPresenter >> initializePresenters [

	buttons := self items collect: [ :item |
			           | button |
			           button := self newRadioButtonFor: item.
			           self layout add: button.
			           button ].

	self connectButtons
]

{ #category : 'testing' }
MiAbstractRadioButtonSettingPresenter >> isCurrentValue: anItem [

	self subclassResponsibility
]

{ #category : 'accessing' }
MiAbstractRadioButtonSettingPresenter >> items [

	^ self subclassResponsibility 
]

{ #category : 'building' }
MiAbstractRadioButtonSettingPresenter >> labelForItem: anItem [

	^ anItem printString
]

{ #category : 'instance creation' }
MiAbstractRadioButtonSettingPresenter >> newRadioButtonFor: anItem [

	| button |
	button := self newRadioButton.
	button
		label: (self labelForItem: anItem);
		help: (self helpForItem: anItem);
		whenActivatedDo: [ self activate: anItem ].

	(self isCurrentValue: anItem) ifTrue: [ selectedButton := button ].

	^ button
]
