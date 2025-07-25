Class {
	#name : #MiAbstractSingleSelectionSettingPresenter,
	#superclass : #MiAbstractSettingPresenter,
	#instVars : [
		'selectedButton',
		'buttons',
		'items'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #'event handling' }
MiAbstractSingleSelectionSettingPresenter >> activate: anItem [

	self subclassResponsibility
]

{ #category : #building }
MiAbstractSingleSelectionSettingPresenter >> connectButtons [

	selectedButton
		associatedRadioButtons: buttons;
		state: true
]

{ #category : #layout }
MiAbstractSingleSelectionSettingPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
]

{ #category : #building }
MiAbstractSingleSelectionSettingPresenter >> helpForItem: anItem [

	^ anItem printString
]

{ #category : #initialization }
MiAbstractSingleSelectionSettingPresenter >> initializePresenters [

	buttons := self items collect: [ :item |
			           | button |
			           button := self newRadioButtonFor: item.
			           self layout add: button.
			           button ].

	self connectButtons
]

{ #category : #testing }
MiAbstractSingleSelectionSettingPresenter >> isCurrentValue: anItem [

	self subclassResponsibility
]

{ #category : #accessing }
MiAbstractSingleSelectionSettingPresenter >> items [

	^ self subclassResponsibility 
]

{ #category : #building }
MiAbstractSingleSelectionSettingPresenter >> labelForItem: anItem [

	^ anItem printString
]

{ #category : #'instance creation' }
MiAbstractSingleSelectionSettingPresenter >> newRadioButtonFor: anItem [

	| button |
	button := self newRadioButton.
	button
		label: (self labelForItem: anItem);
		help: (self helpForItem: anItem);
		whenActivatedDo: [ self activate: anItem ].

	(self isCurrentValue: anItem) ifTrue: [ selectedButton := button ].

	^ button
]
