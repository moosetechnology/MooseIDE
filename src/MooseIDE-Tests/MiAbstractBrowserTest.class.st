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

	^ self application defaultBus
]

{ #category : #running }
MiAbstractBrowserTest >> mooseObjects [

	^ { 
		  MooseEntity new.
		  MooseGroup new.
		  (MooseModel with: MooseEntity new) entities asMooseGroup.
		  MooseModel new.
		  (MooseModel with: MooseEntity new) }
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

	self deny: browser window title equals: SpPresenter title
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnEmptyBus [

	| newBrowser |
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnEmptyMooseGroup [

	| newBrowser |
	self bus globallySelect: MooseGroup new.
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnEmptyMooseModel [

	| newBrowser |
	self bus globallySelect: MooseModel new.
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnMooseEntity [

	| newBrowser |
	self bus globallySelect: MooseEntity new.
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnMooseGroup [

	| newBrowser |
	self bus globallySelect:
		(MooseModel with: MooseEntity new) entities asMooseGroup.
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnMooseModel [

	| newBrowser |
	self bus globallySelect: (MooseModel with: MooseEntity new).
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnNil [

	| newBrowser |
	self bus globallySelect: nil.
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnObject [

	| newBrowser |
	self bus globallySelect: Object new.
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - receiving' }
MiAbstractBrowserTest >> testDoNotPropagateWhenReceivingInFollowMode [

	browser privateReceivingMode: MiFollowMode.
	self mooseObjects do: [ :object | 
		browser receiveEntity: object.
		self assertEmpty: self bus logger logs ]
]

{ #category : #'tests - receiving' }
MiAbstractBrowserTest >> testDoNotPropagateWhenReceivingInFreezeMode [

	browser privateReceivingMode: MiFreezeMode.
	self mooseObjects do: [ :object | 
		browser receiveEntity: object.
		self assertEmpty: self bus logger logs ]
]

{ #category : #'tests - receiving' }
MiAbstractBrowserTest >> testDoNotPropagateWhenReceivingInHighlightMode [

	browser privateReceivingMode: MiHighlightMode.
	self mooseObjects do: [ :object | 
		browser receiveEntity: object.
		self assertEmpty: self bus logger logs ]
]

{ #category : #'tests - buses' }
MiAbstractBrowserTest >> testFollowBus [

	self assertCollection: browser buses hasSameElements: { self bus }.
	self assert: (self bus browsers includes: browser).

	self assert: browser busButton label equals: 'Bus: Test'
]

{ #category : #'tests - buses' }
MiAbstractBrowserTest >> testFollowBusTriggersSelectEntity [

	| propagatedEntity |
	propagatedEntity := MooseEntity new.
	
	browser stub.
	
	self bus globallySelect: propagatedEntity.
	
	browser followBus: self bus.
	browser should receive receiveEntity: propagatedEntity
]

{ #category : #'tests - actions' }
MiAbstractBrowserTest >> testFollowEntity [

	browser privateReceivingMode: MiFollowMode.
	self mooseObjects do: [ :mooseObject | 
		self bus globallySelect: mooseObject.
		self assertFollowActionFor: mooseObject ]
]

{ #category : #'tests - buses' }
MiAbstractBrowserTest >> testFollowOtherBus [

	| otherBus |
	otherBus := self application busNamed: 'Other bus'.
	browser followBus: otherBus.

	self assertCollection: browser buses hasSameElements: { 
			self bus.
			otherBus }.

	self assert: (otherBus browsers includes: browser).
	self assert: (self bus browsers includes: browser).

	self assert: browser busButton label equals: '2 buses'
]

{ #category : #'tests - actions' }
MiAbstractBrowserTest >> testHighlightEntity [

	browser privateReceivingMode: MiHighlightMode.
	self mooseObjects do: [ :mooseObject | 
		self bus globallySelect: mooseObject.
		self assertHighlightActionFor: mooseObject ]
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testSettingsAction [
	"must be redefined in browsers that do have settings"

	self deny: browser hasSettings
]

{ #category : #'tests - buses' }
MiAbstractBrowserTest >> testUnfollowBus [

	browser unfollowBus: self bus.

	self assertEmpty: browser buses.
	self deny: (self bus browsers includes: browser).

	self assert: browser busButton label equals: 'No bus'
]

{ #category : #'tests - closing' }
MiAbstractBrowserTest >> testWindowClosedAction [

	browser window close.
	self deny: (self bus browsers includes: browser).
	self deny: (self application browsers includes: browser)
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testWindowOpeningAction [

	self assert: (self bus browsers includes: browser).
	self assert: (self application browsers includes: browser)
]
