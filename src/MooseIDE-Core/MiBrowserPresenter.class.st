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
	midasModel followBus: aBus
]

{ #category : #actions }
MiBrowserPresenter >> deactivateItem: aBus [
	midasModel unfollowBus: aBus
]

{ #category : #actions }
MiBrowserPresenter >> highlightWindow [
	midasModel window beep
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
			             midasModel window window
				             expand;
				             activate ];
		             yourself.
	closeButton := self newButton
		               iconName: #delete;
		               label: 'Close';
		               action: [ midasModel window close ];
		               yourself.
		
	self initializeLayout
]

{ #category : #settings }
MiBrowserPresenter >> toolbarLabel [
	^ midasModel title
]
