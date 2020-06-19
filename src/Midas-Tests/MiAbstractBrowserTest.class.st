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
MiAbstractBrowserTest >> assertCorrectPropagation: mooseModel [
	MiApplication current globallySelect: mooseModel.
	self assert: MiApplication current logger logs size equals: 1.
	MiApplication current logger clean
]

{ #category : #running }
MiAbstractBrowserTest >> setUp [
	super setUp.
	currentLogs := MiApplication current logger logs.
	MiApplication current logger logs: OrderedCollection new
]

{ #category : #running }
MiAbstractBrowserTest >> tearDown [
	MiApplication current logger logs: currentLogs.
	super tearDown
]

{ #category : #tests }
MiAbstractBrowserTest >> testAllBrowserHaveATitle [
	concreteBrowsers := MiAbstractBrowser allSubclasses
		reject: #isAbstract.
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
	concreteBrowsers := MiAbstractBrowser allSubclasses reject: #isAbstract.
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
	| objectInstance |
	objectInstance := Object new.
	concreteBrowsers := MiAbstractBrowser allSubclasses reject: #isAbstract.
	concreteBrowsers
		do: [ :browser | 
			self
				shouldnt: [ | browserInstance |
					browserInstance := browser runMe.
					browserInstance selectEntity: objectInstance.
					browserInstance root close ]
				raise: Error ]
]

{ #category : #tests }
MiAbstractBrowserTest >> testCanOpenAllBrowserWithEmptyMooseGroup [
	| mooseGroup |
	mooseGroup := MooseGroup new.
	concreteBrowsers := MiAbstractBrowser allSubclasses reject: #isAbstract.
	concreteBrowsers
		do: [ :browser |
			self
				shouldnt: [ | browserInstance |
					browserInstance := browser runMe.
					browserInstance selectEntity: mooseGroup.
					browserInstance root close ]
				raise: Error ]
]

{ #category : #tests }
MiAbstractBrowserTest >> testCanOpenAllBrowserWithMooseEntity [
	| entity |
	entity := MooseEntity new.
	concreteBrowsers := MiAbstractBrowser allSubclasses reject: #isAbstract.
	concreteBrowsers
		do: [ :browser | 
			self
				shouldnt: [ | browserInstance |
					browserInstance := browser runMe.
					browserInstance selectEntity: entity.
					browserInstance root close ]
				raise: Error ]
]

{ #category : #tests }
MiAbstractBrowserTest >> testCanOpenAllBrowserWithMooseGroup [
	| mooseGroup |
	mooseGroup := MooseGroup with: MooseEntity new.
	concreteBrowsers := MiAbstractBrowser allSubclasses
		reject: #isAbstract.
	concreteBrowsers
		do: [ :browser | 
			self
				shouldnt: [ | browserInstance |
					browserInstance := browser runMe.
					browserInstance selectEntity: mooseGroup.
					browserInstance root close ]
				raise: Error ]
]
