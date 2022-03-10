Class {
	#name : #MiAbstractBrowser2,
	#superclass : #MiPresenter,
	#instVars : [
		'model',
		'receivingMode',
		'privateBus'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #layout }
MiAbstractBrowser2 class >> defaultLayout [

	^ SpBoxLayout newVertical
]

{ #category : #'world menu' }
MiAbstractBrowser2 class >> helpMessage [
	^ (self comment lines copyUpTo: '')
		fold: [ :s1 :s2 | s1 , Character cr asString , s2 ]
]

{ #category : #testing }
MiAbstractBrowser2 class >> isAbstract [ 
	^ self == MiAbstractBrowser
]

{ #category : #'world menu' }
MiAbstractBrowser2 class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: self midasBrowserMenuLabel)
		order: 8;
		parent: #Moose;
		icon: MooseIcons mooseIcon
]

{ #category : #'world menu' }
MiAbstractBrowser2 class >> menuMetaCommandOn: aBuilder [
	"need to be a separate method because of #miBrowsers pragma"
	<worldMenu>
	<miBrowsers>
	(aBuilder item: self metaBrowsersMenuLabel)
		order: 100;
		parent: (self midasBrowserMenuLabel);
		icon: MooseIcons mooseIcon
]

{ #category : #'world menu' }
MiAbstractBrowser2 class >> metaBrowsersMenuLabel [
	^ #Meta
]

{ #category : #'world menu' }
MiAbstractBrowser2 class >> midasBrowserMenuLabel [
	^ #'Specialized Browsers'
]

{ #category : #'instance creation' }
MiAbstractBrowser2 class >> newModel [
	"Override to return a model for your browser"

	^ nil
]

{ #category : #'instance creation' }
MiAbstractBrowser2 class >> open [

	self flag:
		'CodeSmell: Application is set in the MiAtomicWorkspace and the MiAbstractBrowser'.
	^ MiAtomicWorkspace new
		  application: self currentApplication;
		  containedBrowser: (self on: self newModel);
		  open;
		  followBus: self currentApplication defaultBus;
		  yourself
]

{ #category : #specs }
MiAbstractBrowser2 class >> title [
	^'MooseIDE browser'
]

{ #category : #specs }
MiAbstractBrowser2 class >> windowSize [
	^ 500 @ 400
]

{ #category : #opening }
MiAbstractBrowser2 >> adaptToDropInto: aBrowserContainer [

	"set new owner and follow its internal bus"

	self owner ifNotNil: [ :myContainer | 
		myContainer owner noteThatWidgetHasBeenReinstalled: self ].
	self owner: aBrowserContainer
]

{ #category : #converting }
MiAbstractBrowser2 >> asDraggableMorph [

	^ StringMorph contents: self title
]

{ #category : #'window control' }
MiAbstractBrowser2 >> browserClosed [

	
]

{ #category : #accessing }
MiAbstractBrowser2 >> buses [

	self flag:
		'Method present for compatibility reason. Should probably be removed'.
	^ {  }
]

{ #category : #testing }
MiAbstractBrowser2 >> canBeAdaptedToDropInto: aContainer [

	^ true
]

{ #category : #testing }
MiAbstractBrowser2 >> canFollow [

	^ true
]

{ #category : #testing }
MiAbstractBrowser2 >> canFollowEntity: anObject [

	"whether the browser accepts to deal with anObject"

	self subclassResponsibility
]

{ #category : #testing }
MiAbstractBrowser2 >> canHighlight [

	"Override to retrun true if you want to give your browser a highlight behavior. 
	This behavior should be define by overriding #highlightEntity:"

	^ false
]

{ #category : #testing }
MiAbstractBrowser2 >> canPropagate [

	| entity |
	entity := self miSelectedItem.
	^ entity isMooseObject and: [ 
		  entity asMooseGroup isNotEmpty or: [ entity isMooseModel ] ]
]

{ #category : #private }
MiAbstractBrowser2 >> desiredWindowSize [
	^self class windowSize
]

{ #category : #actions }
MiAbstractBrowser2 >> followEntity: anEntity [

	^ self subclassResponsibility
]

{ #category : #buses }
MiAbstractBrowser2 >> followPrivateBus: aBus [

	(self privateBus = aBus) ifTrue: [ ^ self ].
	self privateBus: aBus.
	aBus registerBrowser: self.
	self receiveFromPrivateBus: aBus logger mostRecentEntity
]

{ #category : #actions }
MiAbstractBrowser2 >> freezeDuring: aBlock [
	| previousMode |
	previousMode := receivingMode.
	receivingMode := MiFreezeMode.

	aBlock ensure: [ receivingMode := previousMode ]
]

{ #category : #actions }
MiAbstractBrowser2 >> highlightEntity: anEntity [

	"Override to add behavior on highlight. 
	Don't forget to override #canHighlight to return true"

	
]

{ #category : #testing }
MiAbstractBrowser2 >> ifAutonomous: aBlock [
	self flag: 'specific to MiLogBrowser ?'.
	self owner isNotNil and: [ 
		self owner isWindowPresenter ifTrue: aBlock ]
]

{ #category : #testing }
MiAbstractBrowser2 >> isMiBrowser [
	^ true
]

{ #category : #accessing }
MiAbstractBrowser2 >> miSelectedItem [

	^ (MiNoSelectedElementToPropagateException browser: self) signal
]

{ #category : #accessing }
MiAbstractBrowser2 >> model [
	^ model
]

{ #category : #accessing }
MiAbstractBrowser2 >> model: anObject [
	model := anObject
]

{ #category : #testing }
MiAbstractBrowser2 >> needUpdate: anEntity [

	^ anEntity ~= model selected
]

{ #category : #buses }
MiAbstractBrowser2 >> privateBus [
	^privateBus
]

{ #category : #buses }
MiAbstractBrowser2 >> privateBus: aBus [
	privateBus := aBus
]

{ #category : #testing }
MiAbstractBrowser2 >> receiveEntity: anEntity [

	"I am used by the Mi Application. You should use #globallySelect: anEntity that will transmit the message to me and the other browsers"

	receivingMode browser: self actOnEntity: anEntity.
	self updateToolbar
]

{ #category : #accessing }
MiAbstractBrowser2 >> receiveFromPrivateBus: anEntity [
	"If this browser is not in a workspace, it may have no receivingMode and this will crash
	 This is the expected behaviour"
	receivingMode browser: self actOnEntity: anEntity.

]

{ #category : #accessing }
MiAbstractBrowser2 >> receivingMode [

	^ receivingMode
]

{ #category : #accessing }
MiAbstractBrowser2 >> receivingMode: aReceivingMode [

	receivingMode := aReceivingMode
]

{ #category : #accessing }
MiAbstractBrowser2 >> sendEntitiesToPrivateBus [
	"An automatic propagate on the privateBus
	 There should always be a privateBus, but some tests create presenters outside of their browser"
	self privateBus ifNil: [ ^self ].
	self miSelectedItem
		ifNotNil: [ :entities |
			self freezeDuring: [ self privateBus globallySelect: entities ]
		]
]

{ #category : #'accessing - model' }
MiAbstractBrowser2 >> setModelBeforeInitialization: aModel [
	model := aModel
]

{ #category : #buses }
MiAbstractBrowser2 >> unfollowPrivateBus [

	self privateBus ifNil: [ ^ self ].
	
	self privateBus unregisterBrowser: self.
	self privateBus: nil.
]

{ #category : #actions }
MiAbstractBrowser2 >> updateToolbar [

	self window ifNotNil: [ :window | window updateToolbar ]
]

{ #category : #private }
MiAbstractBrowser2 >> windowTitle [
	^self class title
]
