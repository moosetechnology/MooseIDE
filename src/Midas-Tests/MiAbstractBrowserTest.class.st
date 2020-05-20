Class {
	#name : #MiAbstractBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'concreteBrowser'
	],
	#category : #'Midas-Tests'
}

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
	| mooseGroup mooseEntity |
	mooseEntity := MooseEntity new.
	mooseGroup := MooseGroup new.
	mooseGroup add: mooseEntity. 
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
