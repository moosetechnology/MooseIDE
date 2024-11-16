Class {
	#name : #MiBrowserPresenter,
	#superclass : #MiOverviewItemPresenter,
	#instVars : [
		'closeButton',
		'topButton'
	],
	#category : #'MooseIDE-Core-Overview'
}

{ #category : #layout }
MiBrowserPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		  add: nameLabel;
		  add: topButton expand: false;
		  add: closeButton expand: false;
		  yourself
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
		             action: [
			             model withWindowDo: [ :window |
					             window
						             restore;
						             activate ] ];
		             yourself.
	closeButton := self newButton
		               iconName: #delete;
		               label: 'Close';
		               action: [ model withWindowDo: #close ];
		               yourself
]

{ #category : #settings }
MiBrowserPresenter >> toolbarLabel [
	^ model title
]
