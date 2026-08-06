"
Characterizes MiDistributionMapBuilder's menuInteraction behaviour: which items show for a node and for the canvas background, and why. Doubles as the regression safety net for the menuItemStrategy unification.
"
Class {
	#name : 'MiDistributionMapMenuBuildingTest',
	#superclass : 'MiAbstractMenuBuildingTest',
	#instVars : [
		'nodeShape'
	],
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiDistributionMapMenuBuildingTest >> browserClassToTest [

	^ MiDistributionMapBrowser
]

{ #category : 'running' }
MiDistributionMapMenuBuildingTest >> setUp [

	| classA classB |
	super setUp.

	classA := model newClassNamed: 'ClassA'.
	(model newMethodNamed: 'methodA') parentType: classA.
	classB := model newClassNamed: 'ClassB'.

	browser followEntity: {
			classA.
			classB }.
	self rebuildVisualization.

	nodeShape := canvas nodes detect: [ :s | s model rawModel = classA ]
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
