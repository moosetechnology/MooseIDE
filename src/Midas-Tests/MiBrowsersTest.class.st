Class {
	#name : #MiBrowsersTest,
	#superclass : #TestCase,
	#instVars : [
		'browser'
	],
	#category : #'Midas-Tests'
}

{ #category : #testing }
MiBrowsersTest class >> isAbstract [
	^ self == MiBrowsersTest
]

{ #category : #asserting }
MiBrowsersTest >> assertFollowActionFor: aMooseObject [
	"Override to test follow action"

	self skip
]

{ #category : #asserting }
MiBrowsersTest >> assertHighlightActionFor: aMooseObject [
	"Override to test highlight action"

	self skip
]

{ #category : #running }
MiBrowsersTest >> bus [
	^ MiApplication current busNamed: 'TestBus'
]

{ #category : #running }
MiBrowsersTest >> mooseObjects [
	^ {MooseEntity new.
	MooseGroup new.
	MooseModel new}
]

{ #category : #running }
MiBrowsersTest >> setUp [
	"No 'super setUp' because it does 'self classToTest new' which does not provide a model before initialization."

	browser := (self classToTest on: self classToTest newModel)
		followBus: self bus;
		yourself
]

{ #category : #running }
MiBrowsersTest >> tearDown [
	MiApplication current deleteBus: self bus.
	super tearDown
]

{ #category : #tests }
MiBrowsersTest >> testFollowAction [
	browser follow.
	self mooseObjects
		do: [ :mooseObject | 
			self bus globallySelect: mooseObject.
			self assertFollowActionFor: mooseObject ]
]

{ #category : #tests }
MiBrowsersTest >> testHighlightAction [
	browser highlight.
	self mooseObjects
		do: [ :mooseObject | 
			self bus globallySelect: mooseObject.
			self assertHighlightActionFor: mooseObject ]
]
