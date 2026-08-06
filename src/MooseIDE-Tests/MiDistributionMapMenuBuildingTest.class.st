"
Characterizes the current (pre-refactor) menu-building behaviour of MiDistributionMapBuilder, via MiDistributionMapMenuItem class>>buildIn:shape:visualization:. Golden-master baseline for the menuInteraction/menuItemStrategy unification.

Deliberately subclasses MiAbstractApplicationTest, not MiAbstractBrowserTest: the latter carries ~30 generic browser-behaviour tests irrelevant to menu-building characterization.
"
Class {
	#name : 'MiDistributionMapMenuBuildingTest',
	#superclass : 'MiAbstractApplicationTest',
	#instVars : [
		'browser',
		'builder',
		'canvas',
		'nodeShape'
	],
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiDistributionMapMenuBuildingTest >> buildMenuFor: aShape [
	"Drives the actual menuInteraction block rather than reconstructing its body.
	 RSMenuActivable exposes no public accessor for its menuBlock, so it's reached
	 reflectively; this avoids simulating a real RSMouseRightClick event and the
	 resulting menu popUpInWorld, which onShape: would otherwise require."

	| menu |
	menu := MenuMorph new.
	(builder menuInteraction instVarNamed: 'menuBlock')
		value: menu
		value: aShape.
	^ menu
]

{ #category : 'running' }
MiDistributionMapMenuBuildingTest >> setUp [

	| model classA classB |
	super setUp.

	browser := MiDistributionMapBrowser openForTests: application.

	model := FamixStModel new.
	classA := model newClassNamed: 'ClassA'.
	(model newMethodNamed: 'methodA') parentType: classA.
	classB := model newClassNamed: 'ClassB'.

	browser followEntity: {
			classA.
			classB }.
	builder := browser visualization builder.
	canvas := browser canvas.

	nodeShape := canvas nodes detect: [ :s | s model rawModel = classA ]
]

{ #category : 'running' }
MiDistributionMapMenuBuildingTest >> tearDown [

	browser ifNotNil: [ browser withWindowDo: [ :window | window close ] ].
	super tearDown
]

{ #category : 'tests' }
MiDistributionMapMenuBuildingTest >> testCanvasMenu [
	"Canvas background (non-shape) click.
	Falls back to MiDistributionMapNodeMenuItem itself (no label of its own),
	 shown as a blank entry instead of nothing"

	| menu |
	menu := self buildMenuFor: canvas.

	self assert: (menu items collect: #contents) asArray equals: #( '' ).
	self assert: menu submorphs size equals: 1
]

{ #category : 'tests' }
MiDistributionMapMenuBuildingTest >> testNodeMenu [
	"Node shape (ClassA). Rendered items:
	 - 'Inspect'"

	| menu |
	menu := self buildMenuFor: nodeShape.

	self
		assert: (menu items collect: #contents) asArray
		equals: #( 'Inspect' ).
	self assert: menu submorphs size equals: 1
]
