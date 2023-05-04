Class {
	#name : #MiHSystemComplexityStyle,
	#superclass : #HDefaultStyle,
	#category : #'MooseIDE-Visualization-System Complexity'
}

{ #category : #'public - hooks' }
MiHSystemComplexityStyle >> borderFor: node [

	^ node hasChildren
		  ifTrue: [ 
			  RSBorder new
				  width: 2;
				  capSquare;
				  joinMiter;
				  color: Smalltalk ui theme textColor;
				  dashArray: #( 5 10 );
				  yourself ]
		  ifFalse: [ 
			  RSBorder new
				  color: Color black translucent;
				  yourself ]
]

{ #category : #hooks }
MiHSystemComplexityStyle >> buildCompositeEmptyNodeIn: shape [

	| node |
	node := shape model.
	node level <= 1 ifTrue: [ 
		shape
			color: Color black;
			border: (self borderFor: node).
		shape schildren: #(  ).

		^ self ].


	super buildCompositeEmptyNodeIn: shape
]
