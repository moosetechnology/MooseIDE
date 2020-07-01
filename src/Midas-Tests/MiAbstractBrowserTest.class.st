Class {
	#name : #MiAbstractBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'currentLogs',
		'concreteBrowsers'
	],
	#category : #'Midas-Tests'
}

{ #category : #running }
MiAbstractBrowserTest >> application [
	^ MiApplication current
]

{ #category : #tests }
MiAbstractBrowserTest >> assertAllBrowsersOpenOn: anObject [
	concreteBrowsers
		do: [ :browser | 
			self
				shouldnt: [ | browserInstance |
					browserInstance := browser runMe.
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
MiAbstractBrowserTest >> setUp [
	super setUp.
	currentLogs := MiApplication current logger logs.
	MiApplication current logger logs: OrderedCollection new.
	concreteBrowsers := MiAbstractBrowser allSubclasses
		reject: #isAbstract
]

{ #category : #running }
MiAbstractBrowserTest >> tearDown [
	MiApplication current logger logs: currentLogs.
	super tearDown
]

{ #category : #tests }
MiAbstractBrowserTest >> testAllBrowserHaveATitle [
	concreteBrowsers
		do: [ :browser | 
			| browserInstance |
			browserInstance := browser runMe.
			[ self deny: browserInstance window title equals: 'Untitled window' ]
				ensure: [ browserInstance window close ] ]
]

{ #category : #tests }
MiAbstractBrowserTest >> testBrowsersDoNotPropagateWhenReceiving [
	| browsers |
	browsers := concreteBrowsers collect: [ :browser | browser runMe ].
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
	concreteBrowsers
		do: [ :browser | 
			self
				shouldnt: [ | browserInstance |
					browserInstance := browser runMe.
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
