Class {
	#name : #MiAbstractBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'browser'
	],
	#category : #'Midas-Tests-Browsers'
}

{ #category : #testing }
MiAbstractBrowserTest class >> isAbstract [
	^ self == MiAbstractBrowserTest
]

{ #category : #running }
MiAbstractBrowserTest >> application [
	^ MiApplication current
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> assertCorrectPropagation [
	self mooseObjects
		do: [ :mooseObject | 
			self bus globallySelect: mooseObject.
			self assert: self bus logger logs size equals: 1.
			self bus logger clean ]
]

{ #category : #'tests - actions' }
MiAbstractBrowserTest >> assertFollowActionFor: aMooseObject [
	"Override to test follow action"

	self skip
]

{ #category : #'tests - actions' }
MiAbstractBrowserTest >> assertHighlightActionFor: aMooseObject [
	"Override to test highlight action"

	self skip
]

{ #category : #running }
MiAbstractBrowserTest >> browserClass [
	^ self subclassResponsibility
]

{ #category : #running }
MiAbstractBrowserTest >> bus [
	^ self application busNamed: 'TestBus'
]

{ #category : #running }
MiAbstractBrowserTest >> mooseObjects [
	^ {MooseEntity new.
	MooseGroup new.
	(MooseGroup with: MooseEntity new).
	MooseModel new.
	(MooseModel with: MooseEntity new)}
]

{ #category : #running }
MiAbstractBrowserTest >> nonOpenedBrowser [
	^ (self browserClass on: self browserClass newModel)
		followBus: self bus;
		yourself
]

{ #category : #running }
MiAbstractBrowserTest >> setUp [
	super setUp.
	browser := self browserClass runMeFollowing: self bus
]

{ #category : #running }
MiAbstractBrowserTest >> tearDown [
	browser window ifNotNil: [ :window | window close ].
	self application deleteBus: self bus.
	super tearDown
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testBrowserHasATitle [
	self deny: browser window title equals: 'Untitled window'
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpen [
	| browserToOpen |
	browserToOpen := self nonOpenedBrowser.
	[ self
		shouldnt: [ browserToOpen openWithSpec.
			{Object new} , self mooseObjects
				do: [ :object | browserToOpen selectEntity: object ] ]
		raise: Error ]
		ensure: [ browserToOpen window close ]
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testDoNotPropagateWhenReceiving [
	browser follow.
	self assertCorrectPropagation.
	browser freeze.
	self assertCorrectPropagation.
	browser highlight.
	self assertCorrectPropagation
]

{ #category : #'tests - actions' }
MiAbstractBrowserTest >> testFollowAction [
	browser follow.
	self mooseObjects
		do: [ :mooseObject | 
			self bus globallySelect: mooseObject.
			self assertFollowActionFor: mooseObject ]
]

{ #category : #'tests - actions' }
MiAbstractBrowserTest >> testHighlightAction [
	browser highlight.
	self mooseObjects
		do: [ :mooseObject | 
			self bus globallySelect: mooseObject.
			self assertHighlightActionFor: mooseObject ]
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testRunMeFollowing [
	self assert: browser bus identicalTo: self bus.
	self assert: (self bus browsers includes: browser)
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testWindowClosedAction [
	browser window close.
	self deny: (self bus browsers includes: browser).
	self deny: (self application browsers includes: browser)
]
