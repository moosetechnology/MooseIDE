Class {
	#name : #MiAbstractBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'browser'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #testing }
MiAbstractBrowserTest class >> isAbstract [
	^ self == MiAbstractBrowserTest
]

{ #category : #running }
MiAbstractBrowserTest >> application [
	^ MiTestApplication current
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
MiAbstractBrowserTest >> assertFollowBuses: someBuses [
	"Browser knows buses"

	self assertCollection: browser buses hasSameElements: someBuses.

	"Only correct buses know browser"
	someBuses
		do: [ :bus | self assert: (bus browsers includes: browser) ].
	self application buses \ someBuses
		do: [ :bus | self deny: (bus browsers includes: browser) ].

	"Bus Button"
	self
		assert: browser busButton label
		equals: (self buttonLabelForBuses: someBuses).
	(someBuses collect: #name) , {'Click to edit'}
		do:
			[ :str | self assert: (browser busButton help includesSubstring: str) ]
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

	^ self application defaultBus
]

{ #category : #'tests - buses' }
MiAbstractBrowserTest >> buttonLabelForBuses: someBuses [
	someBuses ifEmpty: [ ^ 'No bus' ].
	someBuses size = 1
		ifTrue: [ ^ 'Bus: ' , someBuses anyOne name ].
	^ '{1} buses' format: {someBuses size}
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
	MiTestApplication reset.
	browser := self browserClass openForTests
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
	self assertFollowBuses: {self bus}.

	"Two buses"
	otherBus := self application busNamed: 'Other bus'.
	[ browser followBus: otherBus.
	self
		assertFollowBuses:
			{self bus.
			otherBus} ]
		ensure: [ browser unfollowBus: otherBus.
			self application deleteBus: otherBus ]
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
	| otherBus |
	otherBus := self application busNamed: 'Other bus'.
	[ browser followBus: otherBus.
	browser unfollowBus: self bus.
	self assertFollowBuses: {otherBus} ]
		ensure: [ browser unfollowBus: otherBus.
			self application deleteBus: otherBus ]
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testWindowClosedAction [
	browser window close.
	self deny: (self bus browsers includes: browser).
	self deny: (self application browsers includes: browser)
]
