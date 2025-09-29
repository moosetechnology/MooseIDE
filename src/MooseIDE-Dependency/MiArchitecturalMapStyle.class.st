Class {
	#name : #MiArchitecturalMapStyle,
	#superclass : #HDefaultStyleWithTags,
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
