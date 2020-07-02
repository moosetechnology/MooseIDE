Class {
	#name : #MiAbstractBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'currentLogs'
	],
	#category : #'Midas-Tests'
}

{ #category : #running }
MiAbstractBrowserTest >> application [
	^ MiApplication current
]

{ #category : #tests }
MiAbstractBrowserTest >> assertAllBrowsersOpenOn: anObject [
	self concreteBrowsers
		do: [ :browser | 
			self
				shouldnt: [ | browserInstance |
					browserInstance := browser runMeFollowing: self bus.
					browserInstance selectEntity: anObject.
					browserInstance root close ]
				raise: Error ]
]

{ #category : #tests }
MiAbstractBrowserTest >> assertCorrectPropagation [
	"Propagate a mooseModel"

	self application globallySelect: MooseModel new.
	self assert: self application logger logs size equals: 1.
	self application logger clean.

	"Propagate a mooseGroup"
	self application globallySelect: MooseGroup new.
	self assert: self application logger logs size equals: 1.
	self application logger clean.

	"Propagate a mooseEntity"
	self application globallySelect: MooseEntity new.
	self assert: self application logger logs size equals: 1.
	self application logger clean
]

{ #category : #running }
MiAbstractBrowserTest >> bus [
	^ self application busNamed: 'TestBus'
]

{ #category : #running }
MiAbstractBrowserTest >> concreteBrowsers [
	^ MiAbstractBrowser allSubclasses reject: #isAbstract
]

{ #category : #running }
MiAbstractBrowserTest >> setUp [
	super setUp.
	currentLogs := MiApplication current logger logs.
	MiApplication current logger logs: OrderedCollection new
]

{ #category : #running }
MiAbstractBrowserTest >> tearDown [
	self application logger logs: currentLogs.
	self application deleteBus: self bus.
	super tearDown
]

{ #category : #tests }
MiAbstractBrowserTest >> testAllBrowserHaveATitle [
	self concreteBrowsers
		do: [ :browser | 
			| browserInstance |
			browserInstance := browser runMeFollowing: self bus.
			[ self deny: browserInstance window title equals: 'Untitled window' ]
				ensure: [ browserInstance window close ] ]
]

{ #category : #tests }
MiAbstractBrowserTest >> testBrowsersDoNotPropagateWhenReceiving [
	| browsers |
	browsers := self concreteBrowsers collect: [ :browser | browser runMeFollowing: self bus ].
	[ browsers do: #follow.
	self assertCorrectPropagation.
	browsers do: #freeze.
	self assertCorrectPropagation.
	browsers do: #highlight.
	self assertCorrectPropagation ]
		ensure: [ browsers do: [ :browser | browser window close ] ]
]

{ #category : #tests }
MiAbstractBrowserTest >> testCanOpenAllBrowser [
	self concreteBrowsers
		do: [ :browser | 
			self
				shouldnt: [ | browserInstance |
					browserInstance := browser runMeFollowing: self bus.
					browserInstance root close ]
				raise: Error ]
]

{ #category : #tests }
MiAbstractBrowserTest >> testCanOpenAllBrowserWithAnObject [
	self assertAllBrowsersOpenOn: Object new
]

{ #category : #tests }
MiAbstractBrowserTest >> testCanOpenAllBrowserWithEmptyMooseGroup [
	self assertAllBrowsersOpenOn: MooseGroup new
]

{ #category : #tests }
MiAbstractBrowserTest >> testCanOpenAllBrowserWithMooseEntity [
	self assertAllBrowsersOpenOn: MooseEntity new
]

{ #category : #tests }
MiAbstractBrowserTest >> testCanOpenAllBrowserWithMooseGroup [
	self assertAllBrowsersOpenOn: (MooseGroup with: MooseEntity new)
]

{ #category : #tests }
MiAbstractBrowserTest >> testFollowBus [
	| browser |
	browser := self concreteBrowsers anyOne runMeFollowing: self bus.
	browser followBus: self bus.
	self assert: browser bus identicalTo: self bus.
	self assert: (self bus browsers includes: browser).
	browser window close
]

{ #category : #tests }
MiAbstractBrowserTest >> testRunMeFollowing [
	self concreteBrowsers
		do: [ :browserClass | 
			| browser |
			[ browser := browserClass runMeFollowing: self bus.
			self assert: browser bus identicalTo: self bus.
			self assert: (self bus browsers includes: browser) ]
				ensure: [ browser window close ] ]
]

{ #category : #tests }
MiAbstractBrowserTest >> testWindowClosedAction [
	self concreteBrowsers
		do: [ :browserClass | 
			| browser |
			browser := browserClass runMeFollowing: self bus.
			browser window close.
			self deny: (self bus browsers includes: browser) ]
]
