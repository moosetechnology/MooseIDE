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
MiAbstractBrowserTest >> assertCorrectPropagation: mooseModel [
	MiApplication current globallySelect: mooseModel.
	self assert: MiApplication current logger logs size equals: 1.
	MiApplication current logger clean
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
			self deny: browserInstance window title equals: 'Untitled window'.
			browserInstance window close ]
]

{ #category : #tests }
MiAbstractBrowserTest >> testBrowsersDoNotPropagateWhenFollowing [
	concreteBrowsers := MiAbstractBrowser allSubclasses
		reject: #isAbstract
		thenCollect: #runMe.
	[ self assertCorrectPropagation: MooseModel new.
	self assertCorrectPropagation: MooseGroup new.
	self assertCorrectPropagation: MooseEntity new ]
		ensure: [ concreteBrowsers
				do: [ :browserInstance | browserInstance window close ] ]
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
