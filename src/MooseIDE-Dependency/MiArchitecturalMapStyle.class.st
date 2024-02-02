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
MiArchitecturalMapStyle >> createMultiTagBoxSized: aSize [

	| cp |
	cp := RSComposite new.
	cp addAll: ({ 
			 Color red.
			 Color cyan.
			 Color green.
			 Color yellow } collect: [ :color | 
			 RSBox new
				 size: aSize / 2;
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
	(entity notNil and: [ entity isTag not and: [ entity isTagged ] ]) ifTrue: [
		| tag |
		tag := entity allTags first.
		group addFirst: (RSCircle new
				 color: tag color;
				 radius: 7;
				 yourself) ].
	node children ifNotEmpty: [
		| tags |
		tags := node allChildren flatCollectAsSet: [ :childNode | childNode rawModel tags ].
		tags size = 1 ifTrue: [
			group addLast: (RSBox new
					 color: tags anyOne color;
					 size: 14;
					 yourself) ].
		tags size > 1 ifTrue: [ group addLast: (self createMultiTagBoxSized: 14) ] ].
	RSHorizontalLineLayout new
		alignMiddle;
		on: group.
	^ group
]
