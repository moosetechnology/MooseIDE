"
Characterizes MiButterflyMapBuilder's menuInteraction behaviour: which items show for a central node, a leaf wing node, an internal wing node, a dependency line, and the canvas background, and why. Doubles as the regression safety net for the menuItemStrategy unification.
"
Class {
	#name : 'MiButterflyMenuBuildingTest',
	#superclass : 'MiAbstractMenuBuildingTest',
	#instVars : [
		'centralShape',
		'leafShape',
		'richShape',
		'lineShape'
	],
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiButterflyMenuBuildingTest >> browserClassToTest [

	^ MiButterflyMapBrowser
]

{ #category : 'running' }
MiButterflyMenuBuildingTest >> setUp [
	"Central has one method (centralMethod). LeafClient calls it from a method
	 with no further contained entities of its own (leaf wing node). RichClient
	 is a subclass of Central and has its own method (wing node with children)."

	| central centralMethod leafClient leafMethod richClient richMethod |
	super setUp.

	central := model newClassNamed: 'Central'.
	centralMethod := (model newMethodNamed: 'centralMethod') parentType:
		                 central.

	leafClient := model newClassNamed: 'LeafClient'.
	leafMethod := (model newMethodNamed: 'leafCall') parentType:
		              leafClient.
	model newInvocation
		sender: leafMethod;
		candidates: { centralMethod }.

	richClient := model newClassNamed: 'RichClient'.
	richMethod := (model newMethodNamed: 'richMethod') parentType:
		              richClient.
	model newInheritance
		subclass: richClient;
		superclass: central;
		yourself.

	browser followEntity: central.
	self rebuildVisualization.

	centralShape := canvas shapeFromModel: builder centralNode.
	leafShape := canvas nodes detect: [ :s |
		             s model rawModel = leafMethod ].
	richShape := canvas nodes detect: [ :s |
		             s model rawModel = richClient ].
	lineShape := canvas lines first
]

{ #category : 'tests' }
MiButterflyMenuBuildingTest >> testCanvasMenu [
	"Canvas background (non-shape) click. Rendered items:
	 - 'Remove external layer', 'Add layer'
	 - separator
	 - 'ZoomToFit'
	 Excluded: 'Inpsect' (not for the canvas)"

	| menu |
	menu := self buildMenuFor: canvas.

	self
		assert: (menu items collect: #contents) asArray
		equals: #( 'Remove external layer' 'Add layer' 'ZoomToFit' ).
	self assert: menu submorphs size equals: 4
]

{ #category : 'tests' }
MiButterflyMenuBuildingTest >> testCentralNodeMenu [
	"Central node shape. Rendered items:
	 - 'Remove node', 'Expand' (Expand: node has children)
	 - separator
	 - 'Remove dependencies', 'Add dependencies'
	 - separator
	 - separator (even if 'Be central node' is not showing, there is a separator for it)
	 - 'Inpsect'
	 Excluded: 'Be central node' (shape already is the central node)"

	| menu |
	menu := self buildMenuFor: centralShape.

	self
		assert: (menu items collect: #contents) asArray
		equals:
			#( 'Remove node' 'Expand' 'Remove dependencies'
			   'Add dependencies' 'Inpsect' ).
	self assert: menu submorphs size equals: 8
]

{ #category : 'tests' }
MiButterflyMenuBuildingTest >> testLeafNodeMenu [
	"leafCall method shape (no children and not central node). Rendered items:
	 - 'Remove node' ('Expand' excluded because no children)
	 - separator
	 - 'Remove dependencies', 'Add dependencies'
	 - separator
	 - 'Be central node' (shape isn't the central node)
	 - separator
	 - 'Inpsect'"

	| menu |
	menu := self buildMenuFor: leafShape.

	self
		assert: (menu items collect: #contents) asArray
		equals: #( 'Remove node' 'Remove dependencies' 'Add dependencies'
			   'Be central node' 'Inpsect' ).
	self assert: menu submorphs size equals: 8
]

{ #category : 'tests' }
MiButterflyMenuBuildingTest >> testLineMenu [
	"Dependency line shape (Central -> leafCall). Rendered items:
	 - 'Hide link', 'Remove link'
	 - separator
	 - 'Inpsect'"

	| menu |
	menu := self buildMenuFor: lineShape.

	self
		assert: (menu items collect: #contents) asArray
		equals: #( 'Hide link' 'Remove link' 'Inpsect' ).
	self assert: menu submorphs size equals: 4
]

{ #category : 'tests' }
MiButterflyMenuBuildingTest >> testRichNodeMenu [
	"RichClient shape (has children, not central node). Rendered items:
	 - 'Remove node', 'Expand'
	 - separator
	 - 'Remove dependencies', 'Add dependencies'
	 - separator
	 - 'Be central node'
	 - separator
	 - 'Inpsect'"

	| menu |
	menu := self buildMenuFor: richShape.

	self
		assert: (menu items collect: #contents) asArray
		equals:
			#( 'Remove node' 'Expand' 'Remove dependencies'
			   'Add dependencies' 'Be central node' 'Inpsect' ).
	self assert: menu submorphs size equals: 9
]
