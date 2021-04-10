Class {
	#name : #MiBusPresenter,
	#superclass : #MiMidasItemPresenter,
	#instVars : [
		'loggerButton'
	],
	#category : #'Midas-Core-Overview'
}

{ #category : #specs }
MiBusPresenter class >> tableHeight [
	^ self currentApplication browsers size * self tableLineHeight
]

{ #category : #specs }
MiBusPresenter class >> toolbarLayout [
	^ SpBoxLayout newHorizontal
		add: #nameLabel;
		add: SpNullPresenter new;
		add: #loggerButton expand: false;
		yourself
]

{ #category : #actions }
MiBusPresenter >> activateItem: aBrowser [
	aBrowser followBus: model
]

{ #category : #actions }
MiBusPresenter >> deactivateItem: aBrowser [
	aBrowser unfollowBus: model
]

{ #category : #initialization }
MiBusPresenter >> initializePresenters [
	super initializePresenters.
	loggerButton := self newButton
		iconName: #history;
		label: 'Open logger';
		action: [ MiLogBrowser runMeFollowing: model ]
]

{ #category : #settings }
MiBusPresenter >> tableCheckBoxEvaluation [
	^ [ :browser | browser buses includes: model ]
]

{ #category : #settings }
MiBusPresenter >> tableItems [
	^ self application browsers asOrderedCollection
]

{ #category : #settings }
MiBusPresenter >> tableStringEvaluation [
	^ [ :browser | browser title ]
]

{ #category : #settings }
MiBusPresenter >> toolbarLabel [
	^ model name
]
