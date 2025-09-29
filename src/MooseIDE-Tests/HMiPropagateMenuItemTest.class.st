Class {
	#name : #HMiPropagateMenuItemTest,
	#superclass : #MiAbstractApplicationTest,
	#category : #'MooseIDE-Tests-Command'
}

{ #category : #tests }
HMiPropagateMenuItemTest >> testPropagateMenuItem [

	| root node visualization shape items |
	root := HNode new name: 'Visualization'.
	node := HNode new
		        name: 'aNode';
		        rawModel: (FamixStClass new
				         name: 'AClass';
				         yourself).
	root add: node.

	visualization := HSimpleVisualizationBuilder new
		                 rootNode: root;
		                 build;
		                 yourself.

	shape := visualization canvas shapeFromModel: node.
	items := (HMenuBuilder new
		          buildIn: MenuMorph new
		          shape: shape
		          visualization: visualization) menuItemsFor: shape.

	self assert: (items
			 detect: [ :menuItem | menuItem class == HMiPropagateMenuItem ]
			 ifNone: [ nil ]) isNotNil
]
