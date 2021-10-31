Class {
	#name : #MiAbstractBrowser2,
	#superclass : #MiPresenter,
	#instVars : [
		'model',
		'buses',
		'receivingMode'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #specs }
MiAbstractBrowser2 class >> actionsCommandGroupFor: presenter [

	^ CmCommandGroup forSpec
		  name: 'Actions';
		  register:
			  (MiPropagateCommand forSpecContext: presenter)
				  beDisplayedOnRightSide;
		  register:
			  (MiInspectCommand forSpecContext: presenter)
				  beDisplayedOnRightSide
]

{ #category : #specs }
MiAbstractBrowser2 class >> defaultSpec [

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
	self flag: 'CodeSmell: Application is set in the MiAtomicWorkspace and the MiAbstractBrowser'.
	^MiAtomicWorkspace new
		application: self currentApplication;
		containedBrowser: (self on: self newModel) ;
		openWithSpec ;
		followBus: self currentApplication defaultBus;
		yourself
]

{ #category : #specs }
MiAbstractBrowser2 class >> windowSize [
	^ 500 @ 400
]

{ #category : #opening }
MiAbstractBrowser2 >> adaptToDropInto: aDropDestination [
]

{ #category : #testing }
MiAbstractBrowser2 >> canFollow [

	^ true
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

{ #category : #testing }
MiAbstractBrowser2 >> canReceiveEntity: anObject [

	"whether the browser accepts to deal with anObject"

	self subclassResponsibility
]

{ #category : #actions }
MiAbstractBrowser2 >> followEntity: anEntity [

	^ self subclassResponsibility
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

{ #category : #'accessing - model' }
MiAbstractBrowser2 >> setModelBeforeInitialization: aModel [
	model := aModel
]
