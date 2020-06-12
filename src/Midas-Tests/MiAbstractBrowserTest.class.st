Class {
	#name : #MiAbstractBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'concreteBrowser',
		'currentLogs'
	],
	#category : #'Midas-Tests'
}

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
	concreteBrowser := MiAbstractBrowser allSubclasses
		reject: #isAbstract.
	concreteBrowser
		do: [ :browser | 
			| browserInstance |
			browserInstance := browser runMe.
			self deny: browserInstance window title equals: 'Untitled window'.
			browserInstance window close ]
]

{ #category : #tests }
MiAbstractBrowserTest >> testCanOpenAllBrowser [
	concreteBrowser := MiAbstractBrowser allSubclasses reject: #isAbstract.
	concreteBrowser
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
	concreteBrowser := MiAbstractBrowser allSubclasses reject: #isAbstract.
	concreteBrowser
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
	concreteBrowser := MiAbstractBrowser allSubclasses reject: #isAbstract.
	concreteBrowser
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
	concreteBrowser := MiAbstractBrowser allSubclasses reject: #isAbstract.
	concreteBrowser
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
	concreteBrowser := MiAbstractBrowser allSubclasses
		reject: #isAbstract.
	concreteBrowser
		do: [ :browser | 
			self
				shouldnt: [ | browserInstance |
					browserInstance := browser runMe.
					browserInstance selectEntity: mooseGroup.
					browserInstance root close ]
				raise: Error ]
]
