Class {
	#name : #MiArchitecturalMapStyle,
	#superclass : #HDefaultStyle,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #'public - hooks' }
MiArchitecturalMapStyle >> boxChildrenColorFor: anHNode [

	^ anHNode level odd
		  ifTrue: [ Color lightGray ]
		  ifFalse: [ Color veryLightGray ]
]

{ #category : #private }
MiArchitecturalMapStyle >> colorFor: node [

	^ node color ifNil: [ (Smalltalk ui theme baseColor) alpha: 0.7 ]
]

{ #category : #hooks }
MiArchitecturalMapStyle >> createMultiTagBox [

	| cp |
	cp := RSComposite new.
	cp addAll: ({
			 Color red.
			 Color cyan.
			 Color green.
			 Color yellow } collect: [ :color |
			 RSBox new
				 size: 7;
				 color: color;
				 yourself ]).
	RSGridLayout new
		lineItemsCount: 2;
		gapSize: 0;
		on: cp children.
	cp adjustToChildren.
	cp border: (RSBorder new
			 color: Color black;
			 width: 1;
			 yourself).
	^ cp
]

{ #category : #hooks }
MiArchitecturalMapStyle >> labelAndIconFor: node [

	| group entity |
	group := super labelAndIconFor: node.
	entity := node rawModel.
	(entity isNotNil and: [ entity isTag not and: [ entity isTagged ] ]) ifTrue: [
		group addFirst: (RSCircle new
				 color: entity tags first color;
				 radius: 7;
				 yourself) ].
	node children ifNotEmpty: [ (self tagIconFor: node) ifNotNil: [ :icon | group addLast: icon ] ].
	RSHorizontalLineLayout new
		alignMiddle;
		on: group.
	^ group
]

{ #category : #hooks }
MiArchitecturalMapStyle >> tagIconFor: node [
	"We could just do a #flatCollectAsSet: of the tags on the #allChildren but this can be pretty long to do. And in the end we just want to know if there is 0, 1 or multiple tags so here is an optimized version.
	
	We optimize because we want to avoid to go to the deepest children when we find tags on upper levels and we also want to avoid collecting all possbile tags when the first children already have some.
	This is ugly code but that improves quite a bit the vizualization speed.
	
	It could be simpler doing: 
	
		| tags |
		tags := node allChildren flatCollectAsSet: [ :childNode | childNode rawModel tags ].
		tags size = 1 ifTrue: [
			^(RSBox new
					 color: tags anyOne color;
					 size: 14;
					 yourself) ].
		tags size > 1 ifTrue: [ ^ self createMultiTagBox ].
		
		^ nil"

	| childrenToCheck foundTag lookupBlock |
	lookupBlock := [ :entity |
	               entity tags ifNotEmpty: [ :tags |
		               tags size = 1
			               ifTrue: [
				               foundTag
					               ifNil: [ foundTag := tags anyOne ]
					               ifNotNil: [ ^ self createMultiTagBox ] ]
			               ifFalse: [ ^ self createMultiTagBox ] ] ].

	childrenToCheck := node children.

	[ childrenToCheck isEmpty ] whileFalse: [
		childrenToCheck do: [ :childNode | lookupBlock value: childNode rawModel ].
		childrenToCheck := childrenToCheck flatCollect: #children ].

	^ foundTag ifNotNil: [
		  ^ RSBox new
			    color: foundTag color;
			    size: 14;
			    yourself ]
]
