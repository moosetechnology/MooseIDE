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

{ #category : #'tests - buses' }
MiAbstractBrowserTest >> assertFollowSecondBus: otherBus [
	browser followBus: otherBus.
	self
		assertCollection: browser buses
		hasSameElements:
			{self bus.
			otherBus}.
	self assert: (otherBus browsers includes: browser).
	self assert: browser busButton label equals: '2 buses'.
	^ {self bus name.
	'Other bus'}
		do:
			[ :name | self assert: (browser busButton help includesSubstring: name) ]
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
	| newBrowser |
	"Empty bus"
	self
		shouldnt: [ newBrowser := self browserClass runMeFollowing: self bus.
			newBrowser window close ]
		raise: Error.

	"With object"
	{Object new} , self mooseObjects
		do: [ :object | 
			self bus globallySelect: object.
			self
				shouldnt: [ newBrowser := self browserClass runMeFollowing: self bus.
					newBrowser window close ]
				raise: Error ]
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

{ #category : #'tests - buses' }
MiAbstractBrowserTest >> testFollowBus [
	| otherBus |
	"One bus"
	browser followBus: self bus.
	self assertCollection: browser buses hasSameElements: {self bus}.
	self assert: (self bus browsers includes: browser).
	self assert: browser busButton label equals: 'Bus: ' , self bus name.
	{self bus name.
	'Click to edit'}
		do:
			[ :name | self assert: (browser busButton help includesSubstring: name) ].

	"Two buses"
	otherBus := self application busNamed: 'Other bus'.
	[ self assertFollowSecondBus: otherBus ]
		ensure: [ self application deleteBus: otherBus ]
]

{ #category : #'tests - buses' }
MiAbstractBrowserTest >> testFollowBusTriggersSelectEntity [
	browser stub.
	{Object new} , self mooseObjects
		do: [ :object | 
			self bus globallySelect: object.
			browser followBus: self bus.
			browser should receive selectEntity: object ]
]

{ #category : #'tests - actions' }
MiAbstractBrowserTest >> testHighlightAction [
	browser highlight.
	self mooseObjects
		do: [ :mooseObject | 
			self bus globallySelect: mooseObject.
			self assertHighlightActionFor: mooseObject ]
]

{ #category : #'tests - buses' }
MiAbstractBrowserTest >> testUnfollowBus [
	browser unfollowBus: self bus.
	self deny: (browser buses includes: self bus).
	self deny: (self bus browsers includes: browser).
	self assert: browser busButton label equals: 'No bus'.
	self assert: browser busButton help equals: 'Click to edit'
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testWindowClosedAction [
	browser window close.
	self deny: (self bus browsers includes: browser).
	self deny: (self application browsers includes: browser)
]
