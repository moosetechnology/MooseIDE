"
Characterizes MiSystemComplexityBuilder's menuInteraction behaviour: which items show for a leaf class node, a class node with a contained method, an inheritance dependency line, and the canvas background, and why.
"
Class {
	#name : 'MiSystemComplexityMenuBuildingTest',
	#superclass : 'MiAbstractMenuBuildingTest',
	#instVars : [
		'leafShape',
		'richShape',
		'lineShape'
	],
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiSystemComplexityMenuBuildingTest >> browserClassToTest [

	^ MiSystemComplexityBrowser
]

{ #category : 'running' }
MiSystemComplexityMenuBuildingTest >> populateMooseModel [

	| baseClass richClass |
	super populateMooseModel.

	baseClass := model newClassNamed: 'BaseClass'.
	richClass := model newClassNamed: 'RichClass'.
	(model newMethodNamed: 'richMethod') parentType: richClass.
	model newInheritance
		subclass: richClass;
		superclass: baseClass

]

{ #category : 'running' }
MiSystemComplexityMenuBuildingTest >> setUp [

	super setUp.

	browser followEntity: model allModelClasses.
	self rebuildVisualization.

	leafShape := self shapeForEntityNamed: 'BaseClass'.
	richShape := self shapeForEntityNamed: 'RichClass'.
	lineShape := canvas lines first
]

{ #category : 'tests' }
MiSystemComplexityMenuBuildingTest >> testCanvasMenu [
	"Canvas background (non-shape) click. Rendered items:
	 - 'Collapse children', 'Expand children', 'Update tags'
	 - separator
	 - 'Add Container', 'Select', 'Relayout'
	 - separator
	 - 'Show all links', 'Hide all links'
	 Excluded: 'Inspect' (not for the canvas)"

	| menu |
	menu := self buildMenuFor: canvas.

	self
		assert: (menu items collect: #contents) asArray
		equals:
			#( 'Collapse children' 'Expand children' 'Update tags'
			   'Add Container' 'Select' 'Relayout' 'Show all links'
			   'Hide all links' ).
	self assert: menu submorphs size equals: 10
]

{ #category : 'tests' }
MiSystemComplexityMenuBuildingTest >> testLeafNodeMenu [
	"BaseClass shape: no contained entities. Rendered items:
	 - 'Relayout', 'Propagate'
	 - separator
	 - 'New entity', 'Add dependency to'
	 - separator
	 - 'Show all links', 'Hide all links', 'Hide incoming links', 'Hide outgoing links',
	  'Select all links', 'Select incoming links',
	 'Select outgoing links'
	 - separator
	 - 'Inspect', 'Remove node'
	 Excluded: 'Expand', 'Expand children', 'Collapse children', 'Collapse external links',
	 'Open node' (no contained entities)"

	| menu |
	menu := self buildMenuFor: leafShape.

	self
		assert: (menu items collect: #contents) asArray
		equals: #( 'Relayout' 'Propagate' 'New entity' 'Add dependency to'
			   'Show all links' 'Hide all links' 'Hide incoming links'
			   'Hide outgoing links'
			   'Select all links' 'Select incoming links'
			   'Select outgoing links' 'Inspect' 'Remove node' ).
	self assert: menu submorphs size equals: 16
]

{ #category : 'tests' }
MiSystemComplexityMenuBuildingTest >> testLineMenu [
	"Inheritance dependency line shape (RichClass -> BaseClass). Rendered items:
	 - 'Hide link', 'Remove link'
	 - separator
	 - 'Inspect'"

	| menu |
	menu := self buildMenuFor: lineShape.

	self
		assert: (menu items collect: #contents) asArray
		equals: #( 'Hide link' 'Remove link' 'Inspect' ).
	self assert: menu submorphs size equals: 4
]

{ #category : 'tests' }
MiSystemComplexityMenuBuildingTest >> testRichNodeMenu [
	"RichClass shape: has a contained method. Rendered items:
	 - 'Expand', 'Expand children', 'Collapse children'
	 - separator
	 - 'Relayout', 'Propagate'
	 - separator
	 - 'New entity', 'Add dependency to'
	 - separator
	 - 'Show all links', 'Hide all links', 'Hide incoming links', 'Hide outgoing links',
	 'Collapse external links', 'Select all links',
	 'Select incoming links', 'Select outgoing links'
	 - separator
	 - 'Open node', 'Inspect', 'Remove node'"

	| menu |
	menu := self buildMenuFor: richShape.

	self
		assert: (menu items collect: #contents) asArray
		equals:
			#( 'Expand' 'Expand children' 'Collapse children'
			   'Relayout' 'Propagate' 'New entity' 'Add dependency to'
			   'Show all links' 'Hide all links' 'Hide incoming links'
			   'Hide outgoing links' 'Collapse external links'
			   'Select all links' 'Select incoming links'
			   'Select outgoing links' 'Open node' 'Inspect' 'Remove node' ).
	self assert: menu submorphs size equals: 22
]
