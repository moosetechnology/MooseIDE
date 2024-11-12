Class {
	#name : #MiBusPresenter,
	#superclass : #MiOverviewItemPresenter,
	#instVars : [
		'loggerButton'
	],
	#category : #'MooseIDE-Core-Overview'
}

{ #category : #layout }
MiBusPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		  add: nameLabel;
		  add: loggerButton expand: false;
		  yourself
]

{ #category : #initialization }
MiBusPresenter >> initializePresenters [

	super initializePresenters.
	loggerButton := self newButton
		                iconName: #history;
		                label: 'Open logger';
		                action: [
			                MiBusLogBrowser
				                openForBus: model
				                application: application ]
]

{ #category : #settings }
MiBusPresenter >> toolbarLabel [
	^ model name
]
