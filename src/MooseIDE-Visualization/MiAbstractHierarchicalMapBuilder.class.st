"
I am the common superclass for builders that turn a tree of Moose entities into a hierarchical map of `HNode`s: `MiArchitecturalMapBuilder`, `MiButterflyMapBuilder`, `MiDistributionMapBuilder`, and `MiSystemComplexityBuilder`.

I declare the entity-driven building contract shared by these builders (`elements`, `menuItemStrategy`) so subclasses only need to plug in the parts that differ.
"
Class {
	#name : 'MiAbstractHierarchicalMapBuilder',
	#superclass : 'HSimpleVisualizationBuilder',
	#category : 'MooseIDE-Visualization-Helpers',
	#package : 'MooseIDE-Visualization',
	#tag : 'Helpers'
}

{ #category : 'accessing' }
MiAbstractHierarchicalMapBuilder >> elements [

	^ mapModel entities
]
