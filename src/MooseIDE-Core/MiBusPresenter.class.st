Class {
	#name : #MiBusPresenter,
	#superclass : #MiMidasItemPresenter,
	#instVars : [
		'loggerButton'
	],
	#category : #'MooseIDE-Core-Overview'
}

{ #category : #actions }
MiBusPresenter >> activateItem: aBrowser [
	aBrowser followBus: midasModel
]

{ #category : #actions }
MiBusPresenter >> deactivateItem: aBrowser [
	aBrowser unfollowBus: midasModel
]

{ #category : #initialization }
MiBusPresenter >> initializeLayout [

	self layout: (SpBoxLayout newHorizontal
		add: nameLabel;
		add: SpNullPresenter new;
		add: loggerButton expand: false;
		yourself)
]

{ #category : #initialization }
MiBusPresenter >> initializePresenters [

	super initializePresenters.
	loggerButton := self newButton
		                iconName: #history;
		                label: 'Open logger';
		                action: [ MiBusLogBrowser openForBus: midasModel application: application ].
	self initializeLayout
]

{ #category : #settings }
MiBusPresenter >> toolbarLabel [
	^ midasModel name
]
