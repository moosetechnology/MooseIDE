Class {
	#name : #MiAbstractBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'currentLogs',
		'concreteBrowsers'
	],
	#category : #'Midas-Tests'
}

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

	MiApplication default globallySelect: MooseModel new.
	self assert: MiApplication default logger logs size equals: 1.
	MiApplication default logger clean.

	"Propagate a mooseGroup"
	MiApplication default globallySelect: MooseGroup new.
	self assert: MiApplication default logger logs size equals: 1.
	MiApplication default logger clean.

	"Propagate a mooseEntity"
	MiApplication default globallySelect: MooseEntity new.
	self assert: MiApplication default logger logs size equals: 1.
	MiApplication default logger clean
]

{ #category : #running }
MiAbstractBrowserTest >> setUp [
	super setUp.
	currentLogs := MiApplication default logger logs.
	MiApplication default logger logs: OrderedCollection new.
	concreteBrowsers := MiAbstractBrowser allSubclasses
		reject: #isAbstract
]

{ #category : #running }
MiAbstractBrowserTest >> tearDown [
	MiApplication default logger logs: currentLogs.
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
	MiApplication default
		freezeBrowsersDuring: [ browsers := concreteBrowsers collect: [ :browser | browser runMe ].
			[ browsers do: #follow.
			self assertCorrectPropagation.
			browsers do: #freeze.
			self assertCorrectPropagation.
			browsers do: #highlight.
			self assertCorrectPropagation ]
				ensure: [ browsers do: [ :browser | browser window close ] ] ]
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
