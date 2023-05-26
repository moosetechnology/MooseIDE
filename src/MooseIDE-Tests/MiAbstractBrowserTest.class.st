Class {
	#name : #MiAbstractBrowserTest,
	#superclass : #MiAbstractApplicationTest,
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

	  ^ application
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

	  application defaultBus: self bus.
	  browser := self browserClass openForTests: self application
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
			newBrowser := self browserClass openForTests: self application.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnEmptyMooseGroup [

	| newBrowser |
	self bus globallySelect: MooseGroup new.
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests: self application.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnEmptyMooseModel [

	| newBrowser |
	self bus globallySelect: MooseModel new.
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests: self application.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnMooseEntity [

	| newBrowser |
	self bus globallySelect: MooseEntity new.
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests: self application.
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
			newBrowser := self browserClass openForTests: self application.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnMooseModel [

	| newBrowser |
	self bus globallySelect: (MooseModel with: MooseEntity new).
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests: self application.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnNil [

	| newBrowser |
	self bus globallySelect: nil.
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests: self application.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenOnObject [

	| newBrowser |
	self bus globallySelect: Object new.
	self
		shouldnt: [ 
			newBrowser := self browserClass openForTests: self application.
			newBrowser window close ]
		raise: Error
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testCanOpenSettings [

	browser hasSettings ifFalse: [ self skip ].
	"this should not raise an error"
	browser settings.
  "tear down"
	[ browser closeSettings ]
		on: Error
		do: [ "nothing -- ensuring settings window is closed" ]
]

{ #category : #'tests - tags' }
MiAbstractBrowserTest >> testCanTagEntities [

	self assert: browser canTagEntities
]

{ #category : #'tests - tags' }
MiAbstractBrowserTest >> testDefaultSelectedTagIsNil [
	self assert: browser selectedTag isNil
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
MiAbstractBrowserTest >> testFollowBusSetsDefaultBus [

	self assert: browser application defaultBus name equals: 'Test' .

	browser application busNamed: 'aNewBus'.
	self assert: browser application defaultBus name equals: 'aNewBus' .

	browser application busNamed: 'Test'.
	self assert: browser application defaultBus name equals: 'aNewBus' .
	
	browser followBus: (browser application busNamed: 'Test').
	self assert: browser application defaultBus name equals: 'Test' .
	
	
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

	| otherBus oldDefaultBus |
	oldDefaultBus := self bus.
	otherBus := self application busNamed: 'Other bus'.
	browser followBus: otherBus.

	self assertCollection: browser buses hasSameElements: { 
			self bus.
			oldDefaultBus }.

	self assert: (oldDefaultBus browsers includes: browser).
	self assert: (self bus browsers includes: browser).

	self assert: browser busButton label equals: '2 buses'
]

{ #category : #tests }
MiAbstractBrowserTest >> testHelpHasSomeInformation [

	self assert:
		(browser class comment includesSubstring: 'Accepted entities:')
]

{ #category : #'tests - actions' }
MiAbstractBrowserTest >> testHighlightEntity [

	browser privateReceivingMode: MiHighlightMode.
	self mooseObjects do: [ :mooseObject | 
		self bus globallySelect: mooseObject.
		self assertHighlightActionFor: mooseObject ]
]

{ #category : #'tests - tags' }
MiAbstractBrowserTest >> testSelectedTagSetAndGet [
	browser canTagEntities ifFalse: [ self skip ].

	self subclassResponsibility 
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testSettingsAction [
	"must be redefined in browsers that do have settings"

	self deny: browser hasSettings
]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testSettingsClickCancel [

	browser hasSettings ifFalse: [ self skip ].

	self
		shouldnt: [ 
			browser settings.
			browser model settings buttonCancel click ]
		raise: Error.

]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testSettingsClickOK [

	browser hasSettings ifFalse: [ self skip ].

	self
		shouldnt: [ 
			browser settings.
			browser model settings buttonOk click ]
		raise: Error.

]

{ #category : #'tests - opening' }
MiAbstractBrowserTest >> testSettingsClickReset [

	browser hasSettings ifFalse: [ self skip ].

	self
		shouldnt: [ 
			browser settings.
			browser model settings buttonReset click ]
		raise: Error.

	[ browser closeSettings ] on: Error do: [ "nothing -- ensuring settings window is closed as REset does not do it" ]
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
