Class {
	#name : #MiBrowserPresenter,
	#superclass : #MiMidasItemPresenter,
	#instVars : [
		'closeButton',
		'topButton'
	],
	#category : #'MooseIDE-Core-Overview'
}

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
MiBrowserPresenter >> initializeLayout [

	self layout: (SpBoxLayout newHorizontal
		add: nameLabel;
		add: SpNullPresenter new;
		add: topButton expand: false;
		add: closeButton expand: false;
		yourself)
]

{ #category : #initialization }
MiBrowserPresenter >> initializePresenters [

	super initializePresenters.
	topButton := self newButton
		             iconName: #window;
		             label: 'Put on top';
		             action: [ 
			             model window window
				             expand;
				             activate ];
		             yourself.
	closeButton := self newButton
		               iconName: #delete;
		               label: 'Close';
		               action: [ model window close ];
		               yourself.
		
	self initializeLayout
]

{ #category : #settings }
MiBrowserPresenter >> toolbarLabel [
	^ model title
]
