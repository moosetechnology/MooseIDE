"
Characterizes MiArchitecturalMapBuilder's menuInteraction behaviour: which items show for a plain entity node, a tag node, a dependency line, and the canvas background, and why.
"
Class {
	#name : 'MiArchitecturalMenuBuildingTest',
	#superclass : 'MiAbstractMenuBuildingTest',
	#instVars : [
		'plainShape',
		'tagShape',
		'lineShape'
	],
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiArchitecturalMenuBuildingTest >> browserClassToTest [

	^ MiArchitecturalMapBrowser
]

{ #category : 'running' }
MiArchitecturalMenuBuildingTest >> populateMooseModel [ 

	| entity1 entity2 entity3 method1 method2 |
	super populateMooseModel.

	entity1 := model newClassNamed: 'Entity1'.
	entity2 := model newClassNamed: 'Entity2'.
	entity3 := model newClassNamed: 'Entity3'.
	method1 := (model newMethodNamed: 'method1') parentType: entity1.
	method2 := (model newMethodNamed: 'method2') parentType: entity2.
	model newInvocation
		sender: method1;
		candidates: { method2 }.

	entity3 tagWithName: 'aTag'.
]

{ #category : 'running' }
MiArchitecturalMenuBuildingTest >> setUp [

	| tag |
	super setUp.

	tag := model tagNamed: 'aTag'.
	browser specModel instVarNamed: 'tags' put: { tag }.

	browser followEntity: model allModelClasses.
	self rebuildVisualization.

	plainShape := self shapeForEntityNamed: 'Entity1'.
	tagShape := canvas nodes detect: [ :s | s model rawModel = tag ].
	lineShape := canvas lines first
]

{ #category : 'tests' }
MiArchitecturalMenuBuildingTest >> testCanvasMenu [
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
MiArchitecturalMenuBuildingTest >> testLineMenu [
	"Dependency line shape (Entity1 -> Entity2). Rendered items:
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
MiArchitecturalMenuBuildingTest >> testPlainNodeMenu [
	"Entity1 shape: not a tag, and its parent isn't one either (it's a root entity).
	 Rendered items:
	 - 'Expand', 'Expand children', 'Collapse children'
	 - separator
	 - 'Relayout', 'Propagate'
	 - separator
	 - 'New entity', 'Add dependency to'
	 - separator
	 - 'Show all links', 'Hide all links', 'Hide incoming links', 'Hide outgoing links',
	 'Collapse external links', 'Select related entities', 'Select all links',
	 'Select incoming links', 'Select outgoing links'
	 - separator
	 - 'Open node', 'Inspect', 'Remove node'
	 Excluded: 'Show outgoing', 'Show incoming' (neither shape nor parent is a tag)"

	| menu |
	menu := self buildMenuFor: plainShape.

	self
		assert: (menu items collect: #contents) asArray
		equals:
			#( 'Expand' 'Expand children' 'Collapse children'
			   'Relayout' 'Propagate' 'New entity' 'Add dependency to'
			   'Show all links' 'Hide all links' 'Hide incoming links'
			   'Hide outgoing links' 'Collapse external links'
			   'Select related entities' 'Select all links' 'Select incoming links'
			   'Select outgoing links' 'Open node' 'Inspect' 'Remove node' ).
	self assert: menu submorphs size equals: 23
]

{ #category : 'tests' }
MiArchitecturalMenuBuildingTest >> testTagNodeMenu [
	"aTag's own node shape: rawModel isTag is true. Rendered items:
	 - 'Expand', 'Show outgoing', 'Show incoming', 'Expand children', 'Collapse children'
	 - separator
	 - 'Relayout', 'Propagate'
	 - separator
	 - 'New entity', 'Add dependency to'
	 - separator
	 - 'Show all links', 'Hide all links', 'Hide incoming links', 'Hide outgoing links',
	 'Collapse external links', 'Select related entities', 'Select all links',
	 'Select incoming links', 'Select outgoing links'
	 - separator
	 - 'Open node', 'Inspect', 'Remove node'"

	| menu |
	menu := self buildMenuFor: tagShape.

	self
		assert: (menu items collect: #contents) asArray
		equals:
			#( 'Expand' 'Show outgoing' 'Show incoming' 'Expand children'
			   'Collapse children' 'Relayout' 'Propagate' 'New entity'
			   'Add dependency to' 'Show all links' 'Hide all links'
			   'Hide incoming links' 'Hide outgoing links'
			   'Collapse external links' 'Select related entities'
			   'Select all links' 'Select incoming links'
			   'Select outgoing links' 'Open node' 'Inspect' 'Remove node' ).
	self assert: menu submorphs size equals: 25
]
