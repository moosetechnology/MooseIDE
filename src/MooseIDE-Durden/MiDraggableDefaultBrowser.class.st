Class {
	#name : #MiDraggableDefaultBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'widget',
		'widgetClass',
		'window'
	],
	#category : #'MooseIDE-Durden'
}

{ #category : #specs }
MiDraggableDefaultBrowser class >> defaultLayout [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #buttonFollow width: 65;
				add: #buttonFreeze width: 60;
				add: #buttonHighlight width: 80;
				add: SpBoxLayout newHorizontal expand: true;
				add: #busButton;
				add: SpBoxLayout newHorizontal expand: true;
				add: #buttonInspect width: self iconWidth;
				add: #buttonPropagate expand: false;
				add: #buttonHelp width: self iconWidth;
				yourself)
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		  add: #widget;
		  yourself
]

{ #category : #specs }
MiDraggableDefaultBrowser class >> runMe [ 
	self error: 'This class cannot runme out of the box, is just a frame'
]

{ #category : #specs }
MiDraggableDefaultBrowser class >> runMeWith: aClass [

	^ self
		  runMeWith: aClass
		  following: self currentApplication defaultBus
]

{ #category : #specs }
MiDraggableDefaultBrowser class >> runMeWith: aClass following: aBus [

	^ (self on: self newModel)
		  widgetClass: aClass;
		  open;
		  followBus: aBus;
		  yourself
]

{ #category : #'as yet unclassified' }
MiDraggableDefaultBrowser >> adaptToDropInto: aDropDestination [

	window close.
	^ widget
]

{ #category : #initialization }
MiDraggableDefaultBrowser >> application [
	 ^ application
]

{ #category : #'as yet unclassified' }
MiDraggableDefaultBrowser >> canBeAdaptedToDropInto: aDestination [
	^ true
]

{ #category : #initialization }
MiDraggableDefaultBrowser >> close [ 
	 window close 
]

{ #category : #initialization }
MiDraggableDefaultBrowser >> followAction [

	^ widget followAction
]

{ #category : #initialization }
MiDraggableDefaultBrowser >> initializePresenters [

	self widgetClass ifNotNil: [ 
		widget := self instantiate: self widgetClass ]
]

{ #category : #initialization }
MiDraggableDefaultBrowser >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	window := aWindow.
	widget ifNotNil: [ window title: widget title ]
]

{ #category : #initialization }
MiDraggableDefaultBrowser >> instantiateWidget: aWidget [

	| b |
	b := self instantiate: aWidget.
	b browser: self.
	^ b
]

{ #category : #initialization }
MiDraggableDefaultBrowser >> miSelectedItem [

	^ widget miSelectedItem
]

{ #category : #testing }
MiDraggableDefaultBrowser >> noteThatWidgetHasBeenClosed: anAlceSourceCodeWidget [

	widget = anAlceSourceCodeWidget ifTrue: [ self close ]
]

{ #category : #initialization }
MiDraggableDefaultBrowser >> propagate: aWidget [ 
	 self propagate. 
]

{ #category : #initialization }
MiDraggableDefaultBrowser >> receiveEntity: anEntity [

	widget receiveEntity: anEntity.

]

{ #category : #accessing }
MiDraggableDefaultBrowser >> widget: anAlceInvocableWidget [ 
	widget := anAlceInvocableWidget.
]

{ #category : #initialization }
MiDraggableDefaultBrowser >> widgetClass [

	^ widgetClass
]

{ #category : #initialization }
MiDraggableDefaultBrowser >> widgetClass: aClass [

	widgetClass := aClass.
	widget := self instantiateWidget: self widgetClass.

	window ifNotNil: [ window title: widget title ]
]
