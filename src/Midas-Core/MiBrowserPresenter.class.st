Class {
	#name : #MiBrowserPresenter,
	#superclass : #MiMidasItemPresenter,
	#instVars : [
		'closeButton',
		'topButton'
	],
	#category : #'Midas-Core-Overview'
}

{ #category : #specs }
MiBrowserPresenter class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #nameLabel;
		add: SpNullPresenter new;
		add: #topButton expand: false;
		add: #closeButton expand: false;
		yourself
]

{ #category : #actions }
MiBrowserPresenter >> activateItem: aBus [
	model followBus: aBus
]

{ #category : #actions }
MiBrowserPresenter >> deactivateItem: aBus [
	model unfollowBus: aBus
]

{ #category : #actions }
MiBrowserPresenter >> highlightWindow [
	model window beep
]

{ #category : #initialization }
MiBrowserPresenter >> initializePresenters [
	super initializePresenters.
	topButton := self newButton
		iconName: #window;
		label: 'Put on top';
		action: [ model window window activate ];
		yourself.
	closeButton := self newButton
		iconName: #delete;
		label: 'Close';
		action: [ model window close ];
		yourself
]

{ #category : #settings }
MiBrowserPresenter >> toolbarLabel [
	^ model title
]
